@isTest
private class SummarizeEventRegistrationsTest {
    static Id eventId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();

    static testMethod void myUnitTest() {
    	ClubEventTriggerHandler.testing = true;
		Campaign camp1 = new Campaign(
            Name = 'Test Campaign',
            External_Id__c = 'Test Campaign',
            RecordTypeId = eventId,
            Event_Name__c = 'Test Event Campaign',
            Start_Time__c = '8:00 AM',
            Sponsor_Description__c = 'Test Sponsor'
		);
		insert camp1;
		
		Event_Registration__c reg1 = new Event_Registration__c(
			Campaign__c = camp1.Id,
			Status__c = 'Registered'
		);
		insert reg1;
		
		Test.startTest();
        Database.executeBatch(new SummarizeEventRegistrations());
        Test.stopTest();
        
        camp1 = [
        	SELECT Event_Registration_Count__c
        	FROM Campaign
        	WHERE Id = :camp1.Id 
        ];
		
		System.assertEquals(1, camp1.Event_Registration_Count__c);
    }
}