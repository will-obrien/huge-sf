@isTest
private class BulkEntryProcessorTest {
    private static Id offlineActionTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Offline').getRecordTypeId();

    static testMethod void test1() {
        Campaign camp = new Campaign (Name='Z17Z567890');
        insert camp;
        Original_Campaign__c oCampName = new Original_Campaign__c(Campaign_Name__c = camp.Name);
    	insert oCampName;
		OriginalCampaignName__c origCampName = new OriginalCampaignName__c();

    	List<sObject> objectsToInsert = new List<sObject>();
    	
    	Account account1 = new Account(Name='John Smith');
    	insert account1;
    	Contact contact1 = new Contact(FirstName = 'John', LastName = 'Smith', AccountId=account1.Id);
    	objectsToInsert.add(contact1);
    	
    	Interest__c interest = new Interest__c(
    		Interest_Type__c = 'Activity',
    		Interest_Description__c = 'Canvassing'
    	);
    	objectsToInsert.add(interest);
    	Campaign event = new Campaign(
    		Name = 'X04QGAIA',
    		Status__c = 'Active'
    	);
    	objectsToInsert.add(event);
    	rC_Bios__Preference__c preference = new rC_Bios__Preference__c(
    		rC_Bios__Category__c = 'Classification',
    		rC_Bios__Subcategory__c = 'Grasstop'
    	);
    	objectsToInsert.add(preference);
    	kweos__EOCS_Data__c action = new kweos__EOCS_Data__c(
    		RecordTypeId = offlineActionTypeId,
    		Action__c = 'Petition Collection',
    		Action_Date__c = System.today(),
    		Action_Status__c = 'Completed'
    	);
    	objectsToInsert.add(action);
    	
    	insert objectsToInsert;
    	
    	BulkEntryController ctl = new BulkEntryController();
    	ctl.selectedEvent = event;
    	ctl.selectedAction = action;
    	ctl.selectedInterest = interest;
    	ctl.selectedPreference = preference;
    	
    	BulkEntryController.EntryRow row1 = new BulkEntryController.EntryRow();
    	row1.Id = contact1.Id;
    	row1.email = 'tsmith@xyz.com';
    	row1.phone = '4159775687';
    	row1.updateAddress = false;
    	row1.updateEmail = true;
    	row1.updatePhone = true;
    	row1.remove = false;
    	ctl.rowsMatched.add(row1);
    	
    	BulkEntryController.EntryRow row2 = new BulkEntryController.EntryRow();
    	row2.firstName = 'John';
    	row2.lastName = 'Smith';
    	row2.email = 'jsmith@abc.com';
    	row2.updateAddress = false;
    	row2.updateEmail = false;
    	row2.updatePhone = false;
    	row2.remove = false;
    	ctl.rowsNotMatched.add(row2);
    	    	
    	BulkEntryProcessor processor = new BulkEntryProcessor(ctl);
    	processor.processRows();

   		List<Event_Registration__c> savedRegistrations = [
   			select Id from Event_Registration__c
   			where Contact__c = :contact1.Id
   		];
   		System.assertEquals(1, savedRegistrations.size());
   		
   		List<rC_Connect__Batch_Upload__c> savedUploads = [
   			select 
				rC_Connect__Contact_1_First_Name__c,
				rC_Connect__Contact_1_Last_Name__c,
				rC_Connect__Address_Street_Line_1__c,
				rC_Connect__Address_City__c,
				rC_Connect__Address_State__c,
				rC_Connect__Address_Postal_Code__c,
				rC_Connect__Contact_1_Email__c,
				rC_Connect__Contact_1_Phone_1__c,
				Event_Registration_Id__c,
				kwrcac__KW_Advocacy_Id__c,
				Interest_Type__c,
				Interest_Description__c,
				rC_Connect__Preferences_1_Category__c,
				rC_Connect__Preferences_1_Subcategory__c,
				rC_Connect__Batch_Upload_Campaign_Matched__c
			from rC_Connect__Batch_Upload__c
   		];
   		System.assertEquals(1, savedUploads.size());

   		row1.updateEmail = false;
   		row1.updatePhone = false;
   		    	
    	ctl.selectedEvent = null;
    	ctl.selectedActionCampaign = null;

    	Test.startTest();
    	processor.processRows();
    	
    	ctl.selectedCampaign = event;
    	processor.processRows();

		ctl.selectedCampaign = null;
		ctl.selectedActionCampaign = event;
		processor.processRows();
		
		row1.remove = true;
		row2.remove = true;
		processor.processRows();
		Test.stopTest();
   		
   		List<Contact> contactList = [
   			select 
   				rC_Bios__Home_Email__c,
   				rC_Bios__Preferred_Email__c,
   				HomePhone,
   				rC_Bios__Preferred_Phone__c
   			from Contact
   			where Id = :contact1.Id
   		];
    	Contact ctct = contactList.get(0);
    	System.assertEquals(row1.email, ctct.rC_Bios__Home_Email__c);
    	System.assertEquals('Home', ctct.rC_Bios__Preferred_Email__c);
    	System.assertEquals(row1.phone, ctct.HomePhone);
    	System.assertEquals('Home', ctct.rC_Bios__Preferred_Phone__c);
    }
    static testMethod void test2() {
		OriginalCampaignName__c origCampName = new OriginalCampaignName__c();
		origCampName.Name = 'X04QGAIA';
		insert origCampName;

    	List<Contact> contactsToInsert = new List<Contact>();
    	
    	Account account1 = new Account(Name='John Smith');
    	insert account1;
    	Contact contact1 = new Contact(FirstName = 'John', LastName = 'Smith', AccountId=account1.Id);
    	contactsToInsert.add(contact1);
    	Contact contact2 = new Contact(FirstName = 'Mary', LastName = 'Smith', AccountId=account1.Id);
    	contactsToInsert.add(contact2);
    	
    	insert contactsToInsert;
    	
    	Campaign event = new Campaign(
    		Name = 'X04QGAIA',
    		Status__c = 'Active'
    	);
    	insert event;
    	
    	Event_Registration__c eventReg = new Event_Registration__c(
			Contact__c = contact1.Id,
			Campaign__c = event.Id,
			Status__c = 'Attended'    		
    	);
    	insert eventReg;
    	
    	BulkEntryController ctl = new BulkEntryController();
    	ctl.selectedEvent = event;
    	ctl.selectedEventRegistrationStatus = 'Attended';
    	
    	BulkEntryController.EntryRow row1 = new BulkEntryController.EntryRow();
    	row1.Id = contact1.Id;
    	row1.email = 'jsmith@xyz.com';
    	row1.phone = '4159775687';
    	row1.updateAddress = true;
    	row1.updateEmail = false;
    	row1.updatePhone = false;
    	row1.street = '1234 Main St';
    	row1.city = 'Some City';
    	row1.state = 'CA';
    	row1.postalCode = '12345';
    	row1.remove = false;
    	ctl.rowsMatched.add(row1);
    	
    	BulkEntryController.EntryRow row2 = new BulkEntryController.EntryRow();
    	row2.Id = contact2.Id;
    	row2.email = 'msmith@abc.com';
    	row2.updateAddress = false;
    	row2.updateEmail = false;
    	row2.updatePhone = false;
    	row2.remove = false;
    	ctl.rowsMatched.add(row2);
	
		Test.startTest();    	    	
    	BulkEntryProcessor processor = new BulkEntryProcessor(ctl);
    	processor.processRows();
    	Test.stopTest();
    	
    	List<Event_Registration__c> eventList = [
    		select Id from Event_Registration__c
    		where Campaign__c = :event.Id and Status__c = 'Attended'
    	];
    	System.assertEquals(2, eventList.size());
    	
    	List<rC_Connect__Batch_Upload__c> uploadList = [
    		select
				rC_Connect__Address_Street_Line_1__c,
				rC_Connect__Address_City__c,
				rC_Connect__Address_State__c,
				rC_Connect__Address_Postal_Code__c
			from rC_Connect__Batch_Upload__c
			where rC_Connect__Batch_Upload_Contact_1_Matched__c = :contact1.Id		
    	];
    	System.assertEquals(1, uploadList.size());
    	rC_Connect__Batch_Upload__c upload = uploadList.get(0);
    	System.assertEquals(row1.street, upload.rC_Connect__Address_Street_Line_1__c);
    	System.assertEquals(row1.city, upload.rC_Connect__Address_City__c);
    	System.assertEquals(row1.state, upload.rC_Connect__Address_State__c);
    	System.assertEquals(row1.postalCode, upload.rC_Connect__Address_Postal_Code__c);
    }
}