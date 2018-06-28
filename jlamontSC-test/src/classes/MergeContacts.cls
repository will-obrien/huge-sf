/*
MergeContacts

Created by:	Mark Maslow
Created on: September, 2014

Use native SFDC Merge function to merge Contacts
*/
public with sharing class MergeContacts {
	public static void processContacts(List<Merge_Request__c> mergeRequestList) {
		List<Merge_Request__c> mergesToUpdate = new List<Merge_Request__c>();
		for(Merge_Request__c request : mergeRequestList) {
			if(request.Previous_Contact__c != null) {
				if(request.Previous_Contact__c != request.Retained_Contact__c) {
					if(String.isEmpty(request.Retained_Contact__c)) {
						Database.DeleteResult dr = Database.delete(request.Previous_Contact__c, false);
						if( ! dr.isSuccess()) {
							for(Database.Error err : dr.getErrors()) {
								String errorMessage = err.getMessage();
								request.Error_Message__c = MergeProcessor.appendMergeError(request.Error_Message__c, errorMessage);
					        }				
						}
					}
					else {
						Contact retainedContact = 
							[SELECT Id, LastName, FirstName FROM Contact WHERE Id=:request.Retained_Contact__c LIMIT 1];
						if(retainedContact != null) {
							Database.MergeResult result = Database.merge(retainedContact, request.Previous_Contact__c, false);
							if( ! result.isSuccess()) {
								for(Database.Error err : result.getErrors()) {
									String errorMessage = err.getMessage();
									if(errorMessage != 'entity is deleted') {
										request.Error_Message__c = MergeProcessor.appendMergeError(request.Error_Message__c, errorMessage);
									} 
						        }				
							}
						}
					}
				}
			}			
			request.Last_Step_Completed__c = MergeProcessor.mergeContactsStep;
			request.Date_Last_Step_Completed__c = System.now();
			mergesToUpdate.add(request);
		}
		if(mergesToUpdate.size() > 0) {
			update mergesToUpdate;
		}
	}
}