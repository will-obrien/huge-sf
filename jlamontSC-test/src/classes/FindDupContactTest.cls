@IsTest
public with sharing class FindDupContactTest {
	static Id accountHouseholdTypeId;
	static Id contactHouseholdTypeId;

	static Account account1, account2, account3;
	static Contact contact1, contact2, contact3, contact4, contact5, contact6;

	static {
		accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	}
	
	@isTest
	static void testFindDupContact() {
		List<Account> accountList = new List<Account>();
		account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId
			);
		accountList.add(account1);
		account2 = 
			new Account(
				Name='Account2',
				RecordTypeId = accountHouseholdTypeId
			);
		accountList.add(account2);
		account3 = 
			new Account(
				Name='Account3',
				RecordTypeId = accountHouseholdTypeId
			);
		accountList.add(account3);
		
		insert accountList;

		List<Contact> contactList = new List<Contact>();
		contact1 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact1',
				RecordTypeId = contactHouseholdTypeId
			);
		contactList.add(contact1);	
		contact2 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact1',
				RecordTypeId = contactHouseholdTypeId
			);
		contactList.add(contact2);	
		contact3 =
			new Contact(
				AccountId = account2.Id,
				FirstName = 'Test',
				LastName = 'Contact3',
				RecordTypeId = contactHouseholdTypeId
			);
		contactList.add(contact3);	
		contact4 =
			new Contact(
				AccountId = account2.Id,
				FirstName = 'Test',
				LastName = 'Contact4',
				RecordTypeId = contactHouseholdTypeId
			);
		contactList.add(contact4);	
		contact5 =
			new Contact(
				AccountId = account3.Id,
				FirstName = 'Test',
				LastName = 'Contact5',
				RecordTypeId = contactHouseholdTypeId
			);
		contactList.add(contact5);	
		contact6 =
			new Contact(
				AccountId = account3.Id,
				FirstName = 'Test',
				LastName = 'Contact5',
				RecordTypeId = contactHouseholdTypeId
			);
		contactList.add(contact6);	

		insert contactList;
		
		Test.startTest();
		Database.executeBatch(new FindDupContacts());
		Test.stopTest();
		
		List<PotentialDupContact__c> dupList = new List<PotentialDupContact__c>([
		 	SELECT Account__c, Contact1__c, Contact2__c
		 	FROM PotentialDupContact__c
		]);
		System.assertEquals(2, dupList.size());
		
		PotentialDupContact__c dup1;
		PotentialDupContact__c dup2;
		PotentialDupContact__c dupError;
		
		for(PotentialDupContact__c dup : dupList) {
			if(dup.Account__c == account1.Id) {
				dup1 = dup;
			}
			else if(dup.Account__c == account3.Id) {
				dup2 = dup;
			}
			else {
				dupError = dup;
			}	
		}
		System.assertEquals(contact1.Id, dup1.Contact1__c);
		System.assertEquals(contact2.Id, dup1.Contact2__c);
		
		System.assertEquals(contact5.Id, dup2.Contact1__c);
		System.assertEquals(contact6.Id, dup2.Contact2__c);
		
		System.assertEquals(null, dupError);
	}
	
}