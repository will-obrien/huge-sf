//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Handler Class for OpportunityTrigger  
//	8 March 2014     Virendra (Appirio)     Original
//
//  15 August 2014   Maslow
//						Remove code to populate most recent donation date.
//						This has been superceded by code in OpportunitySummaryCreator
//  18 August 2014   Maslow
//						On insert, populate either Proposal_Account__c or Other_Giving_Account__c,
//						depending on record type.
//  25 August 2014   Maslow
//						Recalculate GAU fields for manually entered LIT
//	07 October 2014	 Maslow
//						Execute code on updates as well as inserts
//	10 October 2014  VB
//						Remove BegYrForecast value check between 10/1-12/31
//	09 April   2015  VB
//						Updated Bill Terms 'LIT' reference to Life 'Income Trust--Cash'
//	13 April   2015  VB
//						opportunity name now generated here 
//							The rC Batch Upload appears to blank out workflow-based Opp naming
//							Also removing remaing code in support of Most Recent Donation Date 
//	17 June   2015  VB
//						Added update of GAU values to include donation records processed by Batch Upload
//	30 June   2015  VB
//						Added Code to record SierraRise preference on Contact 
//							when SierraRise donation inserted.
//	29 Sep	  2015  MM  Only plug Batch Upload fields if missing.
//**********************************************************************/
public with sharing class OpportunityTriggerHandler {
	
	static Map<String, Date> forecastingMap = new Map<String, Date>();
	static Id proposalTypeId;
	static Id donationTypeId;
	static Id transctionTypeId;

	static {
		// Find the Custom Setting value for the BegYrForecast lockout field
		for(Forecasting__c f : Forecasting__c.getAll().values()) {
			forecastingMap.put(f.Year__c, f.Beginning_Yr_Forecast_Final_Date__c);
		}
		// Lookup the Opportunity Record Types	
		proposalTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
		donationTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		transctionTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Transaction').getRecordTypeId();
	}
	
	/* 
	// Before an Opportunity is inserted or updated.
	*/
	public static void onBeforeInsertUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap, Boolean isInsert) {
		
		Set<Id> givingGAUs = new Set<Id>();
		Set<Id> accountIds = new Set<Id>();
		Set<Id> campaignIds = new Set<Id>();
		String oppCloseYear = '';
		String oppAccountName = '';
		String oppGAUId = '';

		// A recording location for new SierraRise donations & contacts		
		List<Id> SierraRiseAccountIds = new List<Id>();
		List<Id> contactsToConfirmInsert = new List<Id>();  
		List<Id> NonSierraRiseDonationAccountIds = new List<Id>();
		
		// Build the list of Accounts & Campaigns
		for (Opportunity op:newList) {
			accountIds.add(op.AccountId);
			campaignIds.add(op.CampaignId);
			System.debug('SRTRIG: Op Saved:' + op + '::::');		
			//System.debug('SRTRIG: Op CampaignId Saved:' + op.CampaignId + '::::');		
		}
		// Lookup the Account Names
		Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Name FROM Account WHERE Id IN :accountIds]);

		// Lookup the SierraRise Campaigns ( probably don't need a map for this... but... )
		Map<Id,Campaign> campaignMap = new Map<Id,Campaign>([SELECT Id, SierraRise_Campaign__c FROM Campaign WHERE Id IN :campaignIds AND SierraRise_Campaign__c = true]);

		System.debug('SRTRIG: SierraRise Campaigns Found:' + campaignMap.size() + ':');		

		
		// Opportunities that need to be updated
		List<Opportunity> updateOpportunities = new List<Opportunity>();
		
		for(Opportunity opp:newList){
			
			// Is the Opportunity is a Donation and its Campaign is in the SierraRise campaigns map
			if(opp.RecordTypeId == donationTypeId && campaignMap.containsKey(opp.CampaignId)) {

				System.debug('SRTRIG: SierraRise Donation Found:' + ':');		
				
				// If this opportunity has a Contact specified.
				if(opp.Donor_Contact__c != null) {
					
					System.debug('SRTRIG: SierraRise Donation Found with Contact:' + opp.Donor_Contact__c + ':');
							
					// Save the contact to add them a SierraRise preference
					contactsToConfirmInsert.add(opp.Donor_Contact__c);
				}
			} else if(opp.RecordTypeId == donationTypeId) {	// Still a donation, but not a SierraRise Campaign

				System.debug('SRTRIG: Non-SierraRise Donation Found:' + ':');		
					
				// Save the Account so we can record the Non-SierraRise Donation checkbox on the Account 
				NonSierraRiseDonationAccountIds.add(opp.AccountId);
			}
			
			// VB:3/18/14 - rC Batch Upload does not pre-populate the Giving Name,
			//		this is currently being done via Workflow.  Since the workflow fires late in the 
			//		execution chain, we need some value for now ( which is required on the page layout )
			//		which can be overwritten by the workflow.  Any value should do.
			//		opp.Name = 'asdfasdfasdf';
			//
			// VB:4/13/15 - We are now performing Opportunity naming in the trigger, as opposed to the 
			//		workflow, which was incompatible with the rC Batch Upload.
			oppCloseYear = String.valueOf(opp.CloseDate.year());

			// Shorten the Account name to < 100
			oppAccountName = accountMap.get(opp.AccountId).Name;
			if(oppAccountName.length() > 100) {
				oppAccountName = oppAccountName.substring(100);
			}
			
			// Only display the GAU Id if it's not blank
			if (String.isblank(opp.GAU_ID__c)) {
				oppGAUId = '';
			} else {
				oppGAUId = '-' + opp.GAU_ID__c;
			}
			
			// Builds the Opportunity Name here
			opp.Name = oppCloseYear + '-' + OppAccountName + oppGAUId ;
			
			
			if(isValidGiving(opp, isInsert ? null : oldMap.get(opp.Id))) {
				if(opp.rC_Giving__GAU__c != null){
					givingGAUs.add(opp.rC_Giving__GAU__c);
					updateOpportunities.add(opp);
				}
				// VB: Not needed anymore
				/*
				if(opp.RecordTypeId == donationTypeId && opp.StageName != null && opp.StageName.equalsIgnoreCase('Completed')) {
					accountIds.add(opp.AccountId);
				} else if(!isInsert && opp.RecordTypeId == donationTypeId && oldMap.get(opp.Id).StageName != null && oldMap.get(opp.Id).StageName.equalsIgnoreCase('Completed')) {
					accountIds.add(opp.AccountId);
				} else if(!isInsert && oldMap.get(opp.Id).RecordTypeId == donationTypeId && oldMap.get(opp.Id).StageName != null && oldMap.get(opp.Id).StageName.equalsIgnoreCase('Completed')) {
					accountIds.add(opp.AccountId);
				}
				*/
				//18 Aug Change start
				//07 Oct Change start
				//if(isInsert) {
					if(opp.RecordTypeId == proposalTypeId) {
						opp.Proposal_Account__c = opp.AccountId;
						opp.Proposal_Contact__c = opp.Donor_Contact__c;
					} else {
						opp.Other_Giving_Account__c = opp.AccountId;
						opp.Other_Giving_Contact__c = opp.Donor_Contact__c;
					}
				//}
                //07 Oct Change end
				//18 Aug Change end
			}
		}
		if(!givingGAUs.isEmpty()){
			populateProdTypes(givingGAUs,updateOpportunities,isInsert);
		}
		
		// If there are contacts to be added to SierraRise, process them
		//
		// TODO: Probably break this code into a specific separate class.
		//			This handler is also referenced in ContactAfterUpdateHandler
		//
		if (contactsToConfirmInsert.size() > 0) {

			System.debug('SRTRIG: SierraRise SR Contacts to Insert:' + contactsToConfirmInsert.size() + ':');

			AdvocacyActionTriggerHandler aaTriggerHandler = new AdvocacyActionTriggerHandler();
			aaTriggerHandler.processInsertContacts(contactsToConfirmInsert);
		}

		// If there are Accounts that need to be marked as non-SierraRise Donation, process them
		if (NonSierraRiseDonationAccountIds.size() > 0) {

			System.debug('SRTRIG: Non-SierraRise Accounts to Mark:' + NonSierraRiseDonationAccountIds.size() + ':');

			updateNonSierraRiseDonationAccounts(NonSierraRiseDonationAccountIds);
		}
		
		/*		
		if(accountIds.size() > 0) {
			populateAccountMostRecentDonationDate(accountIds);
		}
		*/
	}
	
	// Marks the passed-in list of Account IDs as Non-SierraRise Exclusive.
	public static void updateNonSierraRiseDonationAccounts(List<Id> accountsToMark) {
	
		List<Account> accountsToUpdate = new List<Account>();
		List<Account> accountList = new List<Account>([SELECT Id, Non_SierraRise_Donor__c FROM Account WHERE Id IN :accountsToMark]);

		// Step through the list of Accounts
		for(Account theAccount : accountList) {

			System.debug('SRTRIG: Account to Mark:' + theAccount.Id + ':');
			
			// If the value is true, set it to false, and safe it off.
			//if (theAccount.Non_SierraRise_Donor__c) {
			if (theAccount.Non_SierraRise_Donor__c == false) {

				System.debug('SRTRIG: Account Marked:' + theAccount.Id + ':');

				theAccount.Non_SierraRise_Donor__c = true;
				accountsToUpdate.add(theAccount);
			}
		}

		System.debug('SRTRIG: Non-SierraRise Accounts to Mark:' + accountsToUpdate.size() + ':');
		
		// If any accounts need to be updated, update them.
		if(accountsToUpdate.size() > 0) {
			update accountsToUpdate;
		}
	}

	
	public static void onAfterDelete(List<Opportunity> newList) {
		
		// VB: 4/14/15 Removing, as this doesn't appear to be used
		//		It was likely part of the Last Donation calculation
		/*
		Set<Id> accountIds = new Set<Id>();
		for(Opportunity opp:newList){
			if(opp.RecordTypeId == donationTypeId && opp.StageName != null && opp.StageName.equalsIgnoreCase('Completed')) {
				accountIds.add(opp.AccountId);
			}
		}
		*/
	}
	
	public static void populateProdTypes(Set<Id> givingGAUs,List<Opportunity> newList,Boolean isInsert){
		Map<Id,rC_Giving__GAU__c> gauGivings = 
				new Map<Id,rC_Giving__GAU__c>([SELECT id, GivingType__c,Recipient__c,FundType__c, Budget_Affecting__c, rC_Giving__Parent__c 
													FROM rC_Giving__GAU__c
		                                            WHERE id IN :givingGAUs]);
		for(Opportunity opp:newList) {
            
            //29 Sep Change Start
            //
			//25 Aug Change start
			//if(opp.RecordTypeId == donationTypeId && opp.BillTerms__c == 'Life Income Trust--Cash') {
			// VB: 6/17/15 - Adding Exception to re-calculate GAU values for Incoming Online Donations processed by Batch Upload
			//if(		opp.RecordTypeId == donationTypeId && 
			//		(opp.BillTerms__c == 'Life Income Trust--Cash' || opp.Source__c == 'Batch Upload')) {
			//	opp.GivingType__c = gauGivings.get(opp.rC_Giving__GAU__c).GivingType__c;
			//	opp.Recipient__c = gauGivings.get(opp.rC_Giving__GAU__c).Recipient__c;
			//	opp.FundType__c = gauGivings.get(opp.rC_Giving__GAU__c).FundType__c;
			//}
			//25 Aug Change end
		
            if(opp.RecordTypeId == donationTypeId) {
				if(opp.BillTerms__c == 'Life Income Trust--Cash') {
					opp.GivingType__c = gauGivings.get(opp.rC_Giving__GAU__c).GivingType__c;
					opp.Recipient__c = gauGivings.get(opp.rC_Giving__GAU__c).Recipient__c;
					opp.FundType__c = gauGivings.get(opp.rC_Giving__GAU__c).FundType__c;
                }
                else if(opp.Source__c == 'Batch Upload') {
					opp.GivingType__c = gauGivings.get(opp.rC_Giving__GAU__c).GivingType__c;
                    if(String.isEmpty(opp.Recipient__c)) {
						opp.Recipient__c = gauGivings.get(opp.rC_Giving__GAU__c).Recipient__c;
                    }
                    if(String.isEmpty(opp.FundType__c)) {
						opp.FundType__c = gauGivings.get(opp.rC_Giving__GAU__c).FundType__c;
                    }
                }
            }
			//29 Sep Change end
			
			if(isInsert){
				if(opp.RecordTypeId != transctionTypeId && opp.RecordTypeId != donationTypeId) {
					opp.GivingType__c = gauGivings.get(opp.rC_Giving__GAU__c).GivingType__c;
					opp.Recipient__c = gauGivings.get(opp.rC_Giving__GAU__c).Recipient__c;
					opp.FundType__c = gauGivings.get(opp.rC_Giving__GAU__c).FundType__c;
				}
				opp.Budget_Affecting__c = gauGivings.get(opp.rC_Giving__GAU__c).Budget_Affecting__c ? 'Budget-Affecting' : 'Non-Budget Affecting';
				opp.Parent_General_Accounting_Unit__c = gauGivings.get(opp.rC_Giving__GAU__c).rC_Giving__Parent__c;
			}else{
				if(opp.RecordTypeId != transctionTypeId && opp.RecordTypeId != donationTypeId) {
					if(opp.GivingType__c != gauGivings.get(opp.rC_Giving__GAU__c).GivingType__c){
						opp.GivingType__c = gauGivings.get(opp.rC_Giving__GAU__c).GivingType__c;
					}
					
					if(opp.Recipient__c != gauGivings.get(opp.rC_Giving__GAU__c).Recipient__c){
						opp.Recipient__c = gauGivings.get(opp.rC_Giving__GAU__c).Recipient__c;
					}
					
					if(opp.FundType__c != gauGivings.get(opp.rC_Giving__GAU__c).FundType__c){
						opp.FundType__c = gauGivings.get(opp.rC_Giving__GAU__c).FundType__c;
					}
				}
				opp.Budget_Affecting__c = gauGivings.get(opp.rC_Giving__GAU__c).Budget_Affecting__c ? 'Budget-Affecting' : 'Non-Budget Affecting';
				if(opp.Parent_General_Accounting_Unit__c != gauGivings.get(opp.rC_Giving__GAU__c).rC_Giving__Parent__c){
					opp.Parent_General_Accounting_Unit__c = gauGivings.get(opp.rC_Giving__GAU__c).rC_Giving__Parent__c;
				}
			}
		}                                            
 	}
 	
/*
 	private static void populateAccountMostRecentDonationDate(Set<Id> accountIds) {
 		Map<Id, Account> accDateMap = new Map<Id, Account>();
 		
 		for(Opportunity oppty : [SELECT AccountId, CloseDate FROM Opportunity WHERE AccountId IN : accountIds 
 																		AND RecordTypeId =: donationTypeId AND StageName = 'Completed'
 																		ORDER BY CloseDate desc]) {
 			if(!accDateMap.containsKey(oppty.AccountId)){
 				accDateMap.put(oppty.AccountId, new Account(Id = oppty.AccountId, Most_Recent_Donation_Date__c = oppty.CloseDate));
 			}
 		}
 		
 		if(accDateMap.values().Size() > 0) {
 			try{
 				update accDateMap.values();
 			}catch(Exception e) {
 				Trigger.new[0].addError(e.getMessage());
 			}
 		}
 	}
*/ 	

	/*
	// This class attempts to prevent the entry/update of the BegYrForecast at inappropriate times.
	//	VB: It appears to be marginally successful.
	*/
 	private static Boolean isValidGiving(Opportunity newGiving, Opportunity oldGiving) {

		/*
		//
		// VB: 2015/08/12 - Quick fix to allow 2016 Proposals to have BegYearForecasts
		// VB:WARNING: This is a TEMPORARY non-permanent solution!
		//
		//
		// If this is an insert
		if(oldGiving == null && newGiving.Beginning_Yr_Forecast__c != null) {

			// Prevent all inserts of Beginning Year Forecast
			newGiving.Beginning_Yr_Forecast__c.addError('Beginning Year Forecast can not be set on insert.');
			return false;
			
		} else { // Update

			// If the proposal's old close year was prior to 2016 AND had a BegYearForecast AND the new BegYearForecast is changed
			if(oldGiving.CloseDate.year() <= 2015 && oldGiving.Beginning_Yr_Forecast__c != null && newGiving.Beginning_Yr_Forecast__c != oldGiving.Beginning_Yr_Forecast__c ) {
				
					// Fail, they're trying to adjust an existing proposal
 					newGiving.Beginning_Yr_Forecast__c.addError('Beginning Year Forecast on pre-2016 proposals can not be updated.');
 					return false;
			}
			
		}
		*/
 		String closeYear;
 		//Date sDate, eDate;
 		if(newGiving.RecordTypeId == proposalTypeId) {
 			closeYear = String.valueOf(newGiving.CloseDate.year());
 			if(forecastingMap.containsKey(closeYear)) {
 				//sDate = Date.newInstance((Integer.valueOf(closeYear) - 1), 10, 1);
 				//eDate = Date.newInstance((Integer.valueOf(closeYear) - 1), 12, 31);

                // VB:10/30/14: Removing this check per BC request
 				//if(Date.today() >= sDate && Date.today() <= eDate && newGiving.Beginning_Yr_Forecast__c == null && oldGiving == null) {
 				//	newGiving.Beginning_Yr_Forecast__c.addError('Beginning Year Forecast can not be empty!');
 				//	return false;
 				//}
 				if(Date.today() >= forecastingMap.get(closeYear) && newGiving.Beginning_Yr_Forecast__c != null && oldGiving == null) {
 					newGiving.Beginning_Yr_Forecast__c.addError('Beginning Year Forecast can not be set after ' + forecastingMap.get(closeYear).format() + ' for closing year ' + closeYear + '.');
 					return false;
 				}
 				if(Date.today() >= forecastingMap.get(closeYear) && oldGiving != null && newGiving.Beginning_Yr_Forecast__c != oldGiving.Beginning_Yr_Forecast__c) {
 					newGiving.Beginning_Yr_Forecast__c.addError('Beginning Year Forecast can not be updated after ' + forecastingMap.get(closeYear).format() + ' for closing year ' + closeYear + '.');
 					return false;
 				}
 			}
 		}
 		
 		return true;
 	}
}