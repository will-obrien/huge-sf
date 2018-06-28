@isTest
public class EventSummaryControllerTest {
    static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	public static Id contactId;

    static testMethod void myUnitTest() {
		Club_Entity__c SFBayChapter = new Club_Entity__c(
			Name='SF Bay Chapter',
			Status__c='Active',
			Type__c='Chapter'
		);
		insert SFBayChapter;
		
		Club_Entity__c SanFranciscoGroup = new Club_Entity__c(
			Name='San Francisco Group',
			Status__c='Active',
			Type__c='Group',
			Parent_Chapter__c = SFBayChapter.Id
		);
		insert SanFranciscoGroup;

		Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
        Contact contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            RecordTypeId = contactHouseholdTypeId
        );  
		insert contact1;
		contactId = contact1.Id;

		Leader_Position__c ChairPosition = new Leader_Position__c(
			Name='Chair',
			Code__c='CHR',
			ClubEventPermission_NonOutings__c = 'Administrator',
			ClubEventPermission_Outings__c = 'Administrator'
		);
		insert ChairPosition;

		Leadership__c chairRole = new Leadership__c(
			Position_Active__c = true,
			Club_Entity__c = SFBayChapter.Id,
			Contact__c = contact1.Id,
			Leader_Position__c = ChairPosition.Id
		);
		insert chairRole;

		List<Club_Event__c> eventList = new List<Club_Event__c>();
		Club_Event__c event1 = new Club_Event__c(
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

		Club_Event__c event2 = new Club_Event__c(
			Event_Title__c = 'Test Event 2',
			Time_Begin__c = '8:00 AM',
			Date_Begin__c = System.today() + 2,
			Status__c = 'In Development',
			Event_Category__c = 'Social Event',
			Club_Entity__c = SFBayChapter.Id,
			Sponsor_Description__c = 'Test',
			Display_Method__c = 'External URL',
			External_URL__c = 'http://test.com'
		);
		eventList.add(event2);

		Club_Event__c event3 = new Club_Event__c(
			Event_Title__c = 'Test Event 2',
			Time_Begin__c = '8:00 AM',
			Date_Begin__c = System.today() + 2,
			Status__c = 'In Development',
			Event_Category__c = 'Social Event',
			Club_Entity__c = SanFranciscoGroup.Id,
			Sponsor_Description__c = 'Test',
			Display_Method__c = 'External URL',
			External_URL__c = 'http://test.com'
		);
		eventList.add(event3);

		EventHelper.sourceObject = 'ClubEvent';
		insert eventList;

		EventSummaryController controller = new EventSummaryController();
		System.assertEquals(null, controller.displayReport());
		controller.setClubEntity(SFBayChapter.Id);
		System.assertEquals('Chapter', controller.getEntityType());
		System.assertEquals(SFBayChapter.Id, controller.getClubEntity());
		controller.dtBegin = System.today() - 10;
		controller.dtEnd = System.today() + 10;
		List<EventSummaryController.EventData> evList = controller.getEvents();
		System.debug('eventList1:' + evList);
		String reportTitle = controller.getReportTitle();
		
		controller.reportOption = 'CHAPSEPARATE';
		evList = controller.getEvents();
		reportTitle = controller.getReportTitle();
		
		List<SelectOption> entitySelectOptions = controller.getEntities();
		System.assertEquals(Page.ClubEventAdministration.getUrl(), controller.cancel().getUrl());
		System.assertEquals('SF Bay Chapter', controller.getEntityName());
		System.assertEquals(Page.EventSummaryReport.getUrl(), controller.displayReport().getUrl());
		controller.reportOption = 'GRP';
		evList = controller.getEvents();
		System.debug('eventList2:' + evList);
		
		String dtBeginString = controller.getDtBeginString();
		String dtEndString = controller.getDtEndString();
		controller.setDtBeginString(dtBeginString);
		controller.setDtEndString(dtEndString);
		
		controller.setDtBeginString('');
		controller.setDtEndString('');
		System.assertEquals('', controller.getDtBeginString());
		System.assertEquals('', controller.getDtEndString());
		
		controller.setEntityType(null);
		System.assertEquals('Group', controller.getEntityType());
		
		Club_Event__c clubEvent = controller.clubEvent;
		clubEvent.National_Campaign_Global__c = 'Beyond Coal';
		clubEvent.Campaign_Strategy_Global__c = 'Clean Energy';
		clubEvent.Local_Campaign_Global__c = 'AES Cayuga';
		
		controller.setClubEntity(SFBayChapter.Id);
		System.assertEquals('Chapter', controller.getEntityType());
		controller.reportOption = 'CHAPINCLUDE';
		evList = controller.getEvents();
		System.assertEquals(true, controller.getHasAddlCriteria());
		reportTitle = controller.getReportTitle();

    }
}