/*
2/2017 Maslow - Add field to bypass validations
*/
@isTest
private class ClubEventLeaderEmailTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Id profileId;
    static User user1;
	static Contact contact1, contact2;
	static Event_Leader__c ldr1;
	static Club_Entity__c SFBayChapter, SFGroup;
	static Club_Event__c event1, event2, event3, event4;
	static SiteURL__c siteUrl;
	
	static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		profileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id;    
    }

    static testMethod void test1() {
    	setup();
		siteUrl = new SiteURL__c(
			Name = 'EventsURL',
			BaseURL__c = 'http://force.com/events/details',
			Testing__c = true
		);
		insert siteUrl;
    	
        System.runAs(user1) {
        	Club_Event__c evnt = [
        		select 
        			Event_Title__c,
        			Date_Begin__c,
        			Status__c,
        			Club_Entity__r.Name,
					Event_Category__c,
					Sponsor_Description__c,
    				URL_to_Share__c,
        			Club_Entity__r.Newly_Activated_Outings_Email__c
        		from Club_Event__c
        		where Id = :event1.Id
        	];
        	ClubEventLeaderEmail.send(evnt, ldr1, evnt.Club_Entity__r.Name, false, false);
        	evnt.Status__c = 'Disapproved';
        	ClubEventLeaderEmail.send(evnt, ldr1, evnt.Club_Entity__r.Name, false, false);
        	evnt.Status__c = 'Changes Required';
        	ClubEventLeaderEmail.send(evnt, ldr1, evnt.Club_Entity__r.Name, false, false);
        	evnt.Status__c = 'Active';
        	ldr1.Contact__c = contact2.Id;
        	ClubEventLeaderEmail.send(evnt, ldr1, evnt.Club_Entity__r.Name, true, true);
        }
    }
    static testMethod void test2() {
    	setup();
		siteUrl = new SiteURL__c(
			Name = 'EventsURL',
			BaseURL__c = 'http://force.com/events/details',
			Testing__c = false
		);
		insert siteUrl;
        System.runAs(user1) {
        	Club_Event__c evnt = [
        		select 
        			Event_Title__c,
        			Date_Begin__c,
        			Status__c,
        			Club_Entity__r.Name,
					Event_Category__c,
					Sponsor_Description__c,
    				URL_to_Share__c,
        			Club_Entity__r.Newly_Activated_Outings_Email__c,
        			RecurringEvent__c,
        			Recurring_Dates__c
        		from Club_Event__c
        		where Id = :event1.Id
        	];
        	ClubEventLeaderEmail.send(evnt, ldr1, evnt.Club_Entity__r.Name, false, true);
        	evnt.Status__c = 'Disapproved';
        	ClubEventLeaderEmail.send(evnt, ldr1, evnt.Club_Entity__r.Name, false, true);
        	evnt.Status__c = 'Changes Required';
        	ClubEventLeaderEmail.send(evnt, ldr1, evnt.Club_Entity__r.Name, false, true);
        	evnt.Status__c = 'Active';
        	ldr1.Contact__c = contact2.Id;
        	
        	contact2.Email = null;
        	update contact2;
        	
        	ClubEventLeaderEmail.send(evnt, ldr1, evnt.Club_Entity__r.Name, true, true);
        	
        	ClubEventLeaderEmail.formatDate(null);
        	ClubEventLeaderEmail.writeStringField(JSON.createGenerator(false), '', null);
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
            Email = 'test2.contact2@abc.com',
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
			Newly_Activated_Outings_Email__c = 'test@test.com',
			Bypass_Validations__c = true
		);
		entityList.add(SFBayChapter);

		insert entityList;

		Leader_Position__c ldrPos = new Leader_Position__c(
			Name='Outing Chair',
			Code__c = 'OCHR',
			ClubEventPermission_NonOutings__c = 'Administrator',
			ClubEventPermission_Outings__c = 'Administrator'
		);
		insert ldrPos;
		Leadership__c role = new Leadership__c(
			Club_Entity__c = SFBayChapter.Id,
			Position_Active__c = true,
			Contact__c = contact2.Id,
			Leader_Position__c = ldrPos.Id
		);
		insert role;
		RecurringEvent__c recurringEvent = new RecurringEvent__c();
		insert recurringEvent;
		
		List<Club_Event__c> eventList = new List<Club_Event__c>();
		event1 = new Club_Event__c(
			Event_Title__c = 'Test Event 1',
			Short_Description__c = 'Test Event 1',
			Time_Begin__c = '8:00 AM',
			Date_Begin__c = System.today() + 1,
			Date_End__c = System.today() + 2,
			Time_End__c = '5:00 PM',
			Date_Tentative__c = true,
			Time_Tentative__c = true,
			Status__c = 'Pending Approval',
			Event_Category__c = 'Outing',
			Event_Type__c = 'Hike',
			Club_Entity__c = SFBayChapter.Id,
			Sponsor_Description__c = 'Test Sponsor',
			Show_on_Map__c = false,
			Display_Method__c = 'External URL',
			External_URL__c = 'http://test.com',
			Cancellation_Option__c = 'Other',
			Cancellation_Policy_Description__c = 'Test',
			Registrations_Accepted__c = true,
			Registration_Cutoff__c = System.today() + 2,
			Require_Phone_Number__c = true,
			Require_ZIP_Code__c = true,
			Require_Street_Address__c = true,
			Require_Mobile_Phone__c = true,
			Require_Additional_Attendees__c = true,
			Require_Field_1__c = true,
			Require_Field_2__c = true,
			Require_Field_3__c = true,
			Require_Field_4__c = true,
			Require_Field_5__c = true,
			RecurringEvent__c = recurringEvent.Id,
	        Recurring_Dates__c = '["2080-06-10T07:00:00.000Z","2080-07-08T07:00:00.000Z"]'
		);
		eventList.add(event1);
		
		EventHelper.sourceObject = 'ClubEvent';
		insert eventList;
		
		EventLeaderTriggerHandler.leadersChecked = true;
		ldr1 = new Event_Leader__c(
			Club_Event__c = event1.Id,
			Leader_Name__c = 'Test Leader',
			Email__c = 'test@gmail.com',
			Is_Primary_Leader__c = true
		);
		insert ldr1;
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