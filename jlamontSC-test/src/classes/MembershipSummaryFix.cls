/*
MembershipSummaryFix

Find Accounts that reference a membership 
with Member_Account__c not equal to Id of Account.

Set Membership__c to null on any Accounts found.

Created by:	Mark Maslow
Created on: December, 2015
*/
global class MembershipSummaryFix implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([
			SELECT Id, Membership__c 
			FROM Account
		]);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<Account> accountList = new List<Account>();
		List<Account> accountsToUpdate = new List<Account>();
		Set<Id> mbrIdSet = new Set<Id>();
		for(sObject obj : scope) {
			Account acct = (Account) obj;
			if(acct.Membership__c != null) {
				accountList.add(acct);
				mbrIdSet.add(acct.Membership__c);
			}
		}
		Map<Id, Membership__c> mbrMap = new Map<Id, Membership__c>([
			select Id, Member_Account__c from Membership__c
			where Id in :mbrIdSet
		]); 
		for(Account acct : accountList) {
			Membership__c mbr = mbrMap.get(acct.Membership__c);
			if(mbr != null) {
				if(acct.Id != mbr.Member_Account__c) {
					accountsToUpdate.add(new Account(Id = acct.Id, Membership__c = null));
				}
			}	
		}	
		if( ! accountsToUpdate.isEmpty()){
			update accountsToUpdate;
		}
	}

	global void finish(Database.BatchableContext BC){
	}
}