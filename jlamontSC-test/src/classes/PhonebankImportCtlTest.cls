@isTest
private class PhonebankImportCtlTest {
    private static final Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    private static final Id listsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lists').getRecordTypeId();
    private static final Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    private static final Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    static testMethod void myUnitTest() {
    	
    	ClubEventTriggerHandler.testing = true;
    	TestrCSettingUtility.createrCSettings();
    	
        Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
        );
    	insert account1;
    	
    	Contact contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            Phone = '4159775660',
            RecordTypeId = contactHouseholdTypeId
    	);
    	insert contact1;

		Campaign camp1 = new Campaign(
			RecordTypeId = listsTypeId,
			Name = 'TestCamp1',
			Promo_Description__c = 'Test List Campaign', 
			Interest_One__c = 'Phonebanking',
			Interest_Two__c = 'Petition',
			Interest_Three__c = 'Tabling',
			Custom_Field_1_Label__c = 'Field1',
			Custom_Field_2_Label__c = 'Field2',
			Custom_Field_3_Label__c = 'Field3',
			Custom_Field_4_Label__c = 'Field4',
			Custom_Field_5_Label__c = 'Field5'
		);
		insert camp1;
		
		CampaignMember campMbr1 = new CampaignMember(
			CampaignId = camp1.Id,
			ContactId = contact1.Id
		);
		insert campMbr1;

		PhonebankImportCtl ctl = new PhonebankImportCtl();
		
		ctl.getHasFileBody();
		ctl.processFileContents();
		
		PageReference pageRef = Page.PhonebankImport;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', camp1.Id);
		
		String fileHeader;
		String fileBody;
		
		fileHeader = 
			'CORE Campaign Member Id,' +
			'First Name,' +
			'Last Name,' +
			'Phone Number,' +
			'Event: N/A,' +
			'Custom Question One,' +
			'Custom Question Two,' +
			'Custom Question Three,' +
			'Custom Question Four,' +
			'Custom Question Five,' +
			'No Answer,' +
			'Left Message,' +
			'Bad Phone,' +
			'Update Phone,' +
			'Do Not Call,' +
			'Non-English Speaker,' +
			'# Call Attempts,' +
			'Interest: N/A,' +
			'Interest: N/A,' +
			'Interest: N/A' 
			;
		
    	String fileBodyString = fileHeader + '\r\n' +
    		campMbr1.Id + ',' +
    		contact1.FirstName + ',' +
    		contact1.LastName + ',' +
    		'4159775660' + ',' +
			'Mr. Blue,' +  //Q1
			',' +  //Q2
			',' +  //Q3
			',' +  //Q4
			',' +  //Q5
			',' +  //no answer
			',' +  //left message
			',' +  //bad phone
			',' +  //update phone
			',' +  //Do not call
			',' +  //Non-English Speaker
			'3,' +  //call attempts
			'y,' +  //I1
			'y,' +  //I2
			'y,' +  //I3	
			'\r\n'
    		;
    	ctl.fileBodyString = fileBodyString;
    	ctl.setFileBody(Blob.valueOf(fileBodyString));
    	ctl.getFileBody();
    	Boolean hasFileBody = ctl.getHasFileBody();
    	ctl.processFileContents();
    	
    	fileBodyString = fileHeader + '\r\n' +
    		',' +
    		',' +
    		',' +
    		',' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'\r\n'
    		;
    	ctl.setFileBody(Blob.valueOf(fileBodyString));
    	ctl.processFileContents();    	

    	fileBodyString = fileHeader + '\r\n' +
    		',' +
    		',' +
    		',' +
    		',' +
			'JUNK,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'\r\n'
    		;
    	ctl.setFileBody(Blob.valueOf(fileBodyString));
    	ctl.processFileContents();    	

    	fileBodyString = fileHeader + '\r\n' +
    		'abcde1234,' +
    		',' +
    		',' +
    		'abcde1234,' +
    		'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'1234,' +
			'JUNK,' +
			'JUNK,' +
			'true,' +
			'\r\n'
    		;
    	ctl.setFileBody(Blob.valueOf(fileBodyString));
    	ctl.processFileContents();
    	ctl.getEventName();    	

    	fileBodyString = fileHeader + '\r\n' +
    		contact1.Id + ',' +
    		',' +
    		',' +
    		'abcde1234,' +
    		'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'1234,' +
			'JUNK,' +
			'JUNK,' +
			'JUNK,' +
			'true,' +
			'\r\n'
    		;
    	ctl.setFileBody(Blob.valueOf(fileBodyString));
    	ctl.processFileContents();
    	ctl.getEventName();
    	
    	fileBodyString = fileHeader + '\r\n' +
    		campMbr1.Id + ',' +
    		contact1.FirstName + ',' +
    		contact1.LastName + ',' +
    		'4159775660' + ',' +
			'Mr. Blue,' +  //Q1
			',' +  //Q2
			',' +  //Q3
			',' +  //Q4
			',' +  //Q5
			',' +  //no answer
			',' +  //left message
			',' +  //bad phone
			',' +  //update phone
			',' +  //Do not call
			',' +  //Non-English Speaker
			'3,' +  //call attempts
			'y,' +  //I1
			'y,' +  //I2
			'y,' +  //I3			
			'\r\n'  
    		;
    	ctl.fileBodyString = fileBodyString;
    	ctl.setFileBody(Blob.valueOf(fileBodyString));
    	ctl.processFileContents();
    	
    	CampaignMember campMbr = [
    		select
				rC_Event__Phone__c,
				Bad_Phone__c,
				Update_Phone__c,
				Contact_Attempts_Made__c,
				Custom_Field_1_Response__c,
				Custom_Field_2_Response__c,
				Custom_Field_3_Response__c,
				Custom_Field_4_Response__c,
				Custom_Field_5_Response__c,
				Status,
				No_Phone__c,
				Event_RSVP__c,
				Interest_One__c,
				Interest_Two__c,
				Interest_Three__c
			from CampaignMember
			where Id=:campMbr1.Id
    	];
    
    	//System.assertEquals(false, campMbr.Bad_Phone__c);
    	//System.assertEquals(3, campMbr.Contact_Attempts_Made__c);
    	//System.assertEquals('Contacted', campMbr.Status);
    	//System.assertEquals(false, campMbr.No_Phone__c);
    	//System.assertEquals(true, campMbr.Interest_One__c);
    	//System.assertEquals(true, campMbr.Interest_Two__c);
    	//System.assertEquals(true, campMbr.Interest_Three__c);
    }
}