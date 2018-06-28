/*
SummarizeGiftCampaigns

Summarize Opportunities by Campaign in order to
Update summary fields on Gift Campaigns

Constructor takes:
	1. Record type of Campaign, which should be either "Donation Form" or "Promotion"

Created by:	Mark Maslow
Created on: January, 2016
*/
global class SummarizeGiftCampaigns implements Database.Batchable<sObject>, Database.Stateful {
	private String typeToSummarize;
	private Id lastCampaignId;
	private Date firstDate, lastDate;
	private Integer totalCount=0;
	private Decimal totalAmount=0;
	private List<Campaign> campaignsToUpdate = new List<Campaign>();

	public SummarizeGiftCampaigns(String typeToSummarize) {
		this.typeToSummarize = typeToSummarize;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		Id donationTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		Id membershipTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
		String sql;

		List<CampaignToSummarize__c> campList = [
			SELECT Campaign__c FROM CampaignToSummarize__c
		];
		Set<Id> campSet = new Set<Id>();
		for(CampaignToSummarize__c camp : campList) {
			campSet.add(camp.Campaign__c);
		}

		if(typeToSummarize == 'Promotion') {
			sql = 
			'SELECT Id, CampaignId, CloseDate, rC_Giving__Closed_Amount__c ' +
			'FROM Opportunity ' +
			'WHERE CampaignId IN :campSet ' +
			'AND RecordTypeId IN (:donationTypeId, :membershipTypeId) ' +
			'AND GivingType__c IN (\'Donations\', \'Membership\', \'Membership upgrade\') ' +
			'ORDER BY CampaignId, CloseDate DESC';
		}
		else if(typeToSummarize == 'Donation Form') {
			sql = 
			'SELECT Form_Campaign__c, CloseDate, rC_Giving__Closed_Amount__c ' +
			'FROM Opportunity ' +
			'WHERE Form_Campaign__c IN :campSet ' +
			'AND RecordTypeId IN (:donationTypeId, :membershipTypeId) ' +
			'AND GivingType__c IN (\'Donations\', \'Membership\', \'Membership upgrade\') ' +
			'ORDER BY Form_Campaign__c, CloseDate DESC';
		}
		return Database.getQueryLocator(sql);
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		for(sObject obj : scope) {
			Opportunity opp = (Opportunity)obj;
			if( (typeToSummarize == 'Promotion' && opp.CampaignId != null) ||
			    (typeToSummarize == 'Donation Form' && opp.Form_Campaign__c != null) ) {
				if(lastCampaignId == null) {
					if(typeToSummarize == 'Promotion') {
						lastCampaignId = opp.CampaignId;
					}
					else {
						lastCampaignId = opp.Form_Campaign__c;
					}
				}
				else {
					if(typeToSummarize == 'Promotion') {
						if(opp.CampaignId != lastCampaignId) {
							processCampaignBreak(campaignsToUpdate);
							lastCampaignId = opp.CampaignId;
						}
					}
					else {
						if(opp.Form_Campaign__c != lastCampaignId) {
							processCampaignBreak(campaignsToUpdate);
							lastCampaignId = opp.Form_Campaign__c;
						}
					}
				}
				totalAmount += opp.rC_Giving__Closed_Amount__c;
				totalCount += 1;
				if(firstDate == null || opp.CloseDate < firstDate) {
					firstDate = opp.CloseDate;
				}
				if(lastDate == null || opp.CloseDate > lastDate) {
					lastDate = opp.CloseDate;
				}
			}
		}
		if( ! campaignsToUpdate.isEmpty()) {
			update campaignsToUpdate;
			campaignsToUpdate.clear();
		}
	}

	private void processCampaignBreak(List<Campaign> campaignsToUpdate) {
		Campaign camp;
		if(lastCampaignId != null) {
			if(typeToSummarize == 'Promotion') {
				camp = new Campaign(
					Id = lastCampaignId,
		  			First_Source_Giving_Date__c = firstDate,
		  			Last_Source_Giving_Date__c = lastDate,
		  			Total_Source_Giving_Count__c = totalCount,
		  			Total_Source_Giving_Amount__c = totalAmount
				);
			}
			else {
				camp = new Campaign(
					Id = lastCampaignId,
		  			First_Form_Giving_Date__c = firstDate,
		  			Last_Form_Giving_Date__c = lastDate,
		  			Total_Form_Giving_Count__c = totalCount,
		  			Total_Form_Giving_Amount__c = totalAmount
				);
			}
			campaignsToUpdate.add(camp);
		}
		firstDate = null;
		lastDate = null;
		totalCount = 0;
		totalAmount = 0;
	}

	global void finish(Database.BatchableContext BC){
		processCampaignBreak(campaignsToUpdate);
		if( ! campaignsToUpdate.isEmpty()) {
			update campaignsToUpdate;
		}
	}
}