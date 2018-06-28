@isTest
private class UpdateRecurringEventsTest {
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
            Event_Name__c = 'Test Events Campaign',
            Recurring_Dates__c= '["2080-06-10T07:00:00.000Z","2080-07-08T07:00:00.000Z"]'
    	);
    	RecurringEvent__c recurringEvent = new RecurringEvent__c();
    	insert recurringEvent;
    	camp1.RecurringEvent__c = recurringEvent.Id;
	    ClubEventTriggerHandler.testing = true;
	   	insert camp1;

		List<RecurringEventLeader__c> recurringLdrList = new List<RecurringEventLeader__c>();

		RecurringEventLeader__c recurringLdr1 = new RecurringEventLeader__c();
		recurringLdrList.add(recurringLdr1);

		RecurringEventLeader__c recurringLdr2 = new RecurringEventLeader__c();
		recurringLdrList.add(recurringLdr2);
		
		RecurringEventLeader__c recurringLdr3 = new RecurringEventLeader__c();
		recurringLdrList.add(recurringLdr3);
		
		insert recurringLdrList;

		List<Event_Leader__c> eventLeaderList = new List<Event_Leader__c>();
		Event_Leader__c ldr1 = new Event_Leader__c(
			Campaign__c = camp1.Id,
			Leader_Name__c = 'Test Leader1',
            Phone_or_Other_Contact_Information__c = '415-977-5661', 
            Email__c = 'tleader1@gmail.com',
            Is_Primary_Leader__c = true,
            RecurringEventLeader__c = recurringLdr1.Id
		);
		eventLeaderList.add(ldr1);

		Event_Leader__c ldr2 = new Event_Leader__c(
			Campaign__c = camp1.Id,
			Leader_Name__c = 'Test Leader2',
            Phone_or_Other_Contact_Information__c = '415-977-5771', 
            Email__c = 'tleader2@gmail.com',
            Is_Primary_Leader__c = false,
            RecurringEventLeader__c = recurringLdr2.Id
		);
		eventLeaderList.add(ldr2);

	    insert eventLeaderList;
	    
	    CreateRecurringEvents creator = new CreateRecurringEvents(camp1.Id);
	    creator.execute(null);
		
		List<Event_Leader__c> ldrList = [
			select Id from Event_Leader__c where RecurringEventLeader__c in (:recurringLdr1.Id, :recurringLdr2.Id) 	
		];
		System.assertEquals(4, ldrList.size());
		
		ldr1.Leader_Name__c = 'Modified Leader1';
		update ldr1;
		delete ldr2;
		
		Event_Leader__c ldr3 = new Event_Leader__c(
			Campaign__c = camp1.Id,
			Leader_Name__c = 'Test Leader3',
            Phone_or_Other_Contact_Information__c = '415-977-5781', 
            Email__c = 'tleader3@gmail.com',
            Is_Primary_Leader__c = false,
            RecurringEventLeader__c = recurringLdr3.Id
		);
		insert ldr3;
		
		List<Event_Leader__c> leadersToUpdate = new List<Event_Leader__c>();
		leadersToUpdate.add(ldr1);
		leadersToUpdate.add(ldr3);
		List<Event_Leader__c> leadersToDelete = new List<Event_Leader__c>();
		leadersToDelete.add(ldr2);
		
		UpdateRecurringEvents ure = new UpdateRecurringEvents(camp1.Id, false, leadersToUpdate, leadersToDelete);
		ure.execute(null);
		
		ldrList = [
			select Id from Event_Leader__c where RecurringEventLeader__c in (:recurringLdr1.Id, :recurringLdr3.Id) 	
		];
		System.assertEquals(4, ldrList.size());

		ldrList = [
			select Id from Event_Leader__c where RecurringEventLeader__c = :recurringLdr2.Id 	
		];
		System.assert(ldrList.isEmpty());
		
		ldrList = [
			select Id from Event_Leader__c 
			where RecurringEventLeader__c = :recurringLdr1.Id
			and Leader_Name__c = :ldr1.Leader_Name__c 	
		];
		System.assertEquals(2, ldrList.size());
		
		Campaign campaignToUpdate = new Campaign(Id=camp1.Id, Status__c = 'Active');
		update campaignToUpdate;

		leadersToUpdate.clear();
		leadersToDelete.clear();
		ure = new UpdateRecurringEvents(camp1.Id, false, leadersToUpdate, leadersToDelete);
		ure.execute(null);
		
		Campaign recurringInstance = [
			select Id
			from Campaign
			where RecurringEvent__c = :recurringEvent.Id
			and Id != :camp1.Id
		];
		
		Event_Registration__c reg1 = new Event_Registration__c (
			Campaign__c = recurringInstance.Id,
			First_Name__c = 'FirstName',
			Last_Name__c = 'LastName',
			Email__c = 'FirstName.LastName@gmail.com' 
		);
		insert reg1;
		
		List<Campaign> campList = [
			select Id, Start_Date__c, Status__c
			from Campaign
		];
		
		campaignToUpdate = new Campaign(Id=camp1.Id, Status__c='Cancelled', Cancel_Reason__c='Test Reason' );
		update campaignToUpdate;
		
		ure = new UpdateRecurringEvents(camp1.Id, true, leadersToUpdate, leadersToDelete);
		ure.execute(null);
    }
}