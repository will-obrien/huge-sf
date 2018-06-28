@isTest
private class SigninSheetControllerTest {

    static testMethod void myUnitTest() {
		Club_Event__c event1 = new Club_Event__c(
			Event_Title__c = 'Test Event 1',
			Time_Begin__c = '8:00 AM',
			Date_Begin__c = System.today() + 1,
			Status__c = 'In Development',
			Event_Category__c = 'Outing',
			Sponsor_Description__c = 'Test',
			Display_Method__c = 'External URL',
			External_URL__c = 'http://test.com',
			Waiver_Required__c = true
		);
		EventHelper.sourceObject = 'ClubEvent';
		insert event1;
		
        Event_Registration__c reg1 = new Event_Registration__c(
        	Club_Event__c = event1.Id,
			First_Name__c = 'Test FirstName',
			Last_Name__c = 'Test LastName',
			Email__c = 'test@gmail.com',
			Status__c = 'Registered',
			Waiver_is_Digital__c = true,
			Waiver_Submitted__c = true,
			Image_Authorization_Declined__c = false
        );
        insert reg1;

		SigninSheetController ctl = new SigninSheetController();
		List<Event_Registration__c> regList = ctl.getRegList();
		System.assertEquals(7, regList.size());		

		ctl = new SigninSheetController();
		PageReference pageRef = Page.SigninSheet;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', event1.Id);
		regList = ctl.getRegList();
		System.assertEquals(14, regList.size());		

		ctl.eventId = null;
		Club_Event__c testEvent = ctl.getClubEvent();
		System.assertEquals(event1.Id, testEvent.Id);
    }
}