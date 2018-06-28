@isTest
private class ClubEventCancellationEmailTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;

    static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    }

    static testMethod void myUnitTest() {
		Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
		List<Contact> contactList = new List<Contact>();
        Contact contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            Email = 'test1.contact1@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );
        contactList.add(contact1);  
		
        Contact contact2 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact2',
            Email = 'test2.contact2@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );  
		contactList.add(contact2);
		insert contactList;
		
		Club_Event__c event = new Club_Event__c(
			Event_Title__c = 'Test Event 1',
			Time_Begin__c = '8:00 AM',
			Date_Begin__c = System.today() + 1,
			Status__c = 'In Development',
			Event_Category__c = 'Outing',
			Sponsor_Description__c = 'Test',
			External_URL__c = 'http://test.com',
			Display_Method__c = 'External URL',
			Cancel_Reason__c = 'Too hot'
		);
		
		EventHelper.sourceObject = 'ClubEvent';
		insert event;
		
		List<Event_Registration__c> regList = new List<Event_Registration__c>();
		Event_Registration__c reg1 = new Event_Registration__c(
			Contact__c = contact1.Id,
			First_Name__c = contact1.FirstName,
			Last_Name__c = contact1.LastName,
			Email__c = contact1.Email
		);
		regList.add(reg1);
		
		Event_Registration__c reg2 = new Event_Registration__c(
			First_Name__c = contact2.FirstName,
			Last_Name__c = contact2.LastName,
			Email__c = contact2.Email
		);
		regList.add(reg2);
		
		insert regList;
		
		ClubEventCancellationEmail.send(event, regList);
    }
}