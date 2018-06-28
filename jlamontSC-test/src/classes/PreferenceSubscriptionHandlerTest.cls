@isTest
private class PreferenceSubscriptionHandlerTest {
	static Id accountHouseholdTypeId;
	static Id contactHouseholdTypeId;
	static Id generalPreferenceTypeId;
	static Account account1, account2;
	static Contact contact1, contact2;

	static {
		accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		generalPreferenceTypeId = Schema.SObjectType.rC_Bios__Preference__c.getRecordTypeInfosByName().get('Club-wide').getRecordTypeId();
	}

    static testMethod void myUnitTest() {
    	setupAccounts();
    	setupContacts();
    	rc_Bios__Preference__c pref = new rc_Bios__Preference__c(
    		RecordTypeId = generalPreferenceTypeId,
    		rC_Bios__Contact__c = contact1.Id,
    		rC_Bios__Category__c = 'Contact Preference',
    		rC_Bios__Subcategory__c = 'No Email',
    		rC_Bios__Active__c = true
    	);
    	Test.startTest();
    	insert pref;
    	pref.rC_Bios__Active__c = false;
    	update pref;
    	pref.rC_Bios__Active__c = true;
    	update pref;
    	Test.stopTest();
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
				RecordTypeId = contactHouseholdTypeId
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