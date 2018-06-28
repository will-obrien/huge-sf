@isTest
private class EventParticipantListControllerTest {
    static testMethod void myUnitTest() {
		Club_Entity__c ent = new Club_Entity__c(
			EntityId__c = '0100',
			Status__c = 'Active',
			Type__c = 'Chapter'
		);
		insert ent;

		Club_Event__c event1 = new Club_Event__c(
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
		EventHelper.sourceObject = 'ClubEvent';
		insert event1;
		
		Event_Registration__c reg = new Event_Registration__c(
			Club_Event__c = event1.Id
		);
		insert reg;

		PageReference pageRef = Page.EventParticipantList;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', event1.Id);

		EventParticipantListController controller = new EventParticipantListController();
		controller.getEvent();
		Club_Event__c controllerEvent = controller.getEvent();
		List<Event_Registration__c> participantList = controller.getParticipantList();
		String pageBase = controller.getPageBase();
		PageReference takeAttendance = controller.takeAttendance();
    }
}