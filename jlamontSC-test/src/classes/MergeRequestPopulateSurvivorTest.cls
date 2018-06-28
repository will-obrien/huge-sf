@IsTest
public with sharing class MergeRequestPopulateSurvivorTest {
	@IsTest
	public static void testPopulateSurvivor() {
		Account account1, account2;
		Contact contact1, contact2;
		List<Account> accounts = new List<Account>();
		List<Contact> contacts = new List<Contact>();
		
		account1 = new Account(Name='Account1');
		account2 = new Account(Name='Account2');
		accounts.add(account1);
		accounts.add(account2);
		insert accounts;
		
		contact1 = new Contact(
			AccountId=account1.Id, 
			LastName='Contact1',
			rC_Bios__Assistant_Email__c = 'asst@abc.xyz',
			rC_Bios__Home_Email__c = 'home@abc.xyz',
			rC_Bios__Other_Email__c = 'other@abc.xyz',
			rC_Bios__Preferred_Email__c = 'Home',
			rC_Bios__Work_Email__c = 'work@abc.xyz'
		);
		contact2 = new Contact(AccountId=account2.Id, LastName='Contact2');
		contacts.add(contact1);
		contacts.add(contact2);
		insert contacts;

		List<Merge_Request__c> requestList = new List<Merge_Request__c>();
		Merge_Request__c request1 = new Merge_Request__c(
			Previous_Account__c = account1.Id,
			Retained_Account__c = account2.Id,
			Previous_Contact__c = contact1.Id, 
			Retained_Contact__c = contact2.Id
		);
		requestList.add(request1);
		
		Test.startTest();
		insert requestList;
		Test.stopTest();
		
		Account account1After = [SELECT Id, Merge_Survivor__c FROM Account WHERE Id = :account1.Id];
		System.assertEquals(account2.Id, account1After.Merge_Survivor__c);
		
		Contact contact1After = [
			SELECT Id, 
				Merge_Survivor__c,
				rC_Bios__Assistant_Email__c,
				rC_Bios__Home_Email__c,
				rC_Bios__Other_Email__c,
				rC_Bios__Preferred_Email__c,
				rC_Bios__Work_Email__c,
				Email
			FROM Contact WHERE Id = :contact1.Id];
		System.assertEquals(contact2.Id, contact1After.Merge_Survivor__c);
		System.assertEquals(null, contact1After.rC_Bios__Assistant_Email__c);
		System.assertEquals(null, contact1After.rC_Bios__Home_Email__c);
		System.assertEquals(null, contact1After.rC_Bios__Other_Email__c);
		System.assertEquals(null, contact1After.rC_Bios__Preferred_Email__c);
		System.assertEquals(null, contact1After.rC_Bios__Work_Email__c);
		System.assertEquals(null, contact1After.Email);
	}
}