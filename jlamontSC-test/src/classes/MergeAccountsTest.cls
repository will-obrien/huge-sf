@IsTest
public with sharing class MergeAccountsTest {
    static Id accountHouseholdTypeId;
    static Account account1, account2, account3, account4;
    static List<Account> accountList = new List<Account>();

    static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    }

    @IsTest
    static void testMergeAccounts() {
        account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
        );
        account2 = new Account(
            Name='Account2',
            RecordTypeId = accountHouseholdTypeId
        );
        account3 = new Account(
            Name='Account3',
            RecordTypeId = accountHouseholdTypeId
        );
        account4 = new Account(
            Name='Account4',
            RecordTypeId = accountHouseholdTypeId
        );
        accountList.add(account1);
        accountList.add(account2);
        accountList.add(account3);
        accountList.add(account4);
        insert accountList;
        
        List<Merge_Request__c> requestList = new List<Merge_Request__c>();
        
        Merge_Request__c request1 = new Merge_Request__c(
            Retained_Account__c = account1.Id, 
            Previous_Account__c = account2.Id           
        );
        Merge_Request__c request2 = new Merge_Request__c(
            Retained_Account__c = account3.Id, 
            Previous_Account__c = account4.Id           
        );
        
        requestList.add(request1);
        requestList.add(request2);
        insert requestList;
        
        delete account3;
        
        Test.startTest();
        MergeAccounts.processAccounts(requestList);
        Test.stopTest();
        
        List<Merge_Request__c> processedMerges = new List<Merge_Request__c>([
            SELECT Id, Error_Message__c, Last_Step_Completed__c, Date_Last_Step_Completed__c FROM Merge_Request__c
        ]); 
        
        Set<Id> requestIds = new Set<Id>();
        for(Merge_Request__c req : processedMerges) {
        	requestIds.add(req.Id);
        	if(req.Id == request1.Id) {
	            System.assertEquals(MergeProcessor.mergeAccountsStep, req.Last_Step_Completed__c);
	            System.assert(req.Date_Last_Step_Completed__c != null);
        	}
        	else if(req.Id == request2.Id) {
        		System.assertEquals('Retained Account Not Found', req.Error_Message__c);
        	}
        }
        System.assert(requestIds.contains(request1.Id));
        System.assert(requestIds.contains(request2.Id));
        
        List<Account> processedAccounts = new List<Account>([
            SELECT Id, Name FROM Account
        ]);
        
        Set<Id> accountIds = new Set<Id>();
        for(Account acct : processedAccounts) {
        	accountIds.add(acct.Id);
        }
        System.assert(accountIds.contains(account1.Id));
        System.assert(accountIds.contains(account4.Id));
        System.assert(processedAccounts.size() == 2);
    }
}