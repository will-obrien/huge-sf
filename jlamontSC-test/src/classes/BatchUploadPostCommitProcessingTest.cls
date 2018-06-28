@isTest
private class BatchUploadPostCommitProcessingTest {
	static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    static testMethod void connectEventReg() {
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
				RecordTypeId = contactHouseholdTypeId
			);
		insert contact1;	
    	
    	Test.startTest();
    	Campaign camp = new Campaign(Name='Test Campaign');
    	insert camp;
    	Event_Registration__c eventReg = new Event_Registration__c(Campaign__c = camp.Id);
    	insert eventReg;
    	rC_Connect__Batch_Upload__c batchUpload = new rC_Connect__Batch_Upload__c(
    		Event_Registration_Id__c = eventReg.Id
    	);
    	insert batchUpload;
    	rC_Connect__Batch_Upload__c batchUpdate = new rC_Connect__Batch_Upload__c(
    		Id = batchUpload.Id,
    		rC_Connect__Batch_Upload_Status__c = 'Committed',
    		rC_Connect__Batch_Upload_Contact_1_Matched__c = contact1.Id
    	);
    	update batchUpdate;
    	Test.stopTest();
    	eventReg = [select Contact__c from Event_Registration__c where Id = :eventReg.Id];
    	System.assertEquals(contact1.Id, eventReg.Contact__c);
    }
    
    static testMethod void createCampaignMember() {
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
				RecordTypeId = contactHouseholdTypeId
			);
		insert contact1;	
    	
    	Test.startTest();
    	Campaign camp = new Campaign(Name='Test Campaign');
    	insert camp;
    	rC_Connect__Batch_Upload__c batchUpload = new rC_Connect__Batch_Upload__c(
    		Group_Campaign_Id__c = camp.Id
    	);
    	insert batchUpload;
    	rC_Connect__Batch_Upload__c batchUpdate = new rC_Connect__Batch_Upload__c(
    		Id = batchUpload.Id,
    		rC_Connect__Batch_Upload_Status__c = 'Committed',
    		rC_Connect__Batch_Upload_Contact_1_Matched__c = contact1.Id
    	);
    	update batchUpdate;
    	Test.stopTest();
    	CampaignMember mbr = [select CampaignId, ContactId from CampaignMember where CampaignId = :camp.Id];
    	System.assertEquals(contact1.Id, mbr.ContactId);
    }
	
	//
	// Testing Survey Response
	//
    static testMethod void connectSurveyResponse() {
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
				RecordTypeId = contactHouseholdTypeId
			);
		insert contact1;	
    	
    	Test.startTest();
    	Campaign camp = new Campaign(Name='Test Campaign');
    	insert camp;
    	
    	Survey_Response__c surveyResponse = new Survey_Response__c(Form_Campaign__c = camp.Id, Source_Campaign__c = camp.Id);
    	insert surveyResponse;
    	rC_Connect__Batch_Upload__c batchUpload = new rC_Connect__Batch_Upload__c(
    		Survey_Response_Id__c = surveyResponse.Id
    	);
    	insert batchUpload;
    	rC_Connect__Batch_Upload__c batchUpdate = new rC_Connect__Batch_Upload__c(
    		Id = batchUpload.Id,
    		rC_Connect__Batch_Upload_Status__c = 'Committed',
    		rC_Connect__Batch_Upload_Contact_1_Matched__c = contact1.Id
    	);
    	update batchUpdate;
    	Test.stopTest();
    	surveyResponse = [select Contact__c from Survey_Response__c where Id = :surveyResponse.Id];
    	System.assertEquals(contact1.Id, surveyResponse.Contact__c);
    }
    
    //test preference for inserted contact
    static testMethod void createPreference() {
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
				RecordTypeId = contactHouseholdTypeId
			);
		insert contact1;	
    	
    	Test.startTest();
    	rC_Bios__Preference_Code__c prefcode = new rC_Bios__Preference_Code__c(rC_Bios__Code_Value__c = 'TEST');
        insert prefcode;
    	
        rC_Connect__Batch_Upload__c batchUpload = new rC_Connect__Batch_Upload__c(
    		Preference_Code_New_Contact__c = 'TEST'
    	);
    	insert batchUpload;
    	rC_Connect__Batch_Upload__c batchUpdate = new rC_Connect__Batch_Upload__c(
    		Id = batchUpload.Id,
    		rC_Connect__Batch_Upload_Status__c = 'Committed',
            rC_Connect__Contact1_Status__c = 'Inserted',
    		rC_Connect__Batch_Upload_Contact_1_Matched__c = contact1.Id
    	);
    	update batchUpdate;
    	Test.stopTest();
    	rC_Bios__Preference__c pref = [select rC_Bios__Code_Value__c, rC_Bios__Contact__c  from rC_Bios__Preference__c where rC_Bios__Code_Value__c = 'TEST'];
    	System.assertEquals(pref.rC_Bios__Contact__c, contact1.Id);
    }
    
        //test interest
    static testMethod void createInterest() {
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
				RecordTypeId = contactHouseholdTypeId
			);
		insert contact1;	
    	
    	Test.startTest();
    	
        rC_Connect__Batch_Upload__c batchUpload = new rC_Connect__Batch_Upload__c(
    		Interest_Type__c = 'Activity',
            Interest_Description__c = 'Canvassing'
    	);
    	insert batchUpload;
    	rC_Connect__Batch_Upload__c batchUpdate = new rC_Connect__Batch_Upload__c(
    		Id = batchUpload.Id,
    		rC_Connect__Batch_Upload_Status__c = 'Committed',
    		rC_Connect__Batch_Upload_Contact_1_Matched__c = contact1.Id
    	);
    	update batchUpdate;
    	Test.stopTest();
    	Interest__c interest = [select Id, Contact__c  from Interest__c where Interest_Description__c = 'Canvassing'];
    	System.assertEquals(interest.Contact__c, contact1.Id);
    }
    
}