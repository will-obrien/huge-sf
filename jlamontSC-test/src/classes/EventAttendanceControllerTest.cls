@isTest
private class EventAttendanceControllerTest {

    static testMethod void myUnitTest() {
		Club_Event__c event1 = new Club_Event__c(
			Event_Title__c = 'Test Event 1',
			Time_Begin__c = '8:00 AM',
			Date_Begin__c = System.today() + 1,
			Status__c = 'In Development',
			Event_Category__c = 'Outing',
			Sponsor_Description__c = 'Test',
			External_URL__c = 'http://test.com',
			Display_Method__c = 'External URL',
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
		
		SiteURL__c siteUrl = new SiteURL__c(
			Name = 'BaseSite',
			BaseURL__c = 'http://force.com/events/details',
			Testing__c = true
		);
		insert siteUrl;

		EventAttendanceController.ClubEvent evnt = EventAttendanceController.getEvent(event1.Id);
		evnt.signupList.clear();

		EventAttendanceController.Signup su0 = new EventAttendanceController.Signup();
		su0.registrationId = reg1.id;
		su0.email = 'test@gmail.com';
		su0.firstName = 'Test FirstName';
		su0.lastName = 'Test LastName';
		su0.status = 'Registered';
		su0.waiverIsDigital = true;
		su0.waiverSubmitted = true;
		su0.zip = '12345';
		su0.imageAuthorizationDeclined = false;
		su0.isMinor = false;
		evnt.signupList.add(su0);
		
		EventAttendanceController.Signup su1 = new EventAttendanceController.Signup();
		su1.email = 'test@abc.com';
		su1.firstName = 'Test';
		su1.lastName = 'Person1';
		su1.status = 'Attended';
		su1.waiverIsDigital = true;
		su1.waiverSubmitted = true;
		su1.zip = '12345';
		su1.imageAuthorizationDeclined = false;
		su1.isMinor = false;
		evnt.signupList.add(su1);

		EventAttendanceController.Signup su2 = new EventAttendanceController.Signup();
		su2.email = 'test2@xyz.com';
		su2.firstName = 'Test2';
		su2.lastName = 'Person2';
		su2.status = 'Attended';
		su2.waiverIsDigital = true;
		su2.waiverSubmitted = true;
		su2.zip = '54321';
		su2.imageAuthorizationDeclined = false;
		su2.isMinor = true;
		evnt.signupList.add(su2);

		Test.startTest();
		evnt = EventAttendanceController.saveEvent(evnt);
		Test.stopTest();
		
		System.assertEquals(3, evnt.signupList.size());
		
		List<rC_Connect__Batch_Upload__c> buList = [
			select Id from rC_Connect__Batch_Upload__c
			where rC_Connect__Contact_1_Email__c = :su1.email
		];
		System.assertEquals(1, buList.size());
		
		Event_Registration__c reg = [
			select Id, Waiver_Id__c from Event_Registration__c
			where Email__c = :su1.email
		];
		
		String docName = 'Event Waiver for ' + su1.firstName + ' ' + su1.lastName;
		List<Document> docList = [
			select Id, Name from Document
			where 
				Name = :docName
				and Id = :reg.Waiver_Id__c
		];
		System.assertEquals(1, docList.size());
		
		List<TriggeredSendEmail__c> tseList = [
			select 
				Email__c,
				RequestBody__c
			from TriggeredSendEmail__c
		];
		
		System.assertEquals(1, tseList.size());
		
		String pageBase = new EventAttendanceController().getPageBase();
		String salesforceBase = new EventAttendanceController().getSalesforceBase();
    }
}