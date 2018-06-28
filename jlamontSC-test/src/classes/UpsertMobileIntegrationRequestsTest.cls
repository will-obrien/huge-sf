@isTest
private class UpsertMobileIntegrationRequestsTest {

    static testMethod void eventRegistrationTest() {
    	List<Contact> contactList = new List<Contact>();
        Contact contact1 = new Contact(
        	FirstName = 'Test1',
        	LastName = 'Contact1'
        );
        contactList.add(contact1);

        Contact contact2 = new Contact(
        	FirstName = 'Test2',
        	LastName = 'Contact2'
        );
        contactList.add(contact2);
        
        Contact contact3 = new Contact(
        	FirstName = 'Test3',
        	LastName = 'Contact3'
        );
        contactList.add(contact3);
        
        insert contactList;

        Event_Registration__c reg01 = new Event_Registration__c(
        	Contact__c = contact1.Id,
        	Mobile_Phone__c = '415-341-2347',
			Mobile_Subscriber_Opt_In__c = true
        );
        insert reg01;
        
        List<Event_Registration__c> eventRegList = new List<Event_Registration__c>();
        Event_Registration__c reg1 = new Event_Registration__c(
        	Contact__c = contact1.Id,
        	Mobile_Phone__c = '415-987-5687',
			Mobile_Subscriber_Opt_In__c = true
        );
        eventRegList.add(reg1);
        
        Event_Registration__c reg2 = new Event_Registration__c(
        	Mobile_Phone__c = '415-341-2347',
			Mobile_Subscriber_Opt_In__c = true
        );
        eventRegList.add(reg2);
        
        Event_Registration__c reg3 = new Event_Registration__c(
        	Contact__c = contact3.Id,
        	Mobile_Phone__c = '1415-341-2346',
			Mobile_Subscriber_Opt_In__c = true
        );
        eventRegList.add(reg3);

        Event_Registration__c reg4 = new Event_Registration__c(
        	Contact__c = contact3.Id,
        	Mobile_Phone__c = '1415-341-234789',
			Mobile_Subscriber_Opt_In__c = true
        );
        eventRegList.add(reg4);

        Event_Registration__c reg5 = new Event_Registration__c(
        	Contact__c = contact3.Id,
        	Mobile_Phone__c = '111-222-3333',
			Mobile_Subscriber_Opt_In__c = true
        );
        eventRegList.add(reg5);

        Event_Registration__c reg6 = new Event_Registration__c(
        	Contact__c = contact3.Id,
        	Mobile_Phone__c = '415-111-1111',
			Mobile_Subscriber_Opt_In__c = true
        );
        eventRegList.add(reg6);

        insert eventRegList;
        
        List<Mobile_Integration_Request__c> requestList = [
        	select Contact__c, Phone_Key__c from Mobile_Integration_Request__c
        ];
        
        System.assertEquals(3, requestList.size());
        
        reg2.Contact__c = contact2.Id;
        update reg2;
        
        requestList = [
        	select Contact__c, Phone_Key__c from Mobile_Integration_Request__c
        	where Contact__c = :reg2.Contact__c
        ];
        
        System.assertEquals(1, requestList.size());
        
    }
    static testMethod void advocacyActionTest() {
    	List<Contact> contactList = new List<Contact>();
        Contact contact1 = new Contact(
        	FirstName = 'Test1',
        	LastName = 'Contact1'
        );
        contactList.add(contact1);

        Contact contact2 = new Contact(
        	FirstName = 'Test2',
        	LastName = 'Contact2'
        );
        contactList.add(contact2);
        
        Contact contact3 = new Contact(
        	FirstName = 'Test3',
        	LastName = 'Contact3'
        );
        contactList.add(contact3);
        
        insert contactList;

        List<kweos__EOCS_Data__c> actionList = new List<kweos__EOCS_Data__c>();
        kweos__EOCS_Data__c action1 = new kweos__EOCS_Data__c(
        	kwac__Contact__c = contact1.Id,
        	kweos__Phone__c = '415-987-5687',
			Mobile_Opt_In__c = true
        );
        actionList.add(action1);

        kweos__EOCS_Data__c action2 = new kweos__EOCS_Data__c(
        	kweos__Phone__c = '415-341-2347',
			Mobile_Opt_In__c = true
        );
        actionList.add(action2);
        
		insert actionList;

        List<Mobile_Integration_Request__c> requestList = [
        	select Contact__c, Phone_Key__c from Mobile_Integration_Request__c
        ];
		System.assertEquals(1, requestList.size());
		
        kweos__EOCS_Data__c actionUpdate = new kweos__EOCS_Data__c(
        	Id = action2.Id,
        	kwac__Contact__c = contact2.Id
        );
		update actionUpdate;
		
        requestList = [
        	select Contact__c, Phone_Key__c from Mobile_Integration_Request__c
        ];
		System.assertEquals(2, requestList.size());
    }
}