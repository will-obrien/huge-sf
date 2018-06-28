/*
MergeProcessorTest

Created by:		Mark Maslow
Creation Date:	September, 2014
*/
@IsTest
public with sharing class MergeProcessorTest {
	@IsTest
	static void testMerge() {
		Account account1, account2;
		Contact contact1, contact2;
		List<Account> accounts = new List<Account>();
		List<Contact> contacts = new List<Contact>();
		
		account1 = new Account(Name='Account1');
		account2 = new Account(Name='Account2');
		accounts.add(account1);
		accounts.add(account2);
		insert accounts;
		
		contact1 = new Contact(AccountId=account1.Id, LastName='Contact1');
		contact2 = new Contact(AccountId=account2.Id, LastName='Contact2');
		contacts.add(contact1);
		contacts.add(contact2);
		insert contacts;

		List<Merge_Request__c> requestList = new List<Merge_Request__c>();
		Merge_Request__c request8 = new Merge_Request__c(
			Previous_Account__c = account1.Id,
			Retained_Account__c = account2.Id,
			Previous_Contact__c = contact1.Id, 
			Retained_Contact__c = contact2.Id
		);
		requestList.add(request8);
		
		insert requestList;
		Test.startTest();
		Database.executeBatch(new MergeProcessor());
		Test.stopTest();
		
		List<Merge_Request__c> resultList = new List<Merge_Request__c>([
			SELECT 
				Last_Step_Completed__c,
				Error_Message__c
			FROM Merge_Request__c
		]);
		for(Merge_Request__c req : resultList) {
			System.debug('Error_Message__c:' + req.Error_Message__c);
			System.assertEquals(MergeProcessor.finalStep, req.Last_Step_Completed__c);
		}		
	}			
}