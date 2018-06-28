@isTest
private class ClubEventAdminControllerTest {

    static testMethod void myUnitTest() {
        ClubEventAdminController controller = new ClubEventAdminController();
        PageReference eventsAdded = controller.eventsAdded();
        PageReference eventSummary = controller.eventSummary();
        PageReference eventsList = controller.eventsList();
        PageReference otherEntEvents = controller.otherEntEvents();
        
        System.assertEquals(Page.EventsAddedRequest.getUrl(), eventsAdded.getUrl());
        System.assertEquals(Page.EventSummaryRequest.getUrl(), eventSummary.getUrl());
        System.assertEquals(Page.ClubEventList.getUrl(), eventsList.getUrl());
        System.assertEquals(Page.otherEntEvents.getUrl(), otherEntEvents.getUrl());
    }
}