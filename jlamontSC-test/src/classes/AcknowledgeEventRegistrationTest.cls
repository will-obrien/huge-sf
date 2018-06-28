@isTest
private class AcknowledgeEventRegistrationTest {
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();

    static testMethod void myUnitTest() {
    	ClubEventTriggerHandler.testing = true;
    	
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
    		Summary_Description__c = 'Testing',
    		Sponsor_Description__c = 'Test Sponsor',
    		Custom_Field_1_Label__c = '',
    		Custom_Field_2_Label__c = '',
    		Custom_Field_3_Label__c = '',
    		Custom_Field_4_Label__c = '',
    		Custom_Field_5_Label__c = '',
    		Autoresponder_Text__c = '',
    		Send_RSVP_to_Leader__c = true,
			Autoresponder_Type__c = 'SierraRise'
		);
    	insert evnt;
    	
    	Event_Leader__c ldr = new Event_Leader__c(
    		Campaign__c = evnt.Id,
    		Email__c = 'test@test.com',
    		Is_Primary_Leader__c = true,
    		Leader_Name__c = 'test leader',
    		Phone_or_Other_Contact_Information__c = '222-333-4444'
    	);
    	insert ldr;
    	
    	Event_Registration__c reg = new Event_Registration__c(
    		Campaign__c = evnt.Id,
    		First_Name__c = 'Test',
    		Last_Name__c = 'Tester',
    		Email__c = 'mark.maslow@sierraclub.org',
    		Phone__c = '',
    		Mobile_Phone__c = '',
    		Street__c = '',
    		City__c = '',
    		State__c = '',
    		PostalCode__c = '',
    		Custom_Field_1_Response__c = '',
    		Custom_Field_2_Response__c = '',
    		Custom_Field_3_Response__c = '',
    		Custom_Field_4_Response__c = '',
    		Custom_Field_5_Response__c = ''
    	);
    	insert reg;
    	
    	
    	
    	AcknowledgeEventRegistration.acknowledge(evnt, reg, ldr);
    }
}