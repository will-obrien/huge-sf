//******************************************************************************************
//
//  Acct_Campaign_CRU_OnCampaignMember
//
//  Creates an Account-Campaign Custom Rollup record when a Campaign Member record is
//		added or updated and its Status value is set to 'Attended'.
//  Deletes an Account-Campaign Custom Rollup record when the Campaign Member record is
//		deleted or its status is changed from 'Attended' to any other status value.
//
//  NOTE: This trigger is used to support the KP Healthcheck Score. Specifically, it
// 			creates custom rollup records with data used to Rollup the total number of 
//			Open Enrollment training hrs taken by a contact associated with an account 
//			that is a KP Account.
//
//  This trigger was developed for Microsystems by InSitu Software LLC.
//   
//  History:
//  InSitu    01/12/2010    Original version
// ******************************************************************************************

trigger Acct_Campaign_CRU_OnCampaignMember on CampaignMember (before delete, after insert, after update) 
{
	// The primary criteria being checked in the criteria is whether the Status is being set
	// to or from a particular value. For the Open Enrollment Training hours calculation, the
	// status value is 'Attended'. Put this in a local variable just in case it should change.
	final string sStatusCriteriaValue = 'Attended';
	
	// ---------------------------------------------------------------------------------	
	// The Contact and Campaign objects are not populated when the trigger is called.
	// Only the IDs are provided. Therefore, we need separate query calls to get the 
	// object values used in the criteria. To properly bulkify this trigger, put the 
	// ids in a set and do a single query for each of the Contact and Campaign records.
	// Place the results in a map for easy look-up.			
	// ---------------------------------------------------------------------------------	
	Set<ID> setCampaignIDs = new Set<ID>();
	Set<ID> setContactIDs = new Set<ID>();
	
	CampaignMember[] listIterate = (Trigger.isDelete == true) ? Trigger.old : Trigger.new;

	// Iterate the campaign member records and populate the Contact and Campaign sets with IDs.
	for (Integer i = 0; i < listIterate.size(); i++)
	{
		// Only process if New/Update trigger AND current Status value is Attended 
		// OR
		// Update/Delete trigger and OLD status value is Attended. 
		if ( ((Trigger.isInsert == true || Trigger.isUpdate == true) && Trigger.new[i].Status == sStatusCriteriaValue)
				||
			 ((Trigger.isDelete == true || Trigger.isUpdate == true) && Trigger.old[i].Status == sStatusCriteriaValue))
		{
			// If its a delete trigger, get info from the previous version of the campaign member object.
			if (Trigger.isDelete == true)
			{
				if (Trigger.old[i].ContactId != null)
					setContactIDs.add(Trigger.old[i].ContactId)	;			
				if (Trigger.old[i].CampaignId != null)
					setCampaignIDs.add(Trigger.old[i].CampaignId);			
			}
			else
			{
				if (Trigger.new[i].ContactId != null)
					setContactIDs.add(Trigger.new[i].ContactId)	;			
				if (Trigger.new[i].CampaignId != null)
					setCampaignIDs.add(Trigger.new[i].CampaignId);			
			}
		}
	}
	
	// Make sure there is something to do. If not, then exit.
	if (setCampaignIDs.size() == 0 || setContactIDs.size() == 0)
	{
		// nothing to do.
		system.debug('InSitu Test: No campaign member records to process.');
		return;
	}
	
	// Populate the associated contact and campaign objects - store in a map for easy lookup.
	Map<ID, Campaign> mapCampaigns = new Map<ID, Campaign>
		([SELECT ID, Name, Product_Line__c, StartDate, EndDate FROM Campaign WHERE ID in :setCampaignIDs]);
		
	Map<ID, Contact> mapContacts = new Map<ID, Contact>
		([SELECT id, Account.ID, Account.KP_Account__c FROM Contact WHERE ID in :setContactIDs]);


	// Create a list of Acct-Campaign CRU objects to insert.
	List<acct_campaign_custom_rollup__c> listCRU_Insert = new List<acct_campaign_custom_rollup__c>();

	// Create a set of Acct-Campaign CRU object ids (in string format) to delete.
	Set<String> setCRU_Delete = new Set<String>();
	
	// Iterate the campaign member records to determine if we need to create or delete CRU records.
	// To properly bulkify the trigger, create the items and place in a collection. Then perform the single
	// DML statement for the items in the collection.
	for (Integer i = 0; i < listIterate.size(); i++)
	{
		// Only process if New and Updated AND current Status value is Attended OR
		// Update and Delete and OLD status value is Attended. 
		if ( ((Trigger.isInsert == true || Trigger.isUpdate == true) && Trigger.new[i].Status == sStatusCriteriaValue)
				||
			 ((Trigger.isDelete == true || Trigger.isUpdate == true) && Trigger.old[i].Status == sStatusCriteriaValue))
		{
			// Use local variables to hold values for comparison purposed when evaluating criteria.
			// This way, the conditional statements that check the criteria are in one single place.
			Campaign campaignCompare = mapCampaigns.get(Trigger.isDelete == true ? Trigger.old[i].CampaignID : Trigger.new[i].CampaignID);
			Contact	 contactCompare = mapContacts.get(Trigger.isDelete == true ? Trigger.old[i].ContactID : Trigger.new[i].ContactID);
			ID idCampaignMember = (Trigger.isDelete == true) ? Trigger.old[i].ID : Trigger.new[i].ID;
			String sProductLineUpper = campaignCompare.Product_Line__c != null ? campaignCompare.Product_Line__c.toUpperCase() : '';
			
			system.debug('InSitu Test: contactCompare.Account.KP_Account__c = ' + contactCompare.Account.KP_Account__c);
			system.debug('InSitu Test: campaignCompare.Name = ' + campaignCompare.Name);
			system.debug('InSitu Test: campaignCompare.Product_Line__c = ' + campaignCompare.Product_Line__c);
				
			// The following conditions must be met:
			// 1. The account associated with the contact must be a KP Account
			// 2. The Campaign name must start with 'Open Enrollment'.
			// 3. The Campaign Product Line must include KP, Docxtools v6 or Skills Assessment
			if (contactCompare.Account.KP_Account__c == 'Yes' &&
				campaignCompare.Name.toUpperCase().startsWith('OPEN ENROLLMENT') &&
				(sProductLineUpper.contains('KP') ||
				 sProductLineUpper.contains('DOCXTOOLS V6') ||
				 sProductLineUpper.contains('SKILLS ASSESSMENT')))
			{
				Integer iNumHrs;
				Date dateStart;
				
				// If the Campaign member is being added or updated to sStatusCriteriaValue, then create a new CRU record
				// with the proper campaign start date and number of hours.
				if (Trigger.isInsert == true ||
					(Trigger.isUpdate == true && Trigger.old[i].Status != sStatusCriteriaValue))
				{					
					// Calc number of days between start and end date - inclusive.
					// Multiply number of days by 8 to get total hrs.
					iNumHrs = (campaignCompare.StartDate.daysBetween(campaignCompare.EndDate) + 1) * 8;
					
					// Start date is the campaign start date.
					dateStart = campaignCompare.StartDate;

					// Create a new Account-Campaign CRU record.
					acct_campaign_custom_rollup__c newAcctCampaignCRU = new acct_campaign_custom_rollup__c(
																				Account__c = contactCompare.Account.ID, 
																				Contact__c = contactCompare.ID,
																				Campaign__c = campaignCompare.ID,
																				Campaign_Member_ID__c = String.valueOf(idCampaignMember),
																				Campaign_Start_Date__c = dateStart,
																				Campaign_Hours__c = iNumHrs);
					// Add new record to the collection															
					listCRU_Insert.add(newAcctCampaignCRU);
					
					system.debug('InSitu Test: New Acct Campaign CRU added to list.');
				}
				else if (Trigger.isDelete ||
						 (Trigger.isUpdate == true && Trigger.old[i].Status == sStatusCriteriaValue))
				{
					// Convert the id to a string (since we can't store a reference to a Campaign Member object in the CRU object).
					setCRU_Delete.add(String.valueOf(idCampaignMember));
				}
			}
		}
	}
	
	// Insert the new Account-Case records
	if (listCRU_Insert.size() > 0)
	{
		system.debug('InSitu Test: Number of AcctCampaign Records to insert = ' + listCRU_Insert.size());
		insert listCRU_Insert;
	}

	// Delete the new Account-Case records
	if (setCRU_Delete.size() > 0)
	{
		// Create a list of Acct-Campaign CRU objects to insert.
		for (List<acct_campaign_custom_rollup__c> listCRU_Delete : [SELECT ID FROM acct_campaign_custom_rollup__c
																	WHERE Campaign_Member_ID__c in :setCRU_Delete])
		{
			system.debug('InSitu Test: Number of AcctCampaign Records to delete = ' + listCRU_Delete.size());
			delete listCRU_Delete;
		}																	
	}
}