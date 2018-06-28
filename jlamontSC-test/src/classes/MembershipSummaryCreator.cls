/*
MembershipSummaryCreator

Method summarizeMemberships takes a list of Account Ids. 
The summarizeMemberships method sets lookup field on Account.

This method is called by MembershipTrigger when a new Membership is inserted.
It is also called by MembershipSummaryInitializer, which is used to set Membership for all Accounts that have one.

Created by:	Mark Maslow
Created on: August 15, 2014

Modified by: Mark Maslow - December, 2015

Handle updates - Account may change on a membership record.
*/
public with sharing class MembershipSummaryCreator {
	public void afterInsert(List<Membership__c> membershipList) {
		List<Id> accountIds = new List<Id>();
		for(Membership__c membership : membershipList) {
			accountIds.add(membership.Member_Account__c);
		}
		summarizeMemberships(accountIds);
	}
	public void afterUpdate(List<Membership__c> membershipList, Map<Id,Membership__c> oldMap) {
		List<Account> accountsToUpdate = new List<Account>();
		for(Membership__c newMbr : membershipList) {
			Membership__c oldMbr = oldMap.get(newMbr.Id);
			if(oldMbr != null) {
				if(newMbr.Member_Account__c != oldMbr.Member_Account__c) {
					Account oldAcct = new Account(
						Id = oldMbr.Member_Account__c,
						Membership__c = null
					);
					Account newAcct = new Account(
						Id = newMbr.Member_Account__c,
						Membership__c = newMbr.Id
					);
					if(oldAcct.Id != null) {
						accountsToUpdate.add(oldAcct);
					}
					accountsToUpdate.add(newAcct);
				}
			}			
		}
		if( ! accountsToUpdate.isEmpty()) {
			update accountsToUpdate;
		}
	}
	public void summarizeMemberships(List<Id> accountIds) {
		List<Account> accountList = new List<Account>();
		Set<Id> updatedAccountIds = new Set<Id>();
		List<Membership__c> membershipList = new List<Membership__c> (
		[
			SELECT Id, Member_Account__c 
			FROM Membership__c
			WHERE Member_Account__c IN :accountIds
			ORDER BY Member_Account__c, Membership_Active__c desc, Expiration_Date__c desc
		]);
		
		for(Membership__c mbr : membershipList) {
			if( ! updatedAccountIds.contains(mbr.Member_Account__c)) {
				Account account = new Account(
					Id = mbr.Member_Account__c,
					Membership__c = mbr.Id 
				);
				accountList.add(account);
				updatedAccountIds.add(account.Id);
			}
		}
		
		update accountList;
	}
}