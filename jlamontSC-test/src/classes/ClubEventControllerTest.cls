/*
This test covers most code.
Only assert is to verify that event was successfully saved - testing is users working with pages

2/2017 Maslow - Add field to bypass validations
*/
@isTest
private class ClubEventControllerTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Id profileId;
    static User user1;
	static Contact contact1;
	static Club_Entity__c SFBayChapter, SFGroup;
	static Club_Event__c event1, event2, event3, event4;
	
	static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		profileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id;    
    }

    static testMethod void test1() {
        setup();
        System.runAs(user1) {
	        ClubEventController ctl = new ClubEventController();
	        ctl.getClubEvent();
	        ctl.clubEvent = null;
			PageReference pageRef = Page.ClubEventEntry;
			Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('id', event1.Id);
			ApexPages.currentPage().getParameters().put('copy', 'true');
	        Club_Event__c ev = ctl.getClubEvent();
	        ctl.getSponsorDescription();
	        String entId = ctl.getClubEntity();
	        ctl.setClubEntity(entId);
	        ctl.getEntities();
	        ctl.getEntityOptionsSize();
	        ctl.getStatusOptions();
	        ctl.getCategoryOptions();
	        
	        ev.Event_Category__c = '';
	        ctl.getCategoryOptions();
	        ev.Event_Category__c = 'Outing';
	        
	        ctl.getTypeOptions();
	        String dt = ctl.getDtBegin();
	        ctl.setDtBegin(dt);
	        dt = ctl.getDtEnd();
	        ctl.setDtEnd(dt);
	        ctl.getPageTitle();
	        
			ApexPages.currentPage().getParameters().put('id', event1.Id);
			ApexPages.currentPage().getParameters().remove('copy');
			ctl.clubEvent = null;
	        Club_Event__c version1 = ctl.getClubEvent();
	        Club_Event__c version2 = version1.clone(true, true, true, true);
	        version2.Club_Entity__c = null;
	        version2.Event_Category__c = null;
	        version2.Event_Title__c = null;
	        version2.Status__c = null;
	        version2.Status__c = 'Active';
	        version2.Date_Begin__c = null;
	        version2.Status__c = null;
	        ctl.ClubEvent = version2;
			Event_Leader__c ldr1 = new Event_Leader__c(
				Club_Event__c = version2.Id,
				Leader_Name__c = 'Test Leader'
			);

			EventHelper.sourceObject = 'ClubEvent';
			insert ldr1;
			ctl.leaderList = null;
	        ctl.save();
	        
	        List<ClubEventController.EventLeader> ldrList = ctl.getLeaderList();
	        ClubEventController.EventLeader evLdr = ldrList.get(0);
	        Event_Leader__c ldr = evLdr.leader;
	        ldr.Email__c = '(*)&)(*&)';
	        ldr.Leader_Name__c = null;
	        ctl.save();
	        
	        ctl.setDtBegin('1/1/2020 8:00 AM');
	        ctl.getDtBegin();
	        ctl.setDtEnd('1/1/2020 5:00 PM');
	        ctl.getDtEnd();
	        ctl.categoryChanged();
	        ctl.getIsNewlyCancelled();
	        
	        ldr1.Is_Primary_Leader__c = true;
	        upsert ldr1;
	        ctl.leaderList = null;
	        ctl.getLeaderList();
	        ctl.save();
	        
	        version2.Display_Method__c = 'External URL';
	        version2.External_URL__c = null;
	        version2.Registrations_Accepted__c = true;
	        
	        ctl.saveAndReturn();
	        
	        ctl.clubEvent = event4;
			Event_Leader__c ldr2 = new Event_Leader__c(
				Club_Event__c = event4.Id,
				Leader_Name__c = 'Test Leader',
				Email__c = 'test@gmail.com',
				Is_Primary_Leader__c = true
			);
			insert ldr2;


	        ctl = new ClubEventController();
			pageRef = Page.ClubEventEntry;
			Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('id', event4.Id);
	        ctl.getClubEvent();
	        
	        ctl.getLeaderList();
	        
	        ctl.getClubEvent().Begin_Publication__c = null;
	        ctl.getBeginPublication();
	        ctl.setBeginPublication('1/1/2040');
	        ctl.getClubEvent().Begin_Publication__c = System.today();
	        
	        ctl.setRegistrationCutoff('1/1/2040');
	        ctl.setRegistrationCutoff('');
	        ctl.getRegistrationCutoff();
			ctl.getClubEvent().External_URL__c = 'http://test.com';
			ctl.getClubEvent().Display_Method__c = 'Salesforce Events Page';
	        
	        ctl.getClubEvent().Bring__c = 'Test';
	        ctl.getClubEvent().Additional_Directions__c = 'Test';
	        ctl.getClubEvent().Cancellation_Policy_Description__c = 'Test';
	        ctl.getClubEvent().Carpool__c = 'Test';
	        ctl.getClubEvent().Cost_Description__c = 'Test';
	        ctl.getClubEvent().Short_Description__c = 'Test';
	        ctl.getClubEvent().Signup_Instructions__c = 'Test';
	        ctl.getClubEvent().Signup_Restrictions__c = 'Test';
	        
	        ctl.save();
	        
	        System.assert(ctl.saveSuccessful);
	        
	        ctl.saveAndReturn();
	        
	        ctl.cancel();
	        ctl.getRegistrationStatusOptions();
	        ctl.setLdrAddOption('Existing');
	        ctl.getLdrAddOption();
	        Club_Event__c evnt = ctl.getClubEvent();
	        ctl.setSponsorDescription(null);
	        ctl.setClubEntity(SFGroup.Id);
	        ctl.getSponsorDescription();
	        
	        ctl.contactSearchValue = 'Test';
	        ctl.searchContacts();
	        ctl.getHasSearchResults();
	        ctl.cancelSearchContacts();
	        ctl.getHasSearchResults();
	        
	        ctl.setSelectedRow(0);
	        ctl.selectedId = contact1.Id;
	        ctl.setSelectedLeader();
	        
	        ctl.deleteLeader();
	        ctl.getLeaderListSize();
	        
	        ctl.getLocalCampaignOptions();
	        
	        Event_Registration__c reg1 = new Event_Registration__c(
	        	Club_Event__c = event4.Id,
    			First_Name__c = 'Test FirstName',
    			Last_Name__c = 'Test LastName',
    			Email__c = 'test@gmail.com',
    			Status__c = 'Registered'
	        );
	        insert reg1;
	        
	        List<ClubEventController.RegistrantExportRow> exportList = ctl.getRegistrantExportList();
	        String createdDate = exportList.get(0).getCreatedDate();
	        
	        ctl.setSelectedRegistrationRow(0);
	        ctl.exportRegistrants();
	        ctl.getRegListSize();
	        
	        ctl.setSelectedRow(0);
	        ctl.getSelectedRow();
	        ctl.getSelectedRegistrationRow();
	        
	        ctl.registrationStatusChanged();
	        
	        ctl.adjustPrimaryLeader();
	        ctl.resetRegistrationList();
	        
	        ctl.registrationStatusChanged();
	        ctl.saveSelectedRegistration();
	        
	        ev = ctl.getClubEvent();
	        ev.Status__c = 'Active';
	        ev.Begin_Publication__c = null;
	        ev.Registrations_Accepted__c = true;
	        ev.Registration_Cutoff__c = System.today() - 1;
			EventHelper.sourceObject = 'ClubEvent';
			
	        ctl.save();
	        
	        ctl.getBeginPublication();
	        ctl.setBeginPublication('');
	        ctl.getRegistrationCutoff();
	        ctl.setRegistrationCutoff('');
	        ctl.getMaxSearchResults();
	        ctl.getBaseUrl();
	        
	        ev.Show_on_Map__c = true;
	        ctl.save();

			ev.Status__c = 'Cancelled';
			ev.Cancel_Reason__c = '';
			ctl.save();
			
			ctl.originalDtBegin = System.today() - 2;
			ev.Send_RSVP_to_Leader__c = true;
			ev.Registrations_Accepted__c = false;
			ev.Begin_Publication__c = System.today() + 365;
			ctl.save();
			
			ctl.sendEmail();
        }
    }
    static testMethod void test2() {
    	setup();
        System.runAs(user1) {
			Event_Leader__c ldr2 = new Event_Leader__c(
				Club_Event__c = event4.Id,
				Leader_Name__c = 'Test Leader',
				Email__c = 'test@gmail.com',
				Is_Primary_Leader__c = true
			);
			insert ldr2;

	        ClubEventController ctl = new ClubEventController();
			PageReference pageRef = Page.ClubEventEntry;
			Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('id', event4.Id);
	        ctl.getClubEvent();
	        
	        ctl.getLeaderList();
	        
	        ctl.getClubEvent().Begin_Publication__c = null;
	        ctl.getBeginPublication();
	        ctl.setBeginPublication('1/1/2080');
	        ctl.getClubEvent().Begin_Publication__c = System.today();
	        
	        ctl.setRegistrationCutoff('1/1/2080');
	        ctl.setRegistrationCutoff('');
	        ctl.getRegistrationCutoff();
			ctl.getClubEvent().External_URL__c = 'http://test.com';
			ctl.getClubEvent().Display_Method__c = 'Salesforce Events Page';
	        
	        ctl.getClubEvent().Recurring_Dates__c = '["2080-06-10T07:00:00.000Z","2080-07-08T07:00:00.000Z"]';
	        ctl.datesConfirmed = false;
	        
	        ctl.save();
	        
	        ctl.getClubEvent().Status__c = 'Active';
	        ctl.getClubEvent().Date_End__c = null;
	        ctl.previousStatus = 'In Development';
	        ctl.datesConfirmed = false;
	        System.debug('Saving as Active, previousStatus In Development');
	        ctl.save();
	        
	        ctl.updateSingleEvent = false;
	        ctl.datesConfirmed = false;
	        
	        RecurringEvent__c re = new RecurringEvent__c();
	        insert re;
	        ctl.getClubEvent().RecurringEvent__c = re.Id;
	        
	        ctl.save();
	        
	        ctl.getDtBeginString();
	        ctl.setDtBeginString('12/31/2080');
	        
	        ctl.returnAfterSave = true;
	        ctl.confirmSave();
	        ctl.updateOneEventOnly();
	        ctl.updateFutureEvents();
	        ctl.returnAfterSave = false;
	        ctl.confirmSave();
	        ctl.updateOneEventOnly();
	        ctl.updateFutureEvents();
	        ctl.cancelSave();
        }
    }
	private static void setup() {
		SiteURL__c siteURL = new SiteURL__c(
			Name = 'EventsURL',
			BaseURL__c = 'https://test.salesforce.com',
			Testing__c = true
		);
		insert siteURL;
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
          
		insert contactList;
		
		List<User> userList = new List<User>();
		user1 = createUser(Contact1);
		userList.add(user1);
		insert userList;
		
		List<Club_Entity__c> entityList = new List<Club_Entity__c>();
		SFBayChapter = new Club_Entity__c(
			EntityId__c = '0100',
			Status__c = 'Active',
			Type__c = 'Chapter',
			Bypass_Validations__c = true
		);
		entityList.add(SFBayChapter);
		SFGroup = new Club_Entity__c(
			EntityId__c = '0101',
			Status__c = 'Active',
			Type__c = 'Group',
			Bypass_Validations__c = true
		);
		entityList.add(SFGroup);

		insert entityList;

		Leader_Position__c ldrPos = new Leader_Position__c(
			Name='Chair',
			Code__c = 'CHR',
			ClubEventPermission_NonOutings__c = 'Administrator',
			ClubEventPermission_Outings__c = 'Administrator'
		);
		insert ldrPos;
		Leadership__c role = new Leadership__c(
			Club_Entity__c = SFBayChapter.Id,
			Position_Active__c = true,
			Contact__c = contact1.Id,
			Leader_Position__c = ldrPos.Id
		);
		insert role;
		
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
			Club_Entity__c = SFBayChapter.Id,
			Sponsor_Description__c = 'Test',
			Display_Method__c = 'External URL',
			External_URL__c = 'http://test.com',
			Cancellation_Option__c = 'Other',
			Cancellation_Policy_Description__c = 'Test'
		);
		eventList.add(event2);
		event3 = new Club_Event__c(
			Event_Title__c = 'Test Event 3',
			Time_Begin__c = '8:00 AM',
			Date_Begin__c = System.today() + 1,
			Date_End__c = System.today() + 2,
			Time_End__c = '5:00 PM',
			Date_Tentative__c = true,
			Time_Tentative__c = true,
			Status__c = 'In Development',
			Event_Category__c = 'Outing',
			Club_Entity__c = SFBayChapter.Id,
			Sponsor_Description__c = 'Test',
			Display_Method__c = 'External URL',
			External_URL__c = 'http://test.com',
			Cancellation_Option__c = 'Other',
			Cancellation_Policy_Description__c = 'Test'
		);
		eventList.add(event3);
		event4 = new Club_Event__c(
			Event_Title__c = 'Test Event 4',
			Short_Description__c = 'Test Event 4',
			Time_Begin__c = '8:00 AM',
			Date_Begin__c = System.today() + 1,
			Date_End__c = System.today() + 2,
			Time_End__c = '5:00 PM',
			Date_Tentative__c = true,
			Time_Tentative__c = true,
			Status__c = 'In Development',
			Event_Category__c = 'Outing',
			Event_Type__c = 'Hike',
			Club_Entity__c = SFBayChapter.Id,
			//Sponsor_Description__c = 'Test',
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
			Require_Field_5__c = true
		);
		eventList.add(event4);
		
		//ClubEventTriggerHandler.isClubEvent = true;
		//EventsCampaignTriggerHandler.isClubEvent = true;
		EventHelper.sourceObject = 'ClubEvent';
		insert eventList;
		
		Event_Registration__c reg = new Event_Registration__c(
			Club_Event__c = event1.Id
		);
		insert reg;
		
		Club_Event_Type__c evType1 = new Club_Event_Type__c(
			Category__c = 'Outing',
			Type__c = 'Hike',
			ExternalId__c = '1'
		);
		Club_Event_Type__c evType2 = new Club_Event_Type__c(
			Category__c = 'Social Event',
			Type__c = 'Film',
			ExternalId__c = '58'
		);
		List<Club_Event_Type__c> evTypeList = new List<Club_Event_Type__c>();
		evTypeList.add(evType1);
		evTypeList.add(evType2);
		insert evTypeList;
		
		Local_Grassroots_Campaign__c grassroots = new Local_Grassroots_Campaign__c(
			Club_Entity_Team__c = SFGroup.Id,
			Name = 'Test'
		);
		insert grassroots;
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