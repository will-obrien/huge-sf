@isTest
private class ContactAfterUpdateTest {
	static Id accountHouseholdTypeId;
	static Id contactHouseholdTypeId;
	static Account account1, account2;
	static Contact contact1, contact2;
	static User user1, user2;

	static {
		accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	}
	
    static testMethod void myUnitTest() {
    	setupAccounts();
    	setupContacts();
    	setupUsers();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];

        Test.startTest();
		contact2.rC_Bios__Home_Email__c = contact1.rC_Bios__Home_Email__c;
		update contact2;
        Test.stopTest();

        User usr = [select userName from User where Id=:user2.Id];
        System.assertEquals('testcontact1x1@abc.com', usr.userName);
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
	static void setupUsers() {
		Profile addUpProfile = [SELECT Id FROM profile WHERE name='Addup User'];
		List<User> userList = new List<User>();
		user1 = new User(
			firstName = 'Test',
            lastName = 'Contact1',
            Email = 'testcontact1x@abc.com',
            Phone = '415-977-5687',
            CommunityNickname = 'Test1',
            languagelocalekey = 'en_US',
            localesidkey = UserInfo.getLocale(),
            emailEncodingKey = 'UTF-8',
            timeZoneSidKey = 'America/Los_Angeles', 
            profileId = addUpProfile.Id,
            userName = 'testcontact1x@abc.com',
            Initial_Password__c = 'test',
            ContactId = contact1.Id,
            alias = 'tcnt1' 
    	 );	
	     userList.add(user1);
		user2 = new User(
			firstName = 'Test',
            lastName = 'Contact2',
            Email = 'testcontact2x@abc.com',
            Phone = '415-977-5687',
            CommunityNickname = 'Test2',
            languagelocalekey = 'en_US',
            localesidkey = UserInfo.getLocale(),
            emailEncodingKey = 'UTF-8',
            timeZoneSidKey = 'America/Los_Angeles', 
            profileId = addUpProfile.Id,
            userName = 'testcontact2x@abc.com',
            Initial_Password__c = 'test',
            ContactId = contact2.Id,
            alias = 'tcnt2' 
    	 );	
	     userList.add(user2);
	     insert userList;
     }
}