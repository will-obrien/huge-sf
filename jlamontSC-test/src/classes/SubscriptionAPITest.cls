@isTest
private class SubscriptionAPITest {
	static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    static testMethod void myUnitTest() {
    	//Create account and contacts
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
				rC_Bios__Home_Email__c = 'test1@abc.xyz',
				rC_Bios__Preferred_Email__c = 'Home'
			);
		contactList.add(contact1);
		Contact contact2 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact2',
				RecordTypeId = contactHouseholdTypeId,
				rC_Bios__Home_Email__c = 'test1@abc.xyz',
				rC_Bios__Preferred_Email__c = 'Home'
			);
		contactList.add(contact2);
		Contact contact3 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact3',
				RecordTypeId = contactHouseholdTypeId,
				rC_Bios__Home_Email__c = 'test3@abc.xyz',
				rC_Bios__Preferred_Email__c = 'Home'
			);
		contactList.add(contact3);
		Contact contact4 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact4',
				RecordTypeId = contactHouseholdTypeId,
				rC_Bios__Home_Email__c = 'test4@abc.xyz',
				rC_Bios__Preferred_Email__c = 'Home'
			);
		contactList.add(contact4);
		Contact contact5 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact5',
				RecordTypeId = contactHouseholdTypeId,
				rC_Bios__Home_Email__c = 'test5@abc.xyz',
				rC_Bios__Preferred_Email__c = 'Home'
			);
		contactList.add(contact5);
		
        System.debug('Inserting contactList');
		insert contactList;
		
        /*
		List<Contact> contList = [
			select Id, FirstName, LastName, Email
			from Contact
		];
		for(Contact cont : contList) {
			System.debug('Contact added to test:' + cont);
		}
		*/
		
		Campaign camp = new Campaign(Name='Test Campaign');
        System.debug('Inserting campaign');
		insert camp;
		
		//Create Preference Codes
		List<rC_Bios__Preference_Code__c> prefCodeList = new List<rC_Bios__Preference_Code__c>();

		rC_Bios__Preference_Code__c prefCode1 = new rC_Bios__Preference_Code__c(
			rC_Bios__Code_Value__c = 'TestPreference',
			rC_Bios__Category__c = 'CAT1',
			rC_Bios__Subcategory__c = 'SUB1'
		);
		prefCodeList.add(prefCode1);
		
		rC_Bios__Preference_Code__c prefCode2 = new rC_Bios__Preference_Code__c(
			rC_Bios__Code_Value__c = 'NOEMAIL',
			rC_Bios__Category__c = 'CAT2',
			rC_Bios__Subcategory__c = 'SUB2'
		);
		prefCodeList.add(prefCode2);
		
		rC_Bios__Preference_Code__c prefCode3 = new rC_Bios__Preference_Code__c(
			rC_Bios__Code_Value__c = 'NOINSIDER',
			rC_Bios__Category__c = 'CAT3',
			rC_Bios__Subcategory__c = 'SUB3'
		);
		prefCodeList.add(prefCode3);

        System.debug('Inserting Preference Codes');
		insert prefCodeList;
		
		List<rC_Bios__Preference_Code__c> testCodeList = [
			select Id, rC_Bios__Code_Value__c
			from rC_Bios__Preference_Code__c
		];
		for(rC_Bios__Preference_Code__c prefCode : testCodeList) {
			System.debug('Preference Code added:' + prefCode);
		}
		
		//Create Preferences for Contacts
		List<rC_Bios__Preference__c> prefList = new List<rC_Bios__Preference__c>();
		
		rC_Bios__Preference__c pref1 = new rC_Bios__Preference__c(
			rC_Bios__Contact__c = contact1.Id,
			rC_Bios__Code_Value__c = 'NOEMAIL'
		);
		prefList.add(pref1);
		rC_Bios__Preference__c pref2 = new rC_Bios__Preference__c(
			rC_Bios__Contact__c = contact2.Id,
			rC_Bios__Code_Value__c = 'TestPreference'
		);
		prefList.add(pref2);
		rC_Bios__Preference__c pref3 = new rC_Bios__Preference__c(
			rC_Bios__Contact__c = contact4.Id,
			rC_Bios__Code_Value__c = 'TestPreference',
			rC_Bios__Active__c = false
		);
		prefList.add(pref3);
		rC_Bios__Preference__c pref4 = new rC_Bios__Preference__c(
			rC_Bios__Contact__c = contact5.Id,
			rC_Bios__Code_Value__c = 'NOINSIDER',
			rC_Bios__Active__c = true
		);
		prefList.add(pref4);
		
        System.debug('Inserting Preferences');
		insert prefList;
		
		List<rC_Bios__Preference__c> testList = [
			select rC_Bios__Contact__c, rC_Bios__Code_Value__c
			from rC_Bios__Preference__c
		];
		for(rC_Bios__Preference__c testPref : testList) {
			System.debug('Preference added:' + testPref);
		}

		RestRequest req = new RestRequest(); 
	    RestResponse res = new RestResponse();
	
        Test.startTest();
		String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
	    req.requestURI = baseUrl + '/services/apexrest/SubscriptionAPI';
	    req.httpMethod = 'POST';
	    RestContext.request = req;
	    RestContext.response = res;
		SubscriptionAPI.SubscriptionRequest sub = new SubscriptionAPI.SubscriptionRequest();
		sub.email = 'test1@abc.xyz';
		sub.preferenceCode = 'TestPreference';
        System.debug('Call 1');
	    SubscriptionAPI.SubscriptionResponse response = SubscriptionAPI.subscribe(sub);
	    
	    System.assertEquals(true, response.success);
	    System.assertEquals(1, response.numberNewlySubscribed);
	    prefList = [
			select rC_Bios__Contact__c, rC_Bios__Code_Value__c, rC_Bios__Active__c
			from rC_Bios__Preference__c
			where rC_Bios__Active__c = true
	    ];
	    System.assertEquals(3, prefList.size());
	    
	    for(rC_Bios__Preference__c pref : prefList) {
	    	if(pref.rC_Bios__Contact__c == contact1.Id) {
			    System.assertEquals('TestPreference', pref.rC_Bios__Code_Value__c);
	    	}
	    	else if(pref.rC_Bios__Contact__c == contact2.Id) {
			    System.assertEquals('TestPreference', pref.rC_Bios__Code_Value__c);
	    	}
	    }
	    System.assertEquals(1, response.numberAlreadySubscribed);
	    System.assertEquals(1, response.numberNewlySubscribed);
	    
	    sub.email = 'test3@abc.xyz';
	    sub.preferenceCode = 'TestPreference';
        System.debug('Call 2');
	    response = SubscriptionAPI.subscribe(sub);
	    
	    System.assertEquals(1, response.numberNewlySubscribed);
	    
	    sub.email = 'test4@abc.xyz';
	    sub.preferenceCode = 'TestPreference';
        System.debug('Call 3');
	    response = SubscriptionAPI.subscribe(sub);
	    
	    System.assertEquals(1, response.numberReactivated);

	    sub.email = 'newcontact1@abc.xyz';
	    sub.preferenceCode = 'TestPreference';
	    sub.firstName = 'Test';
	    sub.lastName = 'Preference';
	    sub.mobilePhone = '3334445555';
	    sub.source = 'junk';
        System.debug('Call 4');
	    response = SubscriptionAPI.subscribe(sub);
	    
	    System.assertEquals(true, response.isNewEmail);
	    List<rC_Connect__Batch_Upload__c> batchList = [
	    	select Id from rC_Connect__Batch_Upload__c
	    ];
	    System.assertEquals(1, batchList.size());
	    
	    sub.email = 'junk';
	    sub.preferenceCode = 'TestPreference';
        System.debug('Call 5');
	    response = SubscriptionAPI.subscribe(sub);
	    System.debug('Error Message:' + response.errorMessage);
	    System.assertEquals(false, response.success);
	    
	    sub.email = '';
        System.debug('Call 6');
	    response = SubscriptionAPI.subscribe(sub);
	    System.debug('Error Message:' + response.errorMessage);
	    System.assertEquals(false, response.success);
	    System.assertEquals('Email Address is Required', response.errorMessage);
	    
	    sub.email = 'testXX@abc.xyz';
	    sub.preferenceCode = '';
        System.debug('Call 7');
	    response = SubscriptionAPI.subscribe(sub);
	    System.debug('Error Message:' + response.errorMessage);
	    System.assertEquals(false, response.success);
	    System.assertEquals('preferenceCode is Required', response.errorMessage);
	    
	    sub.preferenceCode = 'junk';
        System.debug('Call 8');
	    response = SubscriptionAPI.subscribe(sub);
	    System.debug('Error Message:' + response.errorMessage);
	    System.assertEquals(false, response.success);
	    System.assertEquals('"junk" is Not a Valid Preference Code', response.errorMessage);
	    
	    sub.preferenceCode = 'TestPreference';
	    sub.source = null;
        System.debug('Call 9');
	    response = SubscriptionAPI.subscribe(sub);
	    System.debug('Error Message:' + response.errorMessage);
	    System.assertEquals(true, response.success);
	    
	    sub.source = camp.Id;
        System.debug('Call 10');
	    response = SubscriptionAPI.subscribe(sub);
	    System.debug('Error Message:' + response.errorMessage);
	    System.assertEquals(true, response.success);

        Test.stopTest();

	    sub.preferenceCode = 'INSIDER';
	    sub.email = 'test5@abc.xyz';
        System.debug('Call 11');
	    response = SubscriptionAPI.subscribe(sub);
	    System.debug('Error Message:' + response.errorMessage);
	    System.assertEquals(true, response.success);
	    List<rC_Bios__Preference__c> testPrefList = 
	    	[select Id from rC_Bios__Preference__c where 
	    		rC_Bios__Contact__c = :contact5.Id and
	    		rC_Bios__Code_Value__c = 'NOINSIDER' and
	    		rC_Bios__Active__c = true 
	    	];
	    System.assertEquals(0, testPrefList.size());
	    
	    sub.email = 'test6@xyz.abc';
	    sub.firstName = '';
	    sub.lastName = '';
        System.debug('Call 12');
	    response = SubscriptionAPI.subscribe(sub);
	    System.debug('Error Message:' + response.errorMessage);
	    System.assertEquals(true, response.success);

    }
}