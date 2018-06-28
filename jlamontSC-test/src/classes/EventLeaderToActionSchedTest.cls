@isTest
private class EventLeaderToActionSchedTest {
    
	// Dummy CRON expression. Because this is a test, job executes immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();

    static testmethod void testScheduledJob() {
        ClubEventTriggerHandler.testing = true;
        
        //create test data
        Campaign cmp = new Campaign(
        	RecordTypeId = eventsTypeId,
        	Name = 'Testing',
        	Event_Name__c = 'Testing',
        	Status__c = 'In Development',
        	Events_Category__c = 'Outing',
        	Events_Type__c = 'Hike',
        	Start_Date__c = System.today().AddDays(-1),
        	Start_Time__c = '8:00 AM',
        	Time_Zone__c = 'Local Time',
        	Summary_Description__c = 'Testing',
        	Display_Method__c = 'Salesforce Events Page',
        	Sponsor_Description__c = 'Test Sponsor');
        insert cmp;
        
        Campaign cmp2 = new Campaign(
        	RecordTypeId = eventsTypeId,
        	Name = 'Testing 2',
        	Event_Name__c = 'Testing',
        	Status__c = 'In Development',
        	Events_Category__c = 'Outing',
        	Events_Type__c = 'Hike',
        	Start_Date__c = System.today().AddDays(-1),
        	Start_Time__c = '8:00 AM',
        	Time_Zone__c = 'Local Time',
        	Summary_Description__c = 'Testing',
        	Display_Method__c = 'Salesforce Events Page',
        	Sponsor_Description__c = 'Test Sponsor');
        insert cmp2;
        
        Contact con = new Contact(
        	FirstName = 'Test',
        	LastName = 'Contact');
        insert con;
        
        Event_Leader__c ldr = new Event_Leader__c(
        	Contact__c = con.Id,
        	Campaign__c = cmp.Id,
        	Is_Primary_Leader__c = true,
        	Leader_Name__c = 'Test Leader');
        insert ldr;
        
        Event_Leader__c ldr2 = new Event_Leader__c(
        	Contact__c = con.Id,
        	Campaign__c = cmp2.Id,
        	Is_Primary_Leader__c = true,
        	Leader_Name__c = 'Test Leader 2');
        insert ldr2;
        
        cmp.Status__c = 'Active';
        update cmp;
        
        //run test
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new EventLeaderToActionSched());
        Test.stopTest();
        
        //check results, one advocacy action should have been created for the Active Event and leader updated
        List<kweos__EOCS_Data__c> advAction = [SELECT Id FROM kweos__EOCS_Data__c WHERE kwac__Contact__c = :con.Id AND kwac__Related_Action__c = :cmp.Id];
        System.assertEquals(1, advAction.size());
        
        //check results, no advocacy action should have been created for the In Development Event and leader not updated
        List<kweos__EOCS_Data__c> advAction2 = [SELECT Id FROM kweos__EOCS_Data__c WHERE kwac__Contact__c = :con.Id AND kwac__Related_Action__c = :cmp2.Id];
        System.assertEquals(0, advAction2.size());

    }

}