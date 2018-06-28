/*
	2/2017 Maslow - split into two methods to avoid too many SOQL queries error
*/
@isTest
private class EventRsvpApiTest {
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    private static Id promotionTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Promotion').getRecordTypeId();
	private static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	private static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    static testMethod void test1() {
    	EventRsvpApi.Registration reg = new EventRsvpApi.Registration();
    	reg.campaignId = '';
    	reg.city = '';
    	reg.contactId = '';
    	reg.country = '';
    	reg.email = '';
    	reg.eventId = 0;
    	reg.firstName = '';
    	reg.lastName = '';
    	reg.phone = '';
    	reg.postalCode = '';
    	reg.sourceURL = '';
    	reg.state = '';
    	reg.street = '';
    	
    	EventRsvpApi.RsvpResult result = EventRsvpApi.rsvp(reg);
    	Set<String> errorMessages = new Set<String>(result.errorList);
		
		System.assert(errorMessages.contains('Either a Campaign Id or an EventId is required'));
		System.assert(errorMessages.contains('Required field missing - First Name'));
		System.assert(errorMessages.contains('Required field missing - Last Name'));
		System.assert(errorMessages.contains('Required field missing - Email'));
		System.assert(errorMessages.contains('Required field missing - First Name'));
		System.assert(errorMessages.contains('Required field missing - Source URL'));
		
		reg.email = 'xyz';
		reg.phone = 'xyz';
		reg.contactId = 'xyz';
		reg.campaignId = 'xyz';
		reg.sourceURL = 'xyz';
		
    	result = EventRsvpApi.rsvp(reg);
    	errorMessages = new Set<String>(result.errorList);
		
		System.assert(errorMessages.contains('Invalid Email Address: ' + reg.email));
		System.assert(errorMessages.contains('Invalid Email Address: ' + reg.email));
		System.assert(errorMessages.contains('Invalid Contact Id'));
		System.assert(errorMessages.contains('Invalid Campaign Id'));
	
		List<Campaign> campList = new List<Campaign>();
		Campaign camp = new Campaign(
			Name = 'Test Event',
			RecordTypeId = promotionTypeId
		);
		campList.add(camp);
		
		Campaign sourceCamp = new Campaign(
			Name = 'Test Source Campaign',
			RecordTypeId = promotionTypeId
		);
		campList.add(sourceCamp);
		
		insert campList;
		
		reg.campaignId = camp.Id;
    	result = EventRsvpApi.rsvp(reg);
    	errorMessages = new Set<String>(result.errorList);
		
		System.assert(errorMessages.contains('Campaign is not an Event Campaign'));
		
		camp.RecordTypeId = eventsTypeId;
		camp.Registrations_Accepted__c = false;
		camp.Publish_Date__c = System.today() - 10;
		camp.Start_Date__c = System.today() - 10;
		camp.Start_Time__c = '8:00 AM';
		camp.End_Date__c = System.today() - 5;
		camp.End_Time__c = '5:00 PM';
		camp.Display_Method__c = 'Salesforce Events Page';
		camp.URL_to_Share__c = 'http://www.sierraclub.org';
		camp.Sponsor_Description__c = 'Test Sponsor';
        camp.Event_Name__c = 'Test Event';
        camp.Status__c = 'In Development';
		update camp;
		
    	result = EventRsvpApi.rsvp(reg);
    	errorMessages = new Set<String>(result.errorList);
		
		System.assert(errorMessages.contains('Registrations not accepted'));
		
		Event_Leader__c ldr = new Event_Leader__c(
			Campaign__c = camp.Id,
			Email__c = 'test@abc.com',
			Leader_Name__c = 'Test Leader',
			Is_Primary_Leader__c = true
		);
		insert ldr;
		camp.Registrations_Accepted__c = true;
		update camp;
		
    	result = EventRsvpApi.rsvp(reg);
    	errorMessages = new Set<String>(result.errorList);

		System.assert(errorMessages.contains('Registrations not accepted - status: In Development'));

		camp.Status__c = 'Active';
		update camp;
		 
    	result = EventRsvpApi.rsvp(reg);
    	errorMessages = new Set<String>(result.errorList);
		
		System.assert(errorMessages.contains('Event End Date is Past'));
		
		camp.End_Date__c = null;
		camp.End_Time__c = null;
		camp.Unpublish_Date__c = System.today() - 5;
		update camp;
		
    	result = EventRsvpApi.rsvp(reg);
    	errorMessages = new Set<String>(result.errorList);
		
		System.assert(errorMessages.contains('Event is no longer published'));
		
		camp.Unpublish_Date__c = System.today() + 5;
		update camp;
		
		reg.contactId = '';
		reg.firstName = 'Joe';
		reg.lastName = 'Test';
		reg.email = 'jtest@abc.com';
		reg.phone = '3334445555';
		
    	result = EventRsvpApi.rsvp(reg);
    	errorMessages = new Set<String>(result.errorList);
		System.assert(result.errorList.isEmpty());
		Event_Registration__c eventReg = [select Id, Campaign__c, Source_Campaign__c from Event_Registration__c];
		System.assertEquals(camp.Id, eventReg.Campaign__c);
		System.assertEquals(eventReg.Campaign__c, eventReg.Source_Campaign__c);

		rC_Connect__Batch_Upload__c bu = [
			select 
				rC_Connect__Contact_1_First_Name__c, 
				rC_Connect__Contact_1_Last_Name__c,
				rC_Connect__Contact_1_Email__c
			from rC_Connect__Batch_Upload__c
		];
		
		System.assertEquals(reg.firstName, bu.rC_Connect__Contact_1_First_Name__c);
		System.assertEquals(reg.lastName, bu.rC_Connect__Contact_1_Last_Name__c);
		System.assertEquals(reg.email, bu.rC_Connect__Contact_1_Email__c);
		
    }
    static testMethod void test2() {
		Account account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId
			);
		insert account1;
		Contact contact1 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact1',
				Email = 'abc@xyz.com',
				RecordTypeId = contactHouseholdTypeId
			);	
		insert contact1;

		List<Campaign> campList = new List<Campaign>();
		Campaign camp = new Campaign(
			Name = 'Test Event',
			RecordTypeId = eventsTypeId,
			Registrations_Accepted__c = true,
			Publish_Date__c = System.today(),
			Start_Date__c = System.today(),
			Start_Time__c = '8:00 AM',
			End_Date__c = System.today() + 1,
			End_Time__c = '5:00 PM',
			Display_Method__c = 'Salesforce Events Page',
			URL_to_Share__c = 'http://www.sierraclub.org',
			Sponsor_Description__c = 'Test Sponsor',
        	Event_Name__c = 'Test Event',
        	Status__c = 'In Development'
		);
		campList.add(camp);
		
		Campaign sourceCamp = new Campaign(
			Name = 'Test Source Campaign',
			RecordTypeId = promotionTypeId
		);
		campList.add(sourceCamp);
		
		ClubEventTriggerHandler.testing = true;
		insert campList;

		Event_Leader__c ldr = new Event_Leader__c(
			Campaign__c = camp.Id,
			Email__c = 'test@abc.com',
			Leader_Name__c = 'Test Leader',
			Is_Primary_Leader__c = true
		);
		insert ldr;
		
		camp.Status__c = 'Active';
		update camp;

    	EventRsvpApi.Registration reg = new EventRsvpApi.Registration();
    	reg.campaignId = camp.Id;
    	reg.city = '';
    	reg.contactId = contact1.Id;
    	reg.country = '';
    	reg.email = 'jtest@abc.com';
    	reg.eventId = 0;
    	reg.firstName = 'Joe';
    	reg.lastName = 'Test';
    	reg.phone = '3334445555';
    	reg.postalCode = '';
    	reg.sourceURL = '';
    	reg.state = '';
    	reg.street = '';
    	reg.sourceCampaignId = sourceCamp.Id;
    	reg.sourceURL = 'xyz';

    	EventRsvpApi.RsvpResult result = EventRsvpApi.rsvp(reg);
    	Set<String> errorMessages = new Set<String>(result.errorList);
    	System.debug('errorList: ' + result.errorList);
		System.assert(result.errorList.isEmpty());
		
    	result = EventRsvpApi.rsvp(reg);
    	errorMessages = new Set<String>(result.errorList);
		System.assert(errorMessages.contains('Contact has already registered for this Event'));
		
		reg.campaignId = null;
		reg.eventId = 99;
    	result = EventRsvpApi.rsvp(reg);
    	errorMessages = new Set<String>(result.errorList);
		System.assert(result.errorList.isEmpty());
		
    	result = EventRsvpApi.rsvp(reg);
    	errorMessages = new Set<String>(result.errorList);
		System.assert(errorMessages.contains('Contact has already Opted In for this Event'));
		
		reg.contactId = null;
		reg.campaignId = camp.Id;
		reg.sourceCampaignId = sourceCamp.Id;
    	result = EventRsvpApi.rsvp(reg);
    	errorMessages = new Set<String>(result.errorList);
		System.assert(result.errorList.isEmpty());
		List<Event_Registration__c> evList = [
			select Id, Campaign__c, Source_Campaign__c from Event_Registration__c
		];
		
		List<Event_Registration__c> evRegList = [
			select Id, Campaign__c, Source_Campaign__c from Event_Registration__c
			where Source_Campaign__c = :sourceCamp.Id
		];
		System.assert(evRegList.size() > 0);

		reg.sourceCampaignId = 'xyz';
    	result = EventRsvpApi.rsvp(reg);

    	reg.campaignId = null;
    	reg.sourceCampaignId = 'ABCD';
    	reg.contactId = null;
    	reg.eventId = 1234;
    	reg.eventId = 1234;
    	result = EventRsvpApi.rsvp(reg);
    }
}