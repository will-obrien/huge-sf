@isTest
private class ClubEventTriggerHandlerTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Id profileId;
    static User user1;
	
	static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		profileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id;    
    }
    static testMethod void myUnitTest() {
    	setup();
		System.runAs(user1) {
			//ClubEventTriggerHandler.isClubEvent = true;
			//EventsCampaignTriggerHandler.isClubEvent = true;
			EventHelper.sourceObject = 'ClubEvent';
			Club_Event__c ev = new Club_Event__c(
				Event_Title__c = 'Test Event',
				Time_Begin__c = '8:00 AM',
				Date_Begin__c = System.today() + 1,
				Status__c = 'In Development',
				Sponsor_Description__c = 'Test',
				Display_Method__c = 'External URL',
				External_URL__c = 'http://test.com',
				Short_Description__c = 'Test Event'
			);
			insert ev;
			Campaign camp = [select Id from Campaign where Club_Event__c = :ev.Id];
			System.assert(camp != null);
			
			ev.Short_Description__c = 
				'01234567890123456789012345678901234567890123456789' +
				'01234567890123456789012345678901234567890123456789' +
				'01234567890123456789012345678901234567890123456789' +
				'01234567890123456789012345678901234567890123456789' +
				'01234567890123456789012345678901234567890123456789' +
				'01234567890123456789012345678901234567890123456789';
			update ev;
			
			delete ev;
			List<Campaign> campList = [
				select Id from Campaign where Id = :camp.Id
			];
			System.assert(campList.isEmpty());
		}
    }
	private static void setup() {
		Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
        Contact contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            Email = 'test1.contact1@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );
		insert contact1;
		
		user1 = createUser(Contact1);
		insert user1;
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