/*
FlagAddUpAccounts

Created by: Mark Maslow
Created on: August, 2015

Accounts that have one or more Contacts with AddUp Ids need to be
flagged as AddUp Households.

This class is called by ContactAfterInsert and ContactAfterUpdate triggers
to ensure that Accounts are flagged when AddUp Id (API Name Website_System_Id__c)
is given a value  
*/
public with sharing class FlagAddUpAccounts {
	public static void flagAccounts(List<Contact> contactList, Map<Id, Contact> oldMap) {
		Set<Id> accountIdSet = new Set<Id>();
		for(Contact ctct : contactList) {
			if( ! String.isEmpty(ctct.Website_System_Id__c ) ) {
				if(oldMap == null) {
					accountIdSet.add(ctct.AccountId);
				}
				else {
					Contact oldContact = oldMap.get(ctct.Id);
					if(String.isEmpty(oldContact.Website_System_Id__c)) {
						accountIdSet.add(ctct.AccountId);
					}
				}
			}
		}
		if(accountIdSet.size() > 0) {
			List<Account> accountList = new List<Account>();
			for(Id acctId : accountIdSet) {
				Account acct = new Account();
				acct.Id = acctId;
				acct.AddUp_Household__c = true;
				accountList.add(acct);
			}
			update accountList;
		}
	}
}