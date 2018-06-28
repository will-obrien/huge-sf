/*
OpportunitySummaryInitializer

Initialize new fields on Opportunity - Proposal_Account__c and Other_Giving_Account__c

Created by:	Mark Maslow
Created on: August 19, 2014
*/
global class OpportunityProposalAccountInitializer implements Database.Batchable<sObject> {
	static Id proposalTypeId;

	static {
		proposalTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
	}

	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([
		SELECT Id, AccountId, RecordTypeId, Proposal_Account__c, Other_Giving_Account__c
		FROM Opportunity
		WHERE Proposal_Account__c = null AND Other_Giving_Account__c = null
		]);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<Opportunity> oppList = new List<Opportunity>();
		for(sObject obj : scope) {
			Opportunity opp = (Opportunity) obj;
			if(opp.RecordTypeId == proposalTypeId) {
				opp.Proposal_Account__c = opp.AccountId;
			}
			else {
				opp.Other_Giving_Account__c = opp.AccountId;
			}
			oppList.add(opp);
		}
		Database.update(oppList, false);
	}

   global void finish(Database.BatchableContext BC){
   }
}