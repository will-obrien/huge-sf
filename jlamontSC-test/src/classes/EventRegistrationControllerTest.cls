@isTest
private class EventRegistrationControllerTest {
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    private static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    private static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    static testMethod void myUnitTest() {
    	ClubEventTriggerHandler.testing = true;
    	Campaign evnt = new Campaign(
    		RecordTypeId = eventsTypeId,
    		Name = 'Testing',
    		Event_Name__c = 'Testing',
    		Status__c = 'In Development',
    		Events_Category__c = 'Outing',
    		Events_Type__c = 'Hike',
    		Start_Date__c = System.today(),
    		Start_Time__c = '8:00 AM',
    		Time_Zone__c = 'Local Time',
    		Summary_Description__c = 'Testing',
    		Sponsor_Description__c = 'Test Sponsor',
    		Autoresponder_Text__c = 'National',
    		Require_Phone_Number__c = true,
    		Require_Street_Address__c = true,
    		Require_ZIP_Code__c = true,
    		Require_Field_1__c = true,
    		Require_Field_2__c = true,
    		Require_Field_3__c = true,
    		Require_Field_4__c = true,
    		Require_Field_5__c = true,
    		Custom_Field_1_Label__c = 'Label1',
    		Custom_Field_2_Label__c = 'Label2',
    		Custom_Field_3_Label__c = 'Label3',
    		Custom_Field_4_Label__c = 'Label4',
    		Custom_Field_5_Label__c = 'Label5',
    		Publish_Date__c = System.today(),
    		Unpublish_Date__c = System.today() + 1
    	);
    	insert evnt;

        Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
        );
    	insert account1;
    	
    	Contact contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            RecordTypeId = contactHouseholdTypeId,
            rC_Connect__Public_Token__c = 'No Key Found'
    	);
    	insert contact1;
    	
    	Contact testContact = [select Id, FirstName, LastName, rC_Connect__Public_Token__c from Contact LIMIT 1];
    	System.debug('testContact:' + testContact);
    	
 		PageReference pageRef = Page.details;
        Test.setCurrentPage(pageRef);

		System.debug('First getRegistration Call');
      	EventRegistrationController controller = new EventRegistrationController();
      	ApexPages.currentPage().getParameters().put('formcampaignid', evnt.Id);
      	ApexPages.currentPage().getParameters().put('id', 'testing1234');
      	Event_Registration__c reg = controller.getRegistration();
      
		System.debug('Second getRegistration Call');
      	controller = new EventRegistrationController();
      	ApexPages.currentPage().getParameters().put('formcampaignid', evnt.Id);
      	ApexPages.currentPage().getParameters().put('data', contact1.rC_Connect__Public_Token__c);
      	reg = controller.getRegistration();
      	
      	Boolean isMobileSubscriber = controller.getIsMobileSubscriber();
      	System.assertEquals(false, isMobileSubscriber);
      	
      	Boolean isEventCampaign = controller.getIsEventCampaign();
      	System.assertEquals(true, isEventCampaign);
      	
      	Boolean hasEventEnded = controller.getHasEventEnded();
      	System.assertEquals(false, hasEventEnded);
      	
      	Boolean hasEventStarted = controller.getHasEventStarted();
      	System.assertEquals(false, hasEventStarted);
      	
      	Boolean isRsvpEnded = controller.getIsRsvpEnded();
      	System.assertEquals(false, isRsvpEnded);
      	
      	Boolean isPublished = controller.getIsPublished();
      	System.assertEquals(true, isPublished);
      	
      	reg = new Event_Registration__c(
      		Street__c = 'street',
      		City__c = 'city',
      		State__c = 'ca',
      		Mobile_Subscriber_Opt_In__c = true
      	);
      	controller.setRegistration(reg);
      	controller.save();

		Set<String> msgSet = new Set<String>();      	
      	List<Apexpages.Message> msgs = ApexPages.getMessages();
		for(Apexpages.Message msg : msgs){
			msgSet.add(msg.getDetail());
		}
		System.assert(msgSet.contains('First Name is Required'));
		System.assert(msgSet.contains('Last Name is Required'));
		System.assert(msgSet.contains('Email is Required'));
		System.assert(msgSet.contains('Phone is Required'));
		System.assert(msgSet.contains('A Complete Address is Required'));
		System.assert(msgSet.contains('Please enter a response for \'Label1\''));
		System.assert(msgSet.contains('Please enter a response for \'Label2\''));
		System.assert(msgSet.contains('Please enter a response for \'Label3\''));
		System.assert(msgSet.contains('Please enter a response for \'Label4\''));
		System.assert(msgSet.contains('Please enter a response for \'Label5\''));
		System.assert(msgSet.contains('To join Sierra Club\'s Mobile Action Network, you must provide your Mobile Phone Number'));
		
		reg.Email__c = 'junk';
		reg.Phone__c = 'junk';
		reg.Mobile_Phone__c = 'junk';
		controller.setRegistration(reg);

		System.debug('*** Saving ...');
		controller.save();

		msgSet.clear();
      	msgs = ApexPages.getMessages();
		for(Apexpages.Message msg : msgs){
			msgSet.add(msg.getDetail());
		}
		System.assert(msgSet.contains('Invalid Phone'));
		System.assert(msgSet.contains('Invalid Mobile Phone'));
		System.assert(msgSet.contains('Invalid Email'));
		
		reg.Email__c = 'test@abc.xyz';
		reg.Phone__c = '4445556666';
		reg.Mobile_Phone__c = '6665554444';
		evnt.Require_Street_Address__c = false;
		evnt.Require_ZIP_Code__c = true;
		update evnt;
		
		controller = new EventRegistrationController();
      	ApexPages.currentPage().getParameters().put('formcampaignid', evnt.Id);
      	Campaign camp = controller.getCampaign();
      	controller.setRegistration(reg);
		controller.save();
		
		msgSet.clear();
      	msgs = ApexPages.getMessages();
		for(Apexpages.Message msg : msgs){
			msgSet.add(msg.getDetail());
		}
		System.assert(msgSet.contains('Postal Code is Required'));

		Event_Leader__c ldr = new Event_Leader__c(
			Campaign__c = evnt.Id,
			Leader_Name__c = 'Test',
			Email__c = 'test@test.com',
			Phone_or_Other_Contact_Information__c = '3334445555',
			Is_Primary_Leader__c = true
		);
		insert ldr;
		
		Event_Leader__c controllerLdr = controller.getEventLeader();
		System.assertEquals(ldr.Id, controllerLdr.Id);
		
		reg = new Event_Registration__c(
			First_Name__c = 'Test',
			Last_Name__c = 'Contact1',
			Email__c = 'test@abc.xyz',
			Phone__c = '2223334444',
      		Street__c = 'street',
      		City__c = 'city',
      		State__c = 'ca',
      		PostalCode__c = '94110',
      		Custom_Field_1_Response__c = 'Response',
      		Custom_Field_2_Response__c = 'Response',
      		Custom_Field_3_Response__c = 'Response',
      		Custom_Field_4_Response__c = 'Response',
      		Custom_Field_5_Response__c = 'Response'
      	);
		controller = new EventRegistrationController();
      	ApexPages.currentPage().getParameters().put('formcampaignid', evnt.Id);
      	ApexPages.currentPage().getParameters().put('id', 'testing1234');
      	camp = controller.getCampaign();
      	controller.setRegistration(reg);
      	controller.getCampaign().kwac__Thank_You_Page__c = 'http://www.sierraclub.org';
		controller.save();
      	controller.getCampaign().kwac__Thank_You_Page__c = null;
		controller.save();
		
		Boolean isRegistered = controller.getIsRegistered();
		System.assertEquals(true, isRegistered);
		
		Boolean hasLevel = controller.getHasLevel();
		controller.getCampaign().Full_Description__c = 'Testing';
		Boolean hasFullDescription = controller.getHasFullDescription();
		controller.getCampaign().Full_Description__c = null;
		hasFullDescription = controller.getHasFullDescription();
		String levelDescription = controller.getLevelDescription();
		Boolean isClubEvent = controller.getIsClubEvent();
		String cancellationPolicy = controller.getCancellationPolicy();
		String testText = controller.getRSVPButtonText();
		controller.getCampaign().RSVP_Button_Text__c = 'Sign me up';
		testText = controller.getRSVPButtonText();
		controller.getCampaign().Cancellation_Option__c = 'Other';
		testText = controller.getCancellationPolicy();
		controller.getCampaign().Full_Description__c = '<img></img>';
		hasFullDescription = controller.getHasFullDescription();
		controller.getCampaign().Events_Category__c = 'Outing';
		controller.getCampaign().Level__c = 'Easy';
		controller.getCampaign().Entity_Specific_Level__c = '1A';
		testText = controller.getLevelDescription();
		controller.getCampaign().End_Date__c = System.today() + 1;
		controller.getHasEventEnded();
		
		controller.acknowledged = false;
		controller.canOpen = false;
		controller.savePdf();
		controller.canOpen = true;
		controller.acknowledged = true;
		controller.isMinor = true;
		controller.savePdf();
		controller.guardianFirstName = 'First';
		controller.guardianLastName = 'L';
		controller.guardianEmail = 'abc';
		controller.savePdf();
		controller.guardianLastName = 'Last';
		controller.guardianEmail = 'abc@xyz.com';
		controller.imageAuthorizationDeclined = false;
		controller.savePdf();
		
		controller.imageAuthorizationDeclined = true;
		controller.savePdf();
		
		controller.paperWaiver();
    }
}