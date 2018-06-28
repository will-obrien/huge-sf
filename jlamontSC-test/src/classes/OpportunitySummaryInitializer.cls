/*
OpportunitySummaryInitializer

Summarize all Opportunities for all Accounts

Created by:	Mark Maslow
Created on: August 15, 2014
*/
global class OpportunitySummaryInitializer implements Database.Batchable<sObject> {
	OpportunitySummaryCreator summaryCreator = new OpportunitySummaryCreator();

	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([
		SELECT Id
		FROM Account
		]);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<Id> accountIds = new List<Id>();
		for(sObject obj : scope) {
			Account account = (Account) obj;
			accountIds.add(account.Id);
		}
		summaryCreator.summarizeOpportunities(accountIds);
	}

   global void finish(Database.BatchableContext BC){
   }
	
}