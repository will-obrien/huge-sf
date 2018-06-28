/*
MergeSetup

Created by: Mark Maslow
Created on: September, 2014

Check integrity of Merge Requests prior to processing them.
*/
public with sharing class MergeSetup {
    public static void setUpMerge(List<Merge_Request__c> requestList) {
        List<Merge_Request__c> mergeUpdates = new List<Merge_Request__c>();
        Set<Id> previousContacts = new Set<Id>();
        Set<Id> retainedContacts = new Set<Id>();
        Set<Id> retainedAccounts = new Set<Id>();
        for(Merge_Request__c request : requestList) {
            if(String.isEmpty(request.Previous_Account__c)) {
                request.Error_Message__c = 'Previous Account Missing';
            }
            /*
            else if(String.isEmpty(request.Retained_Account__c)) {
                request.Error_Message__c = 'Retained Account Missing';
            }
            */
            else if((request.Previous_Account__c != request.Retained_Account__c) && (retainedAccounts.contains(request.Previous_Account__c))) {
                request.Error_Message__c = 'Another request has this Previous Account as Retained';
            }
            else if(String.isEmpty(request.Previous_Contact__c)) {
            	if( ! String.isEmpty(request.Retained_Contact__c)) {
                    request.Error_Message__c = 'Request has Retained Contact but no Previous Contact';
            	}
            }
            else if(previousContacts.contains(request.Previous_Contact__c)) {
                    request.Error_Message__c = 'Another request found for Previous Contact';
                }
            
            if( ! String.isEmpty(request.Retained_Account__c)) {
            	if( ! request.Retained_Accounts_Match__c) {
            		request.Error_Message__c = 'Retained Accounts do not match';
            	}
            }
            if( ! String.isEmpty(request.Retained_Contact__c)) {
            	if( ! request.Retained_Contacts_Match__c) {
            		request.Error_Message__c = 'Retained Contacts do not match';
            	}
            }

            retainedAccounts.add(request.Retained_Account__c);
            if( ! String.isEmpty(request.Previous_Contact__c)) {
                previousContacts.add(request.Previous_Contact__c);
                retainedContacts.add(request.Retained_Contact__c);
            }

            request.Last_Step_Completed__c = MergeProcessor.setupStep;
            request.Date_Last_Step_Completed__c = System.now();
            mergeUpdates.add(request);
        }
        if(mergeUpdates.size() > 0) {
            update MergeUpdates;
        }
    }   
}