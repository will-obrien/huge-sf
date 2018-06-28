@isTest
private class CreateRecurringEventsTest {
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();

    static testMethod void myUnitTest() {
    	Date startDate = Date.newInstance(2080, 6, 10);
    	Campaign camp1 = new Campaign(
    		RecordTypeId = eventsTypeId,
    		Start_Date__c = startDate,
    		Start_Time__c = '8:00 AM',
    		End_Date__c = startDate,
    		End_Time__c = '5:00 PM',
    		Sponsor_Description__c = 'Test Sponsor',
            Name = 'Test Events Campaign',
            Recurring_Dates__c= '["2080-06-10T07:00:00.000Z","2080-07-08T07:00:00.000Z"]'
    	);
    	RecurringEvent__c recurringEvent = new RecurringEvent__c();
    	insert recurringEvent;
    	camp1.RecurringEvent__c = recurringEvent.Id;
	    ClubEventTriggerHandler.testing = true;
	   	insert camp1;

		RecurringEventLeader__c recurringLdr = new RecurringEventLeader__c();
		insert recurringLdr;
		
		Event_Leader__c ldr1 = new Event_Leader__c(
			Campaign__c = camp1.Id,
			Leader_Name__c = 'Test Leader',
            Phone_or_Other_Contact_Information__c = '415-977-5661', 
            Email__c = 'tleader@gmail.com',
            Is_Primary_Leader__c = true,
            RecurringEventLeader__c = recurringLdr.Id
		);
	    insert ldr1;
	    
	    CreateRecurringEvents creator = new CreateRecurringEvents(camp1.Id);
	    creator.execute(null);
	    
	    Set<Date> dates = new Set<Date>();
	    Date dt1 = Date.newInstance(2080, 6, 10);
	    Date dt2 = Date.newInstance(2080, 7, 8);
		dates.add(dt1);
		dates.add(dt2);	    
	    List<Campaign> campList = [
	    	select Id, Start_Date__c from Campaign 
	    	where Start_Date__c in :dates and RecurringEvent__c = :recurringEvent.Id
	    ];
	    System.assertEquals(2, campList.size());
	    
	    Set<Id> idSet = new Set<Id>();
	    for(Campaign camp : campList) {
	    	idSet.add(camp.Id);
	    }
	    List<Event_Leader__c> ldrs = [
	    	select Id from Event_Leader__c where Campaign__c in :idSet
	    ];
	    System.assertEquals(2, ldrs.size());
    }
}