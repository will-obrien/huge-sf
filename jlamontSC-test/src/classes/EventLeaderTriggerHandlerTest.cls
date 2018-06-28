@isTest
private class EventLeaderTriggerHandlerTest {
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();

    static testMethod void myUnitTest() {
    	ClubEventTriggerHandler.testing = true;
    	
    	Club_Entity__c ent = new Club_Entity__c(
    		EntityId__c = '0100',
    		Name = 'SF Bay Chapter'
    	);
    	insert ent;

		EventHelper.sourceObject = 'ClubEvent';

    	Campaign evnt = new Campaign(
    		RecordTypeId = eventsTypeId,
    		Name = 'Testing',
    		Event_Name__c = 'Testing',
    		Status__c = 'In Development',
    		Events_Category__c = 'Outing',
    		Events_Type__c = 'Hike',
    		Start_Date__c = System.today(),
    		Start_Time__c = '8:00 AM',
    		Time_Zone__c = 'Local Time',
    		Club_Entity__c = ent.Id,
    		Summary_Description__c = 'Testing',
    		Display_Method__c = 'Salesforce Events Page'
    	);
    	insert evnt;

		Event_Leader__c leader1 = new Event_Leader__c(
			Campaign__c = evnt.Id,
			Email__c = 'test1@abc.xyz',
			Is_Primary_Leader__c = true,
			Leader_Name__c = 'test leader1'
		);
		insert leader1;
		
		EventLeaderTriggerHandler.leadersChecked = false;
		
		evnt.Status__c = 'Active';
		update evnt;
		
		List<Event_Leader__c> ldrList = new List<Event_Leader__c>();
		Event_Leader__c leader2 = new Event_Leader__c(
			Campaign__c = evnt.Id,
			Email__c = 'test2@abc.xyz',
			Is_Primary_Leader__c = true,
			Leader_Name__c = 'test leader2'
		);
		Event_Leader__c leader3 = new Event_Leader__c(
			Campaign__c = evnt.Id,
			Email__c = 'test3@abc.xyz',
			Is_Primary_Leader__c = false,
			Leader_Name__c = 'test leader3'
		);
		ldrList.add(leader2);
		ldrList.add(leader3);
		insert ldrList;
		
		EventLeaderTriggerHandler.leadersChecked = false;
		
		EventHelper.sourceObject = 'Campaign';
		leader2.Is_Primary_Leader__c = false;
		try {
			update leader2;
			throw new MyException('An exception should have been thrown');
		}
		catch(Exception e) {
			System.assert(e.getMessage().contains('An Active Event Must have a Primary Leader'));
		}
		
		EventLeaderTriggerHandler.leadersChecked = false;
		try {
			delete leader2;
			throw new MyException('An exception should have been thrown');
		}
		catch(Exception e) {
			System.assert(e.getMessage().contains('An Active Event Must have a Primary Leader'));
		}
    }
    public class MyException extends Exception {
    	
    }
}