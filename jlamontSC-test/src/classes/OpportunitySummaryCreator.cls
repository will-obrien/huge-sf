/*
OpportunitySummaryCreator

Method summarizeOpportunities takes a list of Account Ids. 
The method summarizes all Opportunities for each Account, 
and upates summary fields on the Account.

This method is called by OpportunityTrigger every time one or more Opportunities for an Account is inserted, update or deleted.
It is also called by OpportunitySummaryInitializer, which is used to summarize all Opportunities for all Accounts.

Created by:	Mark Maslow
Created on: August 15, 2014

1/2015 - Maslow 
Remove check for StageName. New version of RoundCause will reset StageName to "Open" if date is in the future.
Summarize Opportunities only for Record Types Donations and Memberships.

1/2016 - Maslow
Add Largest Donation Date
*/
public with sharing class OpportunitySummaryCreator {

	static Id donationTypeId;
	static Id membershipTypeId;
	Opportunity lastDonation;
	Date firstDonationDate, lastMembershipDate, largestDonationDate;
	Decimal totalDonationAmount=0, totalMembershipAmount=0;
	Decimal largestDonationAmount=0, largestMembershipAmount=0, lastMembershipAmount=0;
	Integer totalDonationCount=0;
	Decimal total2012=0, total2013=0, total2014=0, total2015=0, total2016=0, total2017=0, total2018=0, total2019=0, total2020=0;
	List<Account> accountsToUpdate = new List<Account>();
	Map<Id, Id> membershipMap = new Map<Id, Id>();
	
	static {
		donationTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		membershipTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
	}

	public void summarizeOpportunities(List<Id> accountIds) {
		List<Opportunity> opList = new List<Opportunity>(
			[SELECT Id, AccountId, rC_Giving__GAU__c, CloseDate, GivingType__c, rC_Giving__Closed_Amount__c, CampaignId, External_Id__c
			 FROM Opportunity
			 WHERE AccountId IN :accountIds
			 AND RecordTypeId IN (:donationTypeId, :membershipTypeId)
			 AND GivingType__c IN ('Donations', 'Membership', 'Membership upgrade')
			 //AND StageName = 'Completed'
			 ORDER BY AccountId, CloseDate DESC
			]
		);
		Id lastAccountId = null;
		for(Opportunity opp : opList) {
			if(lastAccountId == null) {
				lastAccountId = opp.AccountId;
			}
			if(lastAccountId != opp.AccountId) {
				processAccountBreak(lastAccountId);
				lastAccountId = opp.AccountId;
			}
			if(opp.GivingType__c.startsWith('Donation')) {
				if(lastDonation == null) {
					lastDonation = opp;
				}
				else if(opp.CloseDate > lastDonation.CloseDate) {
					lastDonation = opp;
				}
				else if(opp.CloseDate == lastDonation.CloseDate) {
					if(opp.rC_Giving__Closed_Amount__c > lastDonation.rC_Giving__Closed_Amount__c) {
						lastDonation = opp;
					}
					else if(opp.External_ID__c > lastDonation.External_ID__C) {
						lastDonation = opp;
					}
				}

				if(firstDonationDate == null) {
					firstDonationDate = opp.CloseDate;
				}
				else if(opp.CloseDate < firstDonationDate) {
					firstDonationDate = opp.CloseDate;
				}
	
				if(opp.rC_Giving__Closed_Amount__c > largestDonationAmount) {
					largestDonationAmount = opp.rC_Giving__Closed_Amount__c;
					largestDonationDate = opp.CloseDate;
				}
				
				totalDonationCount += 1;
				totalDonationAmount += opp.rC_Giving__Closed_Amount__c;
				
				if(opp.CloseDate.year() == 2012) {
					total2012 += opp.rC_Giving__Closed_Amount__c;
				}
				else if(opp.CloseDate.year() == 2013) {
					total2013 += opp.rC_Giving__Closed_Amount__c;
				}
				else if(opp.CloseDate.year() == 2014) {
					total2014 += opp.rC_Giving__Closed_Amount__c;
				}
				else if(opp.CloseDate.year() == 2015) {
					total2015 += opp.rC_Giving__Closed_Amount__c;
				}
				else if(opp.CloseDate.year() == 2016) {
					total2016 += opp.rC_Giving__Closed_Amount__c;
				}
				else if(opp.CloseDate.year() == 2017) {
					total2017 += opp.rC_Giving__Closed_Amount__c;
				}
				else if(opp.CloseDate.year() == 2018) {
					total2018 += opp.rC_Giving__Closed_Amount__c;
				}
				else if(opp.CloseDate.year() == 2019) {
					total2019 += opp.rC_Giving__Closed_Amount__c;
				}
				else if(opp.CloseDate.year() == 2020) {
					total2020 += opp.rC_Giving__Closed_Amount__c;
				}
			}
			else if(opp.GivingType__c.startsWith('Membership')) {
				if(lastMembershipDate == null) {
					lastMembershipDate = opp.CloseDate; 
					lastMembershipAmount = opp.rC_Giving__Closed_Amount__c;
				}
				else if(opp.CloseDate > lastMembershipDate) {
					lastMembershipDate = opp.CloseDate; 
					lastMembershipAmount = opp.rC_Giving__Closed_Amount__c;
				}
				
				if(opp.rC_Giving__Closed_Amount__c > largestMembershipAmount) {
					largestMembershipAmount = opp.rC_Giving__Closed_Amount__c;
				}
				
				totalMembershipAmount += opp.rC_Giving__Closed_Amount__c;
			}
		}
		if(lastAccountId != null) {
			processAccountBreak(lastAccountId);
			update accountsToUpdate;
		}
	}
	
	private void processAccountBreak(Id accountId) {
		Id lastDonationId;
		Id lastDonationGAU;
		Id lastDonationCampaign;
		
		if(lastDonation == null) {
			lastDonationId = null;
			lastDonationGAU = null;
			lastDonationCampaign = null;
		}
		else {
			lastDonationId = lastDonation.Id;
			lastDonationGAU = lastDonation.rC_Giving__GAU__c;
			lastDonationCampaign = lastDonation.CampaignId;
		}
		
		accountsToUpdate.add(new Account(
			Id=accountId,
			Last_Donation__c = lastDonationId,
			First_Donation_Date__c = firstDonationDate,
			Total_Donation_Count__c = totalDonationCount,
			Total_Donation_Amount__c = totalDonationAmount,
			Largest_Donation_Amount__c = largestDonationAmount,
			Last_Donation_GAU__c = lastDonationGAU,
			Last_Donation_Primary_Campaign_Source__c = lastDonationCampaign,
			Total_Donations_2012__c = total2012,
			Total_Donations_2013__c = total2013,
			Total_Donations_2014__c = total2014,
			Total_Donations_2015__c = total2015,
			Total_Donations_2016__c = total2016,
			Total_Donations_2017__c = total2017,
			Total_Donations_2018__c = total2018,
			Total_Donations_2019__c = total2019,
			Total_Donations_2020__c = total2020,
			Total_Membership_Amount__c = totalMembershipAmount,
			Largest_Membership_Amount__c = largestMembershipAmount,
			Last_Membership_Amount__c = lastMembershipAmount,
			Largest_Donation_Date__c = largestDonationDate
		));
		
		lastDonation = null;
		firstDonationDate = null;
		totalDonationCount = 0;
		totalDonationAmount = 0;
		largestDonationAmount = 0;
		total2012 = 0;
		total2013 = 0;
		total2014 = 0;
		total2015 = 0;
		total2016 = 0;
		total2017 = 0;
		total2018 = 0;
		total2019 = 0;
		total2020 = 0;
		totalMembershipAmount = 0;
		largestMembershipAmount = 0;
		lastMembershipAmount = 0;
		lastMembershipDate = null;
		largestDonationDate = null;
	}
}