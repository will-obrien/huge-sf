/*
SummarizeEventRegistrations

Summarize Event Registrations by Campaign in order to
Update summary field on Event Campaigns

This program summarizes all Event Registrations.

Created by:	Mark Maslow
Created on: January, 2016
*/
global class SummarizeEventRegistrations implements Database.Batchable<sObject> {
    static Id eventId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([
			SELECT Id FROM Campaign WHERE RecordTypeId = :eventId
		]);
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		Set<Id> campaignIds = new Set<Id>();
		for(sObject obj : scope) {
			Campaign camp = (Campaign)obj;
			campaignIds.add(camp.Id);		
		}
		List<Campaign> campList = new List<Campaign>();
		AggregateResult[] groupedResults = [
  			SELECT
  				Campaign__c, 
  				count(Id)cnt
  			FROM Event_Registration__c
  			WHERE Campaign__c IN :campaignIds
  			AND Status__c != 'Cancelled'
  			GROUP BY Campaign__c
  		];
  		for (AggregateResult ar : groupedResults) {
  			Campaign camp = new Campaign(
  				Id = (Id)ar.get('Campaign__c'),
  				Event_Registration_Count__c = (Integer)ar.get('cnt')
  			);
  			campList.add(camp);
  		}
		update campList;
	}
	global void finish(Database.BatchableContext BC){
	}
}