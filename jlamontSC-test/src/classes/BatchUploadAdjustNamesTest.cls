@isTest
public with sharing class BatchUploadAdjustNamesTest {
    static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    static testMethod void myUnitTest() {
        Account account1 = new Account(
            Name='Unknown',
            RecordTypeId = accountHouseholdTypeId
        );
        insert account1;
        
        Contact contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Sam',
            LastName = 'Unknown',
            RecordTypeId = contactHouseholdTypeId
        );
        insert contact1;

	    rC_Connect__Batch_Upload__c testBU = new rC_Connect__Batch_Upload__c(
			Name = 'BatchUploadAdjustNamesTest001',
			rC_Connect__Batch_Upload_Account_Matched__c = account1.Id,
			rC_Connect__Batch_Upload_Contact_1_Matched__c = contact1.Id,
			rC_Connect__Batch_Upload_Status__c = 'New',
			rC_Connect__Contact_1_First_Name__c = 'TestFN',
			rC_Connect__Contact_1_Last_Name__c = 'TestLN'
	    ); 
    	insert testBU;
    	
    	testBU.rC_Connect__Batch_Upload_Status__c = 'Committed';
    	update testBu;
    	
    	Account acct = [select Id, Name from Account where Id = :account1.Id];
    	System.assertEquals('TestFN TestLN', acct.Name);
    	
    	Contact ct = [select Id, FirstName, LastName from Contact where Id = :contact1.Id];
    	System.assertEquals('TestFN', ct.FirstName);
    	System.assertEquals('TestLN', ct.LastName);
    }
}