@isTest
private class EventRegistrationTriggerHandlerTest {
    static Id eventId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    static Campaign camp1, camp2;
    static Event_Registration__c reg1, reg2;

    static testMethod void testInsert() {
    	setup();
        Test.startTest();
        insert reg1;
        Test.stopTest();
        
        Campaign testCamp = [
        	select Event_Registration_Count__c from Campaign
        	where Id = :camp1.Id
        ];
    	
    	System.assertEquals(1, testCamp.Event_Registration_Count__c);
    }
    static testMethod void testCancel() {
    	setup();
    	Test.startTest();
    	insert reg1;
    	reg1.Status__c = 'Cancelled';
    	update reg1;
    	Test.stopTest();

        Campaign testCamp = [
        	select Event_Registration_Count__c from Campaign
        	where Id = :camp1.Id
        ];
    	
    	System.assertEquals(0, testCamp.Event_Registration_Count__c);
    }
    static testMethod void testUncancel() {
    	setup();
    	Test.startTest();
    	insert reg2;
    	reg2.Status__c = 'Registered';
    	update reg2;
    	Test.stopTest();

        Campaign testCamp = [
        	select Event_Registration_Count__c from Campaign
        	where Id = :camp1.Id
        ];
    	
    	System.assertEquals(1, testCamp.Event_Registration_Count__c);
    }
    static testMethod void testDelete() {
    	setup();
    	Test.startTest();
    	insert reg1;
        rC_Connect__Batch_Upload__c bu = new rC_Connect__Batch_Upload__c (Name='Test', Event_Registration_Id__c=reg1.id);
        insert bu;
    	delete reg1;
    	Test.stopTest();

        Campaign testCamp = [
        	select Event_Registration_Count__c from Campaign
        	where Id = :camp1.Id
        ];
    	
    	System.assertEquals(0, testCamp.Event_Registration_Count__c);
    }
    static testMethod void testCampaignChange() {
    	setup();
    	Test.startTest();
    	insert reg1;
    	reg1.Campaign__c = camp2.Id;
    	update reg1;
  		Test.stopTest();
  		  	
        Campaign testCamp1 = [
        	select Event_Registration_Count__c from Campaign
        	where Id = :camp1.Id
        ];
        Campaign testCamp2 = [
        	select Event_Registration_Count__c from Campaign
        	where Id = :camp2.Id
        ];
    	
    	System.assertEquals(0, testCamp1.Event_Registration_Count__c);
    	System.assertEquals(1, testCamp2.Event_Registration_Count__c);    	
    }
    static testMethod void testPlugClubEventId() {
    	setup();
    	Club_Event__c clubEvent = new Club_Event__c(Campaign__c = camp1.Id);
    	insert clubEvent;
    	camp1.Club_Event__c = clubEvent.Id;
    	update camp1;
    	System.assertEquals(null, reg1.Club_Event__c);
    	Test.startTest();
    	insert reg1;
    	Test.stopTest();
    	Event_Registration__c regTest = [select Club_Event__c from Event_Registration__c where Id = :reg1.Id];
    	System.assertEquals(camp1.Club_Event__c, regTest.Club_Event__c);
    }
    
    static testMethod void testActions() {
    	setup();
        camp1.Add_Action_to_Attendees__c = 'Tabling';
        update camp1;
        
        Account Acct1 = new Account (Name = 'Test Account');
        insert Acct1;
        Contact Ct1 = new Contact (FirstName = 'Test', LastName = 'Contact', AccountId = Acct1.Id);
        insert Ct1;
        
    	Test.startTest();
    	insert reg1;
        reg1.Contact__c = Ct1.Id;
    	reg1.Status__c = 'Attended';
    	update reg1;
    	Test.stopTest();
        
        List<kweos__EOCS_Data__c> actionsCreated = [SELECT Id FROM kweos__EOCS_Data__c WHERE kwac__Related_Action__c = :camp1.Id];
    	
    	System.assertEquals(2, actionsCreated.size());
    }    
    private static void setup() {
    	ClubEventTriggerHandler.testing = true;
        List<Campaign> campList = new List<Campaign>();
        
        camp1 = new Campaign(
            Name = 'Test Event Campaign 1',
            Event_Name__c = 'Test Event Campaign',
            External_Id__c = 'Test Event Campaign 1',
            RecordTypeId = eventId,
            Start_Time__c = '8:00 AM',
            Sponsor_Description__c = 'Test Sponsor'
        );
        campList.add(camp1);
        
        camp2 = new Campaign(
            Name = 'Test Event Campaign 2',
            Event_Name__c = 'Test Event Campaign',
            External_Id__c = 'Test Event Campaign 2',
            RecordTypeId = eventId,
            Start_Time__c = '8:00 AM',
            Sponsor_Description__c = 'Test Sponsor'
        );
        campList.add(camp2);

        insert campList;
        
        reg1 = new Event_Registration__c(
        	Campaign__c = camp1.Id,
        	Status__c = 'Registered' 
        );
        reg2 = new Event_Registration__c(
        	Campaign__c = camp1.Id,
        	Status__c = 'Cancelled' 
        );
    }
}