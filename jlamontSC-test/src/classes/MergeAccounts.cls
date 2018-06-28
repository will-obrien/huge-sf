/*
MergeAccounts

Created by:	Mark Maslow
Created on: September, 2014

Modified: 3/22/2016 Maslow - Handle situation where retained account has been deleted

Use native SFDC Merge function to merge Accounts
*/
public with sharing class MergeAccounts {
	public static void processAccounts(List<Merge_Request__c> mergeRequestList) {
		List<Merge_Request__c> mergesToUpdate = new List<Merge_Request__c>();
		for(Merge_Request__c request : mergeRequestList) {
			if( ! String.isEmpty(request.Retained_Account__c) ) {
				if(request.Previous_Account__c != request.Retained_Account__c) {
					List<Account> acctList = [SELECT Id, Name FROM Account WHERE Id=:request.Retained_Account__c LIMIT 1];
					if(acctList.size() == 0) {
						request.Error_Message__c = MergeProcessor.appendMergeError(request.Error_Message__c, 'Retained Account Not Found');
					}
					else {
						Account retainedAccount = acctList.get(0);
						Database.MergeResult result = Database.merge(retainedAccount, request.Previous_Account__c, false);
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
			request.Last_Step_Completed__c = MergeProcessor.mergeAccountsStep;
			request.Date_Last_Step_Completed__c = System.now();
			mergesToUpdate.add(request);
		}
		if(mergesToUpdate.size() > 0) {
			update mergesToUpdate;
		}
	}
}