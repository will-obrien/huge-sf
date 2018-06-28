/*
//Name              : BatchUploadBeforeInsertUpdate
//Created By        : Mark Maslow
//Created Date      : March, 2016
//Description       : Trigger Hander called by BatchUpload Trigger, before insert and before update
						Batch Upload process should not match to accounts or contacts that are to be merged away.
						If Batch Upload is matched to an account or contact that has a merge survivor,
						remove the match.
*/
public with sharing class BatchUploadBeforeInsertUpdate {
	public static Boolean processingComplete = false;
	public static void process(List<rC_Connect__Batch_Upload__c> buList) {
		if(processingComplete) {
			return;
		}
		Set<Id> accountIdSet = new Set<Id>();
		Set<Id> contactIdSet = new Set<Id>();
		for(rC_Connect__Batch_Upload__c bu : buList) {
			if(bu.rC_Connect__Batch_Upload_Contact_1_Matched__c != null) {
				contactIdSet.add(bu.rC_Connect__Batch_Upload_Contact_1_Matched__c);
			}
			if(bu.rC_Connect__Batch_Upload_Account_Matched__c != null) {
				accountIdSet.add(bu.rC_Connect__Batch_Upload_Account_Matched__c);				
			}
		}
		Map<Id, Contact> contactMap = new Map<Id, Contact>([
			select Id, Merge_Survivor__c
			from Contact
			where Id in :contactIdSet
		]);
		Map<Id, Account> accountMap = new Map<Id, Account>([
			select Id, Merge_Survivor__c
			from Account
			where Id in :accountIdSet
		]);
		for(rC_Connect__Batch_Upload__c bu : buList) {
			Boolean clearMatches = false;
			if(bu.rC_Connect__Batch_Upload_Contact_1_Matched__c != null) {
				Contact ctct = contactMap.get(bu.rC_Connect__Batch_Upload_Contact_1_Matched__c);
				if(ctct != null) {
					if(ctct.Merge_Survivor__c != null) {
						clearMatches = true;
					}
				}
			}
			if(bu.rC_Connect__Batch_Upload_Account_Matched__c != null) {
				Account acct = accountMap.get(bu.rC_Connect__Batch_Upload_Account_Matched__c);
				if(acct != null) {
					if(acct.Merge_Survivor__c != null) {
						clearMatches = true;
					}
				}
			}
			if(clearMatches) {
				bu.rC_Connect__Batch_Upload_Contact_1_Matched__c = null;
				bu.rC_Connect__Batch_Upload_Account_Matched__c = null;
			}
		}					
		processingComplete = true;
	}
}