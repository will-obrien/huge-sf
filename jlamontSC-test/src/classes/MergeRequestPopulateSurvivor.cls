/*
MergeRequestPopulateSurvivor

Created by: Mark Maslow
Created on: September, 2014

When Merge Requests are created, the Contacts and Accounts that are to be merged away
are updated with the Id of the survivor.

Called by MergeRequestTrigger

Modification History
10/2015 Maslow wipe out email fields and tokens for previous contact
*/
public with sharing class MergeRequestPopulateSurvivor {
	public static void populateSurvivor(List<Merge_Request__c> requestList) {
		Map<Id, Merge_Request__c> prevAccountToRequestMap = new Map<Id, Merge_Request__c>();
		Map<Id, Merge_Request__c> prevContactToRequestMap = new Map<Id, Merge_Request__c>();
		for(Merge_Request__c request : requestList) {
			if(request.Previous_Account__c != request.Retained_Account__c) {
				prevAccountToRequestMap.put((Id)request.Previous_Account__c, request);
			}
			prevContactToRequestMap.put((Id)request.Previous_Contact__c, request);
		}
		List<Contact> contactsToUpdate = new List<Contact>();
		List<Contact> contactList = new List<Contact>([
			SELECT 
				Id, 
				Merge_Survivor__c,
				rC_Bios__Assistant_Email__c,
				rC_Bios__Home_Email__c,
				rC_Bios__Other_Email__c,
				rC_Bios__Preferred_Email__c,
				rC_Bios__Work_Email__c,
				rC_Connect__Public_Token__c,
				kwzd__KWD_Encrypted_Action_Id__c
			FROM Contact 
			WHERE Id IN :prevContactToRequestMap.keySet()
		]);
		for(Contact ctct : contactList) {
			Merge_Request__c request = prevContactToRequestMap.get((Id)ctct.Id);
			if(request != null) {
				ctct.Merge_Survivor__c = request.Retained_Contact__c;
				ctct.rC_Bios__Assistant_Email__c = null;
				ctct.rC_Bios__Home_Email__c = null;
				ctct.rC_Bios__Other_Email__c = null;
				ctct.rC_Bios__Preferred_Email__c = null;
				ctct.rC_Bios__Work_Email__c = null;
				ctct.rC_Connect__Public_Token__c = null;
				ctct.kwzd__KWD_Encrypted_Action_Id__c = null;
				contactsToUpdate.add(ctct);
			}
		}
		update contactList;
		
		List<Account> accountsToUpdate = new List<Account>();
		List<Account> accountList = new List<Account>([
			SELECT Id, Merge_Survivor__c FROM Account WHERE Id IN :prevAccountToRequestMap.keySet()
		]);
		for(Account acct : accountList) {
			Merge_Request__c request = prevAccountToRequestMap.get((Id)acct.Id);
			if(request != null) {
				acct.Merge_Survivor__c = request.Retained_Account__c;
				accountsToUpdate.add(acct);
			}
		}
		update accountList;
	}
}