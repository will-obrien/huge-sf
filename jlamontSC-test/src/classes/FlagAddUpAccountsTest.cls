@isTest
private class FlagAddUpAccountsTest {
	static Id accountHouseholdTypeId;
	static Id contactHouseholdTypeId;
	static Account account1, account2;
	static Contact contact1, contact2;

	static {
		accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	}

    static testMethod void myUnitTest() {
    	setupAccounts();
    	Account testAccount1 = [select Id, AddUp_Household__c from Account where Id = :account1.Id];
    	System.assertEquals(false, testAccount1.Addup_Household__c);
    	setupContacts();
    	testAccount1 = [select Id, AddUp_Household__c from Account where Id = :account1.Id];
    	System.assertEquals(true, testAccount1.Addup_Household__c);
    	Account testAccount2 = [select Id, AddUp_Household__c from Account where Id = :account2.Id];
    	System.assertEquals(false, testAccount2.Addup_Household__c);
    	Contact ctct = new Contact(
    		Id = contact2.Id,
    		Website_System_Id__c = '0987654321'
    	);
    	update ctct;
    	testAccount2 = [select Id, AddUp_Household__c from Account where Id = :account2.Id];
    	System.assertEquals(true, testAccount2.Addup_Household__c);
    }

	static void setupAccounts() {
		account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId
			);
		account2 = 
			new Account(
				Name='Account2',
				RecordTypeId = accountHouseholdTypeId
			);
		List<Account> accountList = new List<Account>();
		accountList.add(account1);
		accountList.add(account2);
		insert accountList;
	}
	static void setupContacts() {
		contact1 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact1',
				rC_Bios__Preferred_Email__c = 'Home',
				rC_Bios__Home_Email__c = 'testcontact1x@abc.com',
				RecordTypeId = contactHouseholdTypeId,
				Website_System_Id__c = '1234567890'
			);	
		contact2 =
			new Contact(
				AccountId = account2.Id,
				FirstName = 'Test',
				LastName = 'Contact2',
				rC_Bios__Preferred_Email__c = 'Home',
				rC_Bios__Home_Email__c = 'testcontact2x@abc.com',
				RecordTypeId = contactHouseholdTypeId
			);
		List<Contact> contactList = new List<Contact>();
		contactList.add(contact1);
		contactList.add(contact2);
		insert contactList;
	}
}