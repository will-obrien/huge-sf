/*
BatchUploadAdjustNames

When batch upload is updated such that:

rC_Connect__Batch_Upload_Status__c = 'Committed' and
rC_Connect__Batch_Upload_Account_Matched__c contains 'Unknown'

Update Account in rC_Connect__Batch_Upload_Account_Matched__c, 
Name = rC_Connect__Contact_1_First_Name__c space rC_Connect__Contact_1_Last_Name__c

When batch upload is updated such that:

rC_Connect__Batch_Upload_Status__c = 'Committed' and
(rC_Connect__Batch_Upload_Contact_1_Matched__c FirstName is 'Supporter' or
rC_Connect__Batch_Upload_Contact_1_Matched__c LastName is 'Unknown')

Update Contact in rC_Connect__Batch_Upload_Contact_1_Matched__c, 
FirstName = rC_Connect__Contact_1_First_Name__c and LastName = rC_Connect__Contact_1_Last_Name__c

Maslow - December, 2015
*/
public with sharing class BatchUploadAdjustNames {
	public static Boolean namesAdjusted = false;
	public static void adjustNames(List<rC_Connect__Batch_Upload__c> newList, Map<Id, rC_Connect__Batch_Upload__c> oldMap) {
		Set<Id> accountIdSet = new Set<Id>();
		Set<Id> contactIdSet = new Set<Id>();
		for(rC_Connect__Batch_Upload__c bu : newList) {
			if(bu.rC_Connect__Batch_Upload_Status__c == 'Committed') {
				namesAdjusted = true;
				if(oldMap.get(bu.Id).rC_Connect__Batch_Upload_Status__c != 'Committed') {
					String lastName = bu.rC_Connect__Contact_1_Last_Name__c;
					if( ! String.isEmpty(lastName)) {
						if( ! lastName.toLowerCase().contains('unknown')) {
							accountIdSet.add(bu.rC_Connect__Batch_Upload_Account_Matched__c);
							contactIdSet.add(bu.rC_Connect__Batch_Upload_Contact_1_Matched__c);
						}
					}
				}
			}
		}
		List<Account> accountList = [
			select Id, Name from Account where Id in :accountIdSet
		];
		Map<Id, Account> accountMap = new Map<Id, Account>(accountList);
		
		List<Account> accountsToUpdate = new List<Account>();
		for(rC_Connect__Batch_Upload__c bu : newList) {
			Account acct = accountMap.get(bu.rC_Connect__Batch_Upload_Account_Matched__c);
			if(acct != null) {
				if(acct.Name.toLowerCase().contains('unknown')) {
					Account updt = new Account(
						Id=acct.Id,
						Name=bu.rC_Connect__Contact_1_First_Name__c + ' ' + bu.rC_Connect__Contact_1_Last_Name__c
					);
					accountsToUpdate.add(updt);
				}
			}
		}

		List<Contact> contactList = [
			select Id, FirstName, LastName from Contact where Id in :contactIdSet
		];
		Map<Id, Contact> contactMap = new Map<Id, Contact>(contactList);
		
		List<Contact> contactsToUpdate = new List<Contact>();
		for(rC_Connect__Batch_Upload__c bu : newList) {
			Contact ctct = contactMap.get(bu.rC_Connect__Batch_Upload_Contact_1_Matched__c);
			if(ctct != null) {
				if(String.isEmpty(ctct.FirstName) ||
					ctct.FirstName.toLowerCase().equals('supporter') || 
					ctct.LastName.toLowerCase().equals('unknown')) {
					Contact ctctUpdt = new Contact(
						Id=ctct.Id,
						FirstName = bu.rC_Connect__Contact_1_First_Name__c,
						LastName = bu.rC_Connect__Contact_1_Last_Name__c
					);
					contactsToUpdate.add(ctctUpdt);
				}
			}
		}

		if( ! accountsToUpdate.isEmpty() ) {
			update accountsToUpdate;
		}
		if( ! contactsToUpdate.isEmpty() ) {
			update contactsToUpdate;
		}
	}
}