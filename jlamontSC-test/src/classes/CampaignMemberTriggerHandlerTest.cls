/*********************************************************************************************************
Name              : CampaignMemberTriggerHandlerTest
Created By        : Justin LaMont
Created Date      : April 2017
Description       : Tests CampaignMemberTriggerHandler
Last Updated      : 
*********************************************************************************************************/

@isTest
private class CampaignMemberTriggerHandlerTest {
	
	private static final Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    private static final Id listsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lists').getRecordTypeId();
    private static final Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    private static final Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	

    static testMethod void myUnitTestOne() {
        
        TestrCSettingUtility.createrCSettings();
        ClubEventTriggerHandler.testing = true;
        
        List<Account> accountsToInsert = new List<Account>();
    	List<Contact> contactsToInsert = new List<Contact>();
    	List<Activity_Interests__c> activityInterestsToInsert = new List<Activity_Interests__c>();
    	List<CampaignMember> campaignMembersToInsert = new List<CampaignMember>();
        
        
        Activity_Interests__c Tabling = new Activity_Interests__c(Name = 'Tabling');
        activityInterestsToInsert.add(Tabling);
        
        Activity_Interests__c Training = new Activity_Interests__c(Name = 'Training');
        activityInterestsToInsert.add(Training);
        
        Activity_Interests__c Canvassing = new Activity_Interests__c(Name = 'Canvassing');
        activityInterestsToInsert.add(Canvassing);
        
        insert activityInterestsToInsert;
        
        Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
        );
    	accountsToInsert.add(account1);
    	
    	Account account2 = new Account(
            Name='Account2',
            RecordTypeId = accountHouseholdTypeId
        );
    	accountsToInsert.add(account2);
    	
    	Account account3 = new Account(
            Name='Account3',
            RecordTypeId = accountHouseholdTypeId
        );
        accountsToInsert.add(account3);
        
    	insert accountsToInsert;
    	
    	Contact contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            RecordTypeId = contactHouseholdTypeId
    	);
    	contactsToInsert.add(contact1);
    	
    	Contact contact2 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact2',
            Phone = '9146430489',
            RecordTypeId = contactHouseholdTypeId
    	);
    	contactsToInsert.add(contact2);
    	
    	Contact contact3 = new Contact(
    		AccountId = account3.Id,
    		FirstName = 'Test',
    		LastName = 'Contact3',
    		Phone = '9146430489',
    		RecordTypeId = contactHouseholdTypeId
    	);
    	contactsToInsert.add(contact3);
    	
    	insert contactsToInsert;

		Campaign camp1 = new Campaign(
			RecordTypeId = listsTypeId,
			Name = 'TestCamp1',
			Promo_Description__c = 'Test List Campaign', 
			Interest_One__c = 'Tabling',
			Interest_Two__c = 'Training',
			Interest_Three__c = 'Canvassing',
			Custom_Field_1_Label__c = 'Field1',
			Custom_Field_2_Label__c = 'Field2',
			Custom_Field_3_Label__c = 'Field3',
			Custom_Field_4_Label__c = 'Field4',
			Custom_Field_5_Label__c = 'Field5'
		);
		insert camp1;
		
		CampaignMember campMbr1 = new CampaignMember(
			CampaignId = camp1.Id,
			ContactId = contact1.Id,
            Status = 'To Contact',
            Contact_Attempts_Made__c = 0,
            Bad_Phone__c = false,
            Update_Phone__c = false,
            No_Phone__c = true,
            rC_Event__Phone__c = '9146430489',
            Custom_Field_1_Response__c = 'Custom Field 1 Response',
            Custom_Field_2_Response__c = 'Custom Field 2 Response',
            Custom_Field_3_Response__c = 'Custom Field 3 Response',
            Custom_Field_4_Response__c = 'Custom Field 4 Response',
            Custom_Field_5_Response__c = 'Custom Field 5 Response',
            Interest_One__c = True,
            Interest_Two__c = True,
            Interest_Three__c = True,
            Comments__c = 'comments'
		);
		campaignMembersToInsert.add(campMbr1);
		
		CampaignMember campMbr2 = new CampaignMember(
			CampaignId = camp1.Id,
			ContactId = contact2.Id,
            Status = 'To Contact',
            Contact_Attempts_Made__c = 0,
            Bad_Phone__c = true,
            Update_Phone__c = false,
            No_Phone__c = false,
            rC_Event__Phone__c = '9146430489',
            Custom_Field_1_Response__c = 'Custom Field 1 Response',
            Custom_Field_2_Response__c = 'Custom Field 2 Response',
            Custom_Field_3_Response__c = 'Custom Field 3 Response',
            Custom_Field_4_Response__c = 'Custom Field 4 Response',
            Custom_Field_5_Response__c = 'Custom Field 5 Response',
            Interest_One__c = True,
            Interest_Two__c = True,
            Interest_Three__c = True,
            Comments__c = 'comments'
		);
		campaignMembersToInsert.add(campMbr2);
		
		CampaignMember campMbr3 = new CampaignMember(
			CampaignId = camp1.Id,
			ContactId = contact3.Id,
            Status = 'To Contact',
            Contact_Attempts_Made__c = 0,
            Bad_Phone__c = false,
            Update_Phone__c = true,
            No_Phone__c = false,
            rC_Event__Phone__c = '9146720239',
            Custom_Field_1_Response__c = 'Custom Field 1 Response',
            Custom_Field_2_Response__c = 'Custom Field 2 Response',
            Custom_Field_3_Response__c = 'Custom Field 3 Response',
            Custom_Field_4_Response__c = 'Custom Field 4 Response',
            Custom_Field_5_Response__c = 'Custom Field 5 Response',
            Interest_One__c = True,
            Interest_Two__c = True,
            Interest_Three__c = True,
            Comments__c = 'comments'
		);
		campaignMembersToInsert.add(campMbr3);
		
		insert campaignMembersToInsert;
		
		
		campMbr1.Status = 'Contacted';
		campMbr2.Status = 'Contacted';
		campMbr3.Status = 'Contacted';
		
		update campMbr1;
		update campMbr2;
		update campMbr3;
		
        
    }
    
    static testMethod void myUnitTestTwo() {
    	
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
			Interest_One__c = 'celebrity',
			Interest_Two__c = 'coal',
			Interest_Three__c = 'camping',
			Custom_Field_1_Label__c = 'Field1',
			Custom_Field_2_Label__c = 'Field2',
			Custom_Field_3_Label__c = 'Field3',
			Custom_Field_4_Label__c = 'Field4',
			Custom_Field_5_Label__c = 'Field5'
			
		);
		insert camp1;
			
		CampaignMember campMbr1 = new CampaignMember(
			CampaignId = camp1.Id,
			ContactId = contact1.Id,
            Status = 'To Contact',
            Contact_Attempts_Made__c = 0,
            Bad_Phone__c = false,
            Update_Phone__c = false,
            No_Phone__c = true,
            rC_Event__Phone__c = '9146430489',
            Event_RSVP__c = 'Yes',
            Custom_Field_1_Response__c = 'Custom Field 1 Response',
            Custom_Field_2_Response__c = 'Custom Field 2 Response',
            Custom_Field_3_Response__c = 'Custom Field 3 Response',
            Custom_Field_4_Response__c = 'Custom Field 4 Response',
            Custom_Field_5_Response__c = 'Custom Field 5 Response',
            Interest_One__c = True,
            Interest_Two__c = True,
            Interest_Three__c = True,
            Comments__c = 'comments'
		);
		insert campMbr1;
    
		campMbr1.Status = 'Contacted';
		
		update campMbr1;
    
    }
    
}