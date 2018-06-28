@isTest
private class CheckStaffPreferenceTest {
    static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();

	static Account account1;
	static Contact contact1, contact2, contact3;
	static User user1, user2, user3;
	
	static Id profileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id;    
	static Id staffPermissionId = [select Id from PermissionSet where Name = 'Club_Staff'].Id;

    static testMethod void test1() {
		//Use runAs to avoid mixed dml operation exception
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
			account1 = new Account(
	            Name='Account1',
	            RecordTypeId = accountHouseholdTypeId
			);
			insert account1;
			
			List<Contact> contactList = new List<Contact>();
	        contact1 = new Contact(
	            AccountId = account1.Id,
	            FirstName = 'Test',
	            LastName = 'Contact1',
	            Email = 'test1.contact1@abc.com',
	            RecordTypeId = contactHouseholdTypeId
	        );
	        contactList.add(contact1);  
			
	        contact2 = new Contact(
	            AccountId = account1.Id,
	            FirstName = 'Test',
	            LastName = 'Contact2',
	            Email = 'test2.contact2@abc.com',
	            RecordTypeId = contactHouseholdTypeId
	        );  
			contactList.add(contact2);
	
	        contact3 = new Contact(
	            AccountId = account1.Id,
	            FirstName = 'Test',
	            LastName = 'Contact3',
	            Email = 'test3.contact2@abc.com',
	            RecordTypeId = contactHouseholdTypeId
	        );  
			contactList.add(contact3);

			insert contactList;
			
			List<User> userList = new List<User>();
			user1 = createUser(contact1);
			user2 = createUser(contact2);
			userList.add(user1);
			userList.add(user2);
			insert userList;
			System.debug('userList: ' + userList);
		
			Test.startTest();
	
			rC_Bios__Preference_Code__c prefcode = new rC_Bios__Preference_Code__c(
				rC_Bios__Code_Value__c = 'SCFDNSTAFF', 
				rC_Bios__Category__c = 'Classification', 
				rC_Bios__Subcategory__c = 'Sierra Club/Foundation Staff'
			);
			insert prefcode;
			
			rC_Bios__Preference__c pref1 = new rC_Bios__Preference__c(
				rC_Bios__Contact__c = contact1.Id,
				rC_Bios__Code_Value__c = 'SCFDNSTAFF',
				rC_Bios__Active__c = true
			);
			insert pref1;
	
			rC_Bios__Preference__c pref2 = new rC_Bios__Preference__c(
				rC_Bios__Contact__c = contact2.Id,
				rC_Bios__Code_Value__c = 'SCFDNSTAFF',
				rC_Bios__Active__c = false
			);
			insert pref2;
			
			Test.stopTest();
		
			List<PermissionSetAssignment> permList = [
				select Id from PermissionSetAssignment
				where AssigneeId = :user1.Id and PermissionSetId = :staffPermissionId 
			];
			System.assertEquals(1, permList.size());
			
			pref1.rC_Bios__Active__c = false;
			update pref1;
			
			permList = [
				select Id from PermissionSetAssignment
				where AssigneeId = :user1.Id and PermissionSetId = :staffPermissionId 
			];
			System.assertEquals(0, permList.size());
			
			permList = [
				select Id from PermissionSetAssignment
				where AssigneeId = :user2.Id and PermissionSetId = :staffPermissionId 
			];
			System.assertEquals(0, permList.size());

			pref2.rC_Bios__Active__c = true;
			update pref2;

			permList = [
				select Id from PermissionSetAssignment
				where AssigneeId = :user2.Id and PermissionSetId = :staffPermissionId 
			];
			System.assertEquals(1, permList.size());
        }
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
                                    ContactId = ctct.Id,
                                    alias = aliasText );
        return usr;
	}
}