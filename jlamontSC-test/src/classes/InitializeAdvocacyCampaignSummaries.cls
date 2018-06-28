/*
InitializeAdvocacyCampaignSummaries

Summarize Advocacy Actions by Related Action Campaign in order to
Update summary fields on Action Campaigns

Created by:	Mark Maslow
Created on: January, 2016
*/
global class InitializeAdvocacyCampaignSummaries implements Database.Batchable<sObject>, Database.Stateful {
	private Id lastRelatedActionId;
	private Date firstDate, lastDate;
	private Integer totalCount=0;
    private List<Campaign> campaignsToUpdate = new List<Campaign>();
	
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
        	SELECT Id, kwac__Related_Action__c, Action_Date__c
        	FROM kweos__EOCS_Data__c 
        	ORDER BY kwac__Related_Action__c
        ]);
    }
    global void execute(Database.BatchableContext BC,List<kweos__EOCS_Data__c> scope) {
    	for(kweos__EOCS_Data__c aa : scope) {
	    	if(lastRelatedActionId == null) {
	    		lastRelatedActionId = aa.kwac__Related_Action__c;
	    	}
	    	if(aa.kwac__Related_Action__c != lastRelatedActionId) {
	    		processBreak();
	    		lastRelatedActionId = aa.kwac__Related_Action__c;
	    	}
	    	if(firstDate == null) {
	    		firstDate = aa.Action_Date__c; 
	    	}
	    	else if(aa.Action_Date__c < firstDate) {
	    		firstDate = aa.Action_Date__c;
	    	}
	    	if(lastDate == null) {
	    		lastDate = aa.Action_Date__c; 
	    	}
	    	else if(aa.Action_Date__c > lastDate) {
	    		lastDate = aa.Action_Date__c;
	    	}
	    	totalCount ++;
    	}
    	if( ! campaignsToUpdate.isEmpty() ) {
    		update campaignsToUpdate;
    		campaignsToUpdate.clear();
    	}
    }
    private void processBreak() {
    	Campaign campToUpdate = new Campaign(
    		Id = lastRelatedActionId,
    		First_Advocacy_Action_Date__c = firstDate,
    		Last_Advocacy_Action_Date__c = lastDate,
    		Advocacy_Action_Count__c = totalCount
    	);
    	campaignsToUpdate.add(campToUpdate);
    	firstDate = null;
    	lastDate = null;
    	totalCount = 0;
    }
    global void finish(Database.BatchableContext BC) {
    	processBreak();
    	if( ! campaignsToUpdate.isEmpty() ) {
    		update campaignsToUpdate;
    	}
    }
}