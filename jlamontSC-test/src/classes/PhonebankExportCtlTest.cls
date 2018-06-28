@isTest
private class PhonebankExportCtlTest {
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

		Campaign camp2 = new Campaign(
			RecordTypeId = eventsTypeId,
			Name = 'TestCamp2',
			Start_Date__c = System.today(),
			Start_Time__c = '8:00 AM',
			Event_Name__c = 'Test Events Campaign',
			Status__c = 'In Development',
			Events_Category__c = 'Outing',
			Sponsor_Description__c = 'Test',
			External_URL__c = 'http://test.com',
			Display_Method__c = 'External URL',
			Interest_One__c = 'Phonebanking',
			Interest_Two__c = 'Petition',
			Custom_Field_1_Label__c = 'Field1',
			Custom_Field_2_Label__c = 'Field2',
			Custom_Field_3_Label__c = 'Field3',
			Custom_Field_4_Label__c = 'Field4'
		);
		insert camp2;
			
		CampaignMember campMbr2 = new CampaignMember(
			CampaignId = camp2.Id,
			ContactId = contact1.Id
		);
		insert campMbr2;

		PhonebankExportCtl ctl = new PhonebankExportCtl();
		PageReference pageRef = Page.PhonebankRequestExport;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', camp1.Id);
		ApexPages.currentPage().getParameters().put('segmentNumber', '0');
		ctl.export();

		ctl = new PhonebankExportCtl();
		pageRef = Page.PhonebankRequestExport;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', camp2.Id);
		ApexPages.currentPage().getParameters().put('segmentNumber', '0');
		ctl.export();
		
		ctl.getHeaderLine();
		ctl.segmentSize = 10;
		ctl.getSegment();				
    }    
}