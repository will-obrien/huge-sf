@isTest
private class ActionsForEventAttendeesCtlTest {
    private static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    private static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();

    static testMethod void myUnitTest() {
        ClubEventTriggerHandler.testing = true;
		Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
		List<Contact> contactList = new List<Contact>();
        Contact contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            Email = 'test1.contact1@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );
        contactList.add(contact1);  
          
		insert contactList;

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
    		Custom_Field_1_Label__c = '',
    		Custom_Field_2_Label__c = '',
    		Custom_Field_3_Label__c = '',
    		Custom_Field_4_Label__c = '',
    		Custom_Field_5_Label__c = '',
    		Autoresponder_Text__c = '',
    		Send_RSVP_to_Leader__c = true,
			Autoresponder_Type__c = 'National'
		);
    	insert evnt;
		
    	Event_Registration__c reg = new Event_Registration__c(
    		Campaign__c = evnt.Id,
    		Contact__c = contact1.Id,
    		Status__c = 'Registered',
    		First_Name__c = 'Test',
    		Last_Name__c = 'Contact1',
    		Email__c = 'test.contact1@sierraclub.org',
    		Phone__c = '',
    		Mobile_Phone__c = '',
    		Street__c = '',
    		City__c = '',
    		State__c = '',
    		PostalCode__c = '',
    		Custom_Field_1_Response__c = '',
    		Custom_Field_2_Response__c = '',
    		Custom_Field_3_Response__c = '',
    		Custom_Field_4_Response__c = '',
    		Custom_Field_5_Response__c = ''
    	);
    	insert reg;
	
		PageReference PageRef = Page.ActionsForEventAttendees;
		Test.setCurrentPage(PageRef);
		ApexPages.currentPage().getParameters().put('id', evnt.Id); 	
		ActionsForEventAttendeesCtl controller = new ActionsForEventAttendeesCtl();
		
		String eventTitle = controller.getEventTitle();
		System.assertEquals(evnt.Event_Name__c, eventTitle);
		
		kweos__EOCS_Data__c action = controller.action;
		action.Action__c = 'Petition Collection';
		action.Action_Status__c = 'Committed';
		action.Action_Date__c = System.today();
		
		List<ActionsForEventAttendeesCtl.Wrapper> attendeeList = controller.getRegistrantList();
		ActionsForEventAttendeesCtl.Wrapper wrapper = attendeeList.get(0);
		wrapper.isSelected = true;
		controller.save();
		
		List<kweos__EOCS_Data__c> actionList = [
			select Action__c, Action_Status__c, Action_Date__c
			from kweos__EOCS_Data__c
			where kwac__Contact__c = :contact1.Id
		];
		System.assertEquals(1, actionList.size());
		kweos__EOCS_Data__c actionForContact = actionList.get(0);
		System.assertEquals('Petition Collection', actionForContact.Action__c);
		System.assertEquals('Committed', actionForContact.Action_Status__c);
		System.assertEquals(System.today(), actionForContact.Action_Date__c);
		
		action.Action__c = 'Petition Collection';
		action.Action_Status__c = 'Committed';
		action.Action_Date__c = System.today();
		controller.saveAndMore();
		
		controller.cancel();
    }
}