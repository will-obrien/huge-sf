@isTest
private class OtherEntEventsControllerTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Id profileId;
    static User user1, user2;
	static Contact contact1, contact2;
	static Club_Entity__c SFBayChapter, RedwoodChapter;
	static Club_Event__c event1, event2;
	
	static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		profileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id;    
    }
    static testMethod void myUnitTest() {
    	setup();
    	OtherEntEventsController oec = new OtherEntEventsController();
    	oec.searchEvents();
    	oec.SponsoringEntityId = 'junk';
    	oec.earliestDateString = 'junk';
    	oec.latestDateString = 'junk';
    	oec.searchEvents();
    	oec.SponsoringEntityId = SFBayChapter.EntityId__c;
    	oec.earliestDateString = System.today().format();
    	oec.latestDateString = (System.today() + 1).format();
    	oec.searchEvents();
    	System.assertEquals(1, oec.searchResults.size());
    	
    	OtherEntEventsController.EventWrapper wrap = oec.searchResults.get(0);
    	wrap.isChecked = true;
    	System.runAs(user1) {
    		oec.getEntities();
    	}
    	oec.addSelected();
    	oec.getOtherEntityEvents();

		Id id = oec.getClubEntityId();
		oec.clubEntityId = null;
		oec.getClubEntityId();
    	oec.setClubEntityId(id);
		oec.getClubEntityId();		
    	
    	Other_Entity_Event__c oeEvent = [
    		select Id from Other_Entity_Event__c
    	];
    	PageReference pageRef = Page.OtherEntEvents;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', oeEvent.Id);
		oec.deleteEvent();
		List<Other_Entity_Event__c> oeEventList = [
			select Id from Other_Entity_Event__c
		];
    	System.assert(oeEventList.isEmpty());
    	
    	oec.cancelSearch();
    	oec.entityChanged();
    	oec.adminPage();

		profileId = [SELECT Id FROM profile WHERE name='System Administrator'].Id;
		user2 = createUser(Contact2);
		user2.ContactId = null;
		insert user2;
		
		User_Lookups__c ul = new User_Lookups__c(
			Contact__c = Contact2.Id,
			User__c = user2.Id
		);
		insert ul;
    	oec = new OtherEntEventsController();
    	System.runAs(user2) {
    		oec.getEntities();
    	}
    }
	private static void setup() {
		Account account1 = new Account(
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
            Email = 'test.contact2@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );
        contactList.add(contact2);  
          
		insert contactList;
		
		List<User> userList = new List<User>();
		user1 = createUser(Contact1);
		userList.add(user1);
		insert userList;
		
		List<Club_Entity__c> entityList = new List<Club_Entity__c>();
		SFBayChapter = new Club_Entity__c(
			Name = 'SF Bay Chapter',
			EntityId__c = '0100',
			Status__c = 'Active',
			Type__c = 'Chapter',
			Bypass_Validations__c = true
		);
		entityList.add(SFBayChapter);
		RedwoodChapter = new Club_Entity__c(
			Name = 'Redwood Chapter',
			EntityId__c = '0300',
			Status__c = 'Active',
			Type__c = 'Group',
			Bypass_Validations__c = true
		);
		entityList.add(RedwoodChapter);

		insert entityList;

		Leader_Position__c ldrPos = new Leader_Position__c(
			Name='Chair',
			Code__c = 'CHR',
			ClubEventPermission_NonOutings__c = 'Administrator',
			ClubEventPermission_Outings__c = 'Administrator'
		);
		insert ldrPos;
		
		List<Leadership__c> roleList = new List<Leadership__c>();
		Leadership__c role1 = new Leadership__c(
			Club_Entity__c = SFBayChapter.Id,
			Position_Active__c = true,
			Contact__c = contact1.Id,
			Leader_Position__c = ldrPos.Id
		);
		roleList.add(role1);

		Leadership__c role2 = new Leadership__c(
			Club_Entity__c = RedwoodChapter.Id,
			Position_Active__c = true,
			Contact__c = contact2.Id,
			Leader_Position__c = ldrPos.Id
		);
		roleList.add(role2);
		
		insert roleList;
		
		List<Club_Event__c> eventList = new List<Club_Event__c>();
		event1 = new Club_Event__c(
			Event_Title__c = 'Test Event 1',
			Time_Begin__c = '8:00 AM',
			Date_Begin__c = System.today() + 1,
			Status__c = 'In Development',
			Event_Category__c = 'Outing',
			Club_Entity__c = SFBayChapter.Id,
			Sponsor_Description__c = 'Test',
			Display_Method__c = 'External URL',
			External_URL__c = 'http://test.com'
		);
		eventList.add(event1);
		event2 = new Club_Event__c(
			Event_Title__c = 'Test Event 2',
			Time_Begin__c = '8:00 AM',
			Date_Begin__c = System.today() + 1,
			Date_End__c = System.today() + 1,
			Time_End__c = '5:00 PM',
			Date_Tentative__c = true,
			Time_Tentative__c = true,
			Status__c = 'In Development',
			Event_Category__c = 'Outing',
			Club_Entity__c = RedwoodChapter.Id,
			Sponsor_Description__c = 'Test',
			Display_Method__c = 'External URL',
			External_URL__c = 'http://test.com',
			Cancellation_Option__c = 'Other',
			Cancellation_Policy_Description__c = 'Test'
		);
		eventList.add(event2);
		
		//ClubEventTriggerHandler.isClubEvent = true;
		//EventsCampaignTriggerHandler.isClubEvent = true;
		EventHelper.sourceObject = 'ClubEvent';
		insert eventList;

		List<Event_Leader__c> ldrList = new List<Event_Leader__c>();
		Event_Leader__c ldr1 = new Event_Leader__c(
			Club_Event__c = event1.Id,
			Leader_Name__c = 'Test Leader',
			Email__c = 'test@gmail.com',
			Is_Primary_Leader__c = true
		);
		ldrList.add(ldr1);
		Event_Leader__c ldr2 = new Event_Leader__c(
			Club_Event__c = event1.Id,
			Leader_Name__c = 'Test Leader',
			Email__c = 'test@gmail.com',
			Is_Primary_Leader__c = true
		);
		ldrList.add(ldr2);
		
		insert ldrList;

		event1.Status__c = 'Active';
		event2.Status__c = 'Active';
		update eventList;
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