/*
InitializeGiftCampaignSummary

Begin process to 
Summarize Opportunities by Campaign in order to
Update summary fields on Gift Campaigns

This program will remove any rows in object CampaignToSummarize
and then initiate run of FindGiftCampaignsToSummarize.

Constructor takes:
	1. Record type of Campaign, which should be either "Donation Form" or "Promotion"
	2. Minimum Close Date of Opportunities to summarize.

Created by:	Mark Maslow
Created on: January, 2016
*/
global class InitializeGiftCampaignSummary implements Database.Batchable<sObject>, Database.Stateful {
	private String recordTypeToSummarize;
	private Date minDate;

	public InitializeGiftCampaignSummary(String recordTypeToSummarize, Date minDate) {
		this.recordTypeToSummarize = recordTypeToSummarize;
		this.minDate = minDate;
	}

	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([
			SELECT Id FROM CampaignToSummarize__c
		]);
	}
		
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<CampaignToSummarize__c> campList = new List<CampaignToSummarize__c>();
		for(sObject obj : scope) {
			campList.add((CampaignToSummarize__c)obj);
		}
		delete campList;
	}
	
	global void finish(Database.BatchableContext BC) {
		Database.executeBatch(new FindGiftCampaignsToSummarize(recordTypeToSummarize, minDate), 1000);
	}
}