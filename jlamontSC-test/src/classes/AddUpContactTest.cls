@isTest
private class AddUpContactTest {
	static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    static testMethod void myUnitTest() {
		Account account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId
			);
		insert account1;
		
		List<Contact> contactList = new List<Contact>();
		Contact contact1 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact1',
				RecordTypeId = contactHouseholdTypeId,
				rC_Bios__Home_Email__c = 'test@abc.xyz',
				rC_Bios__Preferred_Email__c = 'Home'
			);
		contactList.add(contact1);
		
		Contact contact2 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact2',
				RecordTypeId = contactHouseholdTypeId,
				rC_Bios__Home_Email__c = 'test@abc.xyz',
				rC_Bios__Preferred_Email__c = 'Home'
			);
		contactList.add(contact2);

		Contact contact3 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact3',
				RecordTypeId = contactHouseholdTypeId,
				rC_Bios__Home_Email__c = 'test@abc.xyz',
				rC_Bios__Preferred_Email__c = 'Home'
			);
		contactList.add(contact3);

		insert contactList;
		
		List<kweos__EOCS_Data__c> actionList = new List<kweos__EOCS_Data__c>();
		kweos__EOCS_Data__c action1 = new kweos__EOCS_Data__c(
			kwac__Contact__c = contact3.Id
		);
		actionList.add(action1);
		
		kweos__EOCS_Data__c action2 = new kweos__EOCS_Data__c(
			kwac__Contact__c = contact3.Id
		);
		actionList.add(action2);
			
		kweos__EOCS_Data__c action3 = new kweos__EOCS_Data__c(
			kwac__Contact__c = contact1.Id
		);
		actionList.add(action3);

		insert actionList;
		
		RestResponse res = new RestResponse();
		RestRequest req = new RestRequest();
		
		req.requestURI = '/services/apexrest/AddUpContact';  
		req.httpMethod = 'POST';
		req.addHeader('Content-Type', 'application/json');
		String reqBody = '{"input" : [ {"email" : "test@abc.xyz", "addUpId" : "78657853"} ]}';
		AddUpContact.AddUpLookup lookup = new AddUpContact.AddUpLookup();
		lookup.email = 'test@abc.xyz';
		lookup.addUpId = '78657853';
		List<AddUpContact.AddUpLookup> testList = new List<AddUpContact.AddUpLookup>();
		testList.add(lookup);
		
		RestContext.request = req;
		RestContext.response = res;

		List<AddUpContact.AddUpLookup> results = AddUpContact.getEmail(testList);
		System.debug('results:' + results);
		
		Contact ctct = [select Website_System_Id__c from Contact where Id = :contact1.Id];
		System.assertEquals(3, results.size());
		System.assertEquals(contact3.Id, results[0].contactId);
		System.assertEquals(account1.Id, results[0].accountId);
		System.assertEquals(contact1.Id, results[1].contactId);
		System.assertEquals(contact2.Id, results[2].contactId);
		System.assertEquals('78657853', ctct.Website_System_Id__c);
    }
}