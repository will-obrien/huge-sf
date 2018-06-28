@isTest
private class EventsCampaignTriggerHandlerTest {
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();

    static testMethod void myUnitTest() {
    	ClubEventTriggerHandler.testing = true;
    	List<Club_Entity__c> entityList = new List<Club_Entity__c>();
    	Club_Entity__c ent1 = new Club_Entity__c(
    		EntityId__c = '0100',
    		Name = 'SF Bay Chapter'
    	);
    	entityList.add(ent1);
    	Club_Entity__c ent2 = new Club_Entity__c(
    		EntityId__c = 'CLUB',
    		Name = 'Sierra Club'
    	);
    	entityList.add(ent2);
    	insert entityList;
    	
    	Campaign evnt = new Campaign(
    		RecordTypeId = eventsTypeId,
    		Name = 'Testing',
    		Event_Name__c = 'Testing',
    		Status__c = 'In Development',
    		Events_Category__c = 'Outing',
    		Events_Type__c = 'Hike',
    		Start_Date__c = System.today(),
    		Start_Time__c = '8',
    		End_Time__c = '12',
    		Time_Zone__c = 'Local Time',
    		Summary_Description__c = 'Testing',
    		Display_Method__c = 'Salesforce Events Page',
    		Require_Field_1__c = true,
    		Require_Field_2__c = true,
    		Require_Field_3__c = true,
    		Require_Field_4__c = true,
    		Require_Field_5__c = true,
    		Require_Phone_Number__c = true,
    		Require_Zip_Code__c = true,
    		Require_Street_Address__c = true
    	);
    	Database.SaveResult rslt = Database.insert(evnt, false);
    	Set<String> errorSet = new Set<String>();
    	for(Database.Error err : rslt.getErrors()) {
    		System.debug('Error:' + err + '\r\n');
    		errorSet.add(err.getMessage());
    	}
    	System.Debug('errorSet: ' + errorSet);
    	System.assert(errorSet.contains('A Sponsor Description is Required if no Club Entity is chosen'));
    	System.assert(errorSet.contains('Start Time must be in format h:mm AM/PM'));
    	System.assert(errorSet.contains('End Time must be in format h:mm AM/PM'));
    	
    	evnt.Sponsor_Description__c = 'Test Sponsor';
    	evnt.Start_Time__c = ':';
    	evnt.End_Time__c = 'X:00 PM';
    	evnt.Status__c = 'Active';
    	rslt = Database.insert(evnt, false);
    	errorSet = new Set<String>();
    	for(Database.Error err : rslt.getErrors()) {
    		System.debug('Error:' + err + '\r\n');
    		errorSet.add(err.getMessage());
    	}
    	System.assert(errorSet.contains('To be made Active, an Event must have a Primary Leader'));
    	System.assert(errorSet.contains('Start Time must be in format h:mm AM/PM'));
    	System.assert(errorSet.contains('End Time must be in format h:mm AM/PM'));
    	
    	evnt.Start_Time__c = '8:00 AM';
    	evnt.End_Time__c = '4:00 PM';
    	evnt.End_Date__c = evnt.Start_Date__c - 1;
    	evnt.End_Time__c = null;
    	rslt = Database.insert(evnt, false);
    	errorSet = new Set<String>();
    	for(Database.Error err : rslt.getErrors()) {
    		System.debug('Error:' + err + '\r\n');
    		errorSet.add(err.getMessage());
    	}
    	System.assert(errorSet.contains('End Date cannot be before Start Date'));
    	System.assert(errorSet.contains('If an End Date is entered, an End Time is required'));
    	
    	evnt.Start_Time__c = '8:60';
    	evnt.End_Time__c = '14:00 PM';
    	rslt = Database.insert(evnt, false);
    	errorSet = new Set<String>();
    	for(Database.Error err : rslt.getErrors()) {
    		System.debug('Error:' + err + '\r\n');
    		errorSet.add(err.getMessage());
    	}
    	System.assert(errorSet.contains('Start Time must be in format h:mm AM/PM'));
    	System.assert(errorSet.contains('End Time must be in format h:mm AM/PM'));
    	
    	evnt.Start_Time__c = '8:xx AM';
    	evnt.End_Time__c = '11:70 PM';
    	rslt = Database.insert(evnt, false);
    	errorSet = new Set<String>();
    	for(Database.Error err : rslt.getErrors()) {
    		System.debug('Error:' + err + '\r\n');
    		errorSet.add(err.getMessage());
    	}
    	System.assert(errorSet.contains('Start Time must be in format h:mm AM/PM'));
    	System.assert(errorSet.contains('End Time must be in format h:mm AM/PM'));
    	
    	
    	evnt.Start_Time__c = '8:00 XX';
    	evnt.End_Time__c = '2:00 PM';
    	rslt = Database.insert(evnt, false);
    	errorSet = new Set<String>();
    	for(Database.Error err : rslt.getErrors()) {
    		System.debug('Error:' + err + '\r\n');
    		errorSet.add(err.getMessage());
    	}
    	System.assert(errorSet.contains('Start Time must be in format h:mm AM/PM'));
    	    	
    	evnt.End_Date__c = evnt.Start_Date__c + 1;
    	evnt.Start_Time__c = '8:00 AM';
    	evnt.Status__c = 'In Development';
    	evnt.Club_Entity__c = null;
    	evnt.Sponsor_Description__c = 'Test Sponsor Description';
    	evnt.Custom_Field_5_Label__c = 'Test Label 5';
    	evnt.Display_Field_5__c = false;
    	evnt.Require_Field_5__c = false;

    	insert evnt;
    	
    	Campaign test = [select Club_Entity__c from Campaign where Id = :evnt.Id];
    	System.assertEquals(ent2.Id, test.Club_Entity__c);
    	
    	evnt.Display_Method__c = 'External URL';
    	rslt = Database.update(evnt, false);
    	errorSet = new Set<String>();
    	for(Database.Error err : rslt.getErrors()) {
    		System.debug('Error:' + err + '\r\n');
    		errorSet.add(err.getMessage());
    	}
    	System.assert(errorSet.contains('An External URL is required if Display Method is not \"Salesforce Events Page\"'));
    	
    	Event_Leader__c ldr = new Event_Leader__c(
    		Campaign__c = evnt.Id,
    		Leader_Name__c = 'Test Leader',
    		Phone_or_Other_Contact_Information__c = 'test@gmail.com'
    	);
    	insert ldr;
    	
    	evnt.URL_to_Share__c = '';
    	Database.update(evnt, false);
    	
    	evnt.External_URL__c = 'http://www.sierraclub.org';
    	evnt.Display_Method__c = '';
    	Database.update(evnt, false);
    	
    	evnt.Status__c = 'Cancelled';
    	Database.update(evnt, false);
    	
    	List<Event_Leader__c> ldrList = [
    		select Id from Event_Leader__c where Id = :ldr.Id
    	];
    	System.assertEquals(1, ldrList.size());
    	
    	delete evnt;
    	
    	ldrList = [
    		select Id from Event_Leader__c where Id = :ldr.Id
    	];
    	System.assertEquals(0, ldrList.size());
    }
}