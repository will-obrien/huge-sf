/*
MembershipSummaryInitializer

Sets Membership__c for all Accounts that have a Membership.

Created by:	Mark Maslow
Created on: August 20, 2014
*/
global class MembershipSummaryInitializer implements Database.Batchable<sObject> {
	MembershipSummaryCreator summaryCreator = new MembershipSummaryCreator();

	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([
			SELECT Member_Account__c FROM Membership__c
		]);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<Id> accountIds = new List<Id>();
		for(sObject obj : scope) {
			Membership__c membership = (Membership__c) obj;
			accountIds.add(membership.Member_Account__c);
		}
		summaryCreator.summarizeMemberships(accountIds);
	}

	global void finish(Database.BatchableContext BC){
	}
}