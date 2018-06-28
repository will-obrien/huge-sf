@isTest
private class UserLookupsTriggerTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Id profileId;

    static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		profileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id;    
    }

    static testMethod void myUnitTest() {
		Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
		List<Contact> contactList = new List<Contact>();
        Contact contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            Email = 'test1.contact1@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );
        contactList.add(contact1);
        Contact contact2 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact2',
            Email = 'test2.contact1@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );
        contactList.add(contact2);

        insert contactList;  

		Club_Entity__c SFBayChapter = new Club_Entity__c(
			Name='SF Bay Chapter',
			Status__c='Active',
			Type__c='Chapter'
		);
		insert SFBayChapter;
		
		User user1 = createUser(contact1);
		
		User_Lookups__c lu = new User_Lookups__c(
			Chapter__c = SFBayChapter.Id,
			Contact__c = contact1.Id,
			User__c = user1.Id
		);
		insert lu;
		
		User_Lookups__c lu2 = new User_Lookups__c(
			Id = lu.Id,
			Contact__c = contact2.Id
		);		
		update lu2;
    }
	private static User createUser(Contact ctct) {
		String FirstName = ctct.FirstName;
		String LastName = ctct.LastName;
		String Email = ctct.Email;
		
		string aliasText = '';
            if(FirstName != null && FirstName != '' && Lastname.length()>1){
                    aliasText = FirstName.substring(0,1);
            }
            if(Lastname != null && Lastname != '' && Lastname.length()>2){
                aliasText += Lastname.substring(0,3);
            }
            else{
                aliasText +=Lastname;
            }
        String myNickName = '';
        If (Email.length() > 40) {
          myNickName = Email.substring(0, 40);
        } else {
          myNickName = Email;
        }
        User usr = new User(firstName = FirstName,
                                    lastName = LastName,
                                    Email = Email,
                                    CommunityNickname = myNickName,
                                    languagelocalekey = 'en_US',
                                    localesidkey = UserInfo.getLocale(),
                                    emailEncodingKey = 'UTF-8',
                                    timeZoneSidKey = 'America/Los_Angeles', 
                                    profileId = profileId,
                                    userName = Email,
                                    //Initial_Password__c = newPassword,
                                    ContactId = ctct.Id,
                                    alias = aliasText );
        return usr;
	}
}