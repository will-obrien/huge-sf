/*
This test covers nearly all code.
No asserts have been done - testing is users working with pages

2/2017 Maslow - Add field to bypass validations
*/
@isTest
private class ClubEventListControllerTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Id profileId;
    static User user1;
	static Contact contact1;
	static Club_Event__c event1, event2, event3;
	
	static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		profileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id;    
    }

    static testMethod void test1() {
        setup();
        System.runAs(user1) {
        	List<Event_Leader__c> ldrList = new List<Event_Leader__c>();
			Event_Leader__c ldr1 = new Event_Leader__c(
				Club_Event__c = event1.Id,
				Contact__c = contact1.Id,
				Leader_Name__c = 'Test Contact1',
				Is_Primary_Leader__c = true
			);
			ldrList.add(ldr1);
			Event_Leader__c ldr2 = new Event_Leader__c(
				Club_Event__c = event1.Id,
				Leader_Name__c = 'Test Contact2',
				Is_Primary_Leader__c = false
			);
			ldrList.add(ldr2);
			//EventLeaderTriggerHandler.isClubEvent = true;
			EventHelper.sourceObject = 'ClubEvent';
			insert ldrList;

			ClubEventListController ctrl = new ClubEventListController();
			ctrl.earliestDateString = getDateString(System.today() - 10);
			ctrl.latestDateString = getDateString(System.today() + 10);
			ctrl.earliestChangeDateString = getDateString(System.today() - 10);
			ctrl.latestChangeDateString = getDateString(System.today() + 10);
			ctrl.eventTitle = event1.Event_Title__c;
			ctrl.eventStatus = event1.Status__c;
			ctrl.eventSponsor = event1.Club_Entity__c;
			ctrl.eventCategory = event1.Event_Category__c;
			ctrl.leaderName = 'Test Contact1';
			ctrl.activityList = null;
			ctrl.filterEvents();
			List<Club_Event__c> evList = ctrl.getActivityList();
			ctrl.activityList = null;
			ctrl.resetFilter();
			ctrl.earliestDateString = null;
			ctrl.filterEvents();
			evList = ctrl.getActivityList();
			ctrl.getStatusOptions();
			ctrl.getSponsorOptions();
			ctrl.getCategoryOptions();
			ctrl.getListTitle();
			ctrl.getBaseUrl();
			ctrl.newActivity();
			ctrl.createCSV();
			ctrl.createPrintView();
			ctrl.createRegistrationList();
			ctrl.createRegistrationSummary();
			ctrl.getRegistrationList();
			List<ClubEventListController.RegistrantExportRow> registrantList = ctrl.getRegistrantExportList();
			for(ClubEventListController.RegistrantExportRow row : registrantList) {
				row.getBeginDate();
			}
			List<ClubEventListController.RegistrationSummaryRow> regList = ctrl.getRegistrationSummaryList();
			for(ClubEventListController.RegistrationSummaryRow row : regList) {
				row.getBeginDate();
			}
			List<ClubEventListController.ExportRow> expList = ctrl.getExportList();
			for(ClubEventListController.ExportRow row : expList) {
				row.getBeginDateForm1();
				row.getBeginDateDisplay();
				row.getBeginTime();
				row.getEndTime();
				row.getBeginDateForm2();
				row.getEndDateForm1();
				row.getEndDateDisplay();
				row.getEndDateForm2();
				row.getDisplayDate();
				row.getAllLeaders();
				row.getCancellation();
			}
			PageReference pageRef = Page.ClubEventList;
			Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('id', event2.Id);
			ctrl.deleteActivity();
		}
        
    }
    private static String getDateString(Date dt) {
    	String timeZone = System.UserInfo.getTimeZone().getID();
    	Time zTime = Time.newInstance(0,0,0,0);
       	return DateTime.newInstance(dt, zTime).format('M/d/yyyy', timeZone);
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
          
		insert contactList;
		
		List<User> userList = new List<User>();
		user1 = createUser(Contact1);
		userList.add(user1);
		insert userList;
		
		Club_Entity__c ent = new Club_Entity__c(
			EntityId__c = '0100',
			Status__c = 'Active',
			Type__c = 'Chapter',
			Bypass_Validations__c = true
		);
		insert ent;
		Leader_Position__c ldrPos = new Leader_Position__c(
			Name='Chair',
			Code__c = 'CHR',
			ClubEventPermission_NonOutings__c = 'Administrator',
			ClubEventPermission_Outings__c = 'Administrator'
		);
		insert ldrPos;
		Leadership__c role = new Leadership__c(
			Club_Entity__c = ent.Id,
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
			Club_Entity__c = ent.Id,
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
			Club_Entity__c = ent.Id,
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
			Club_Entity__c = ent.Id,
			Sponsor_Description__c = 'Test',
			Display_Method__c = 'External URL',
			External_URL__c = 'http://test.com',
			Cancellation_Option__c = 'Other',
			Cancellation_Policy_Description__c = 'Test'
		);
		eventList.add(event3);
		EventHelper.sourceObject = 'ClubEvent';
		insert eventList;
		
		Event_Registration__c reg = new Event_Registration__c(
			Club_Event__c = event1.Id
		);
		insert reg;
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