/*
FindGiftCampaignsToSummarize

Find Opportunities that have been inserted or updated since specified date.

For each Campaign of specified type found in Opportunities,
insert a row into CampaignToSummarize. 

After all Campaigns have been inserted into CampaignToSummarize,
start batch program SummarizeGiftCampaigns to update summary fields in Campaign.

Constructor takes:
	1. Record type of Campaign, which should be either "Donation Form" or "Promotion"
	2. Minimum Close Date of Opportunities to summarize.

Created by:	Mark Maslow
Created on: January, 2016
*/
global class FindGiftCampaignsToSummarize implements Database.Batchable<sObject>, Database.Stateful {
	private Date minDate;
	private String recordTypeToSummarize;
	private Id lastCampaignId;
	private List<CampaignToSummarize__c> campList = new List<CampaignToSummarize__c>();

	public FindGiftCampaignsToSummarize (String recordType, Date minDate) {
		this.recordTypeToSummarize = recordType;
		this.minDate = minDate;
	}
	global Database.QueryLocator start(Database.BatchableContext BC){
		String sql;
		if(recordTypeToSummarize == 'Promotion') {
			sql = 
			'SELECT CampaignId ' +
			'FROM Opportunity ' +
			'WHERE CloseDate >= :minDate ' +
			'ORDER BY CampaignId';
		}
		else if(recordTypeToSummarize == 'Donation Form') {
			sql = 
			'SELECT Form_Campaign__c ' +
			'FROM Opportunity ' +
			'WHERE CloseDate >= :minDate ' +
			'ORDER BY Form_Campaign__c';
		}
		return Database.getQueryLocator(sql);
	}
		
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		Id idToCompare;
		
		for(sObject obj : scope) {
			Opportunity opp = (Opportunity)obj;
			if(recordTypeToSummarize == 'Promotion') {
				idToCompare = opp.CampaignId;
			}
			else {
				idToCompare = opp.Form_Campaign__c;
			}			
			
            if(lastCampaignId == null) {
                lastCampaignId = idToCompare;
            }
			if(idToCompare != lastCampaignId) {
				campList.add(new CampaignToSummarize__c(Campaign__c = lastCampaignId));
				lastCampaignId = idToCompare;
			}
		}
		if( ! campList.isEmpty() ) {
			insert campList;
			campList.clear();
		}
	}
	global void finish(Database.BatchableContext BC) {
		if(lastCampaignId != null) {
			campList.add(new CampaignToSummarize__c(Campaign__c = lastCampaignId));
			insert campList;
		}
		Database.executeBatch(new SummarizeGiftCampaigns(recordTypeToSummarize), 1000);
	}
}