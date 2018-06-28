/*********************************************************************************************************
Name			: ContactBeforeUpdateHandlerTest
Created By		: Vernon Baas
Created Date	: April 13, 2016
Description		: Test Class for contact before update trigger.  Tests update of addresses when moving
				: 		Contact to new Account.
Updated			: 2016/04/13 VB:  Created.
***********************************************************************************************************/
@isTest
private class ContactBeforeUpdateHandlerTest {

	//
	// Tests for Contact Address Updates
	//
	static Id accountHouseholdTypeId;
	static Id contactHouseholdTypeId;

	static {
		accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	}
	
    static testMethod void myUnitTestOne() {
    	
		Account account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId
			);
		Account account2 = 
			new Account(
				Name='Account2',
				RecordTypeId = accountHouseholdTypeId
			);
		List<Account> accountList = new List<Account>();
		accountList.add(account1);
		accountList.add(account2);
		insert accountList;

		// Now insert an address for the Account
		rC_Bios__Account_Address__c addr1 = new  rC_Bios__Account_Address__c(
			rC_Bios__Account__c = account1.Id,
			rC_Bios__Type__c = 'Home',
			rC_Bios__Original_Street_Line_1__c 	= '1149 Dartmouth St',
			rC_Bios__Original_City__c 			= 'Albany',
			rC_Bios__Original_State__c 			= 'CA',
			rC_Bios__Original_Postal_Code__c 	= '94706' 
		);
        //System.debug('Inserting addr1');
		insert addr1;
        
		// Pull the Address Values from the Account
		Account testAccount = [SELECT 	Id,
										Name, 
										BillingStreet,
										BillingCity,
										BillingState,
										BillingPostalCode,
										BillingCountry,
										ShippingStreet,
										ShippingCity,
										ShippingState,
										ShippingPostalCode,
										ShippingCountry
									FROM Account
									WHERE Id =:account1.Id];
									
        System.assertEquals('1149 Dartmouth St', 	testAccount.BillingStreet);
        System.assertEquals('Albany', 				testAccount.BillingCity);
        System.assertEquals('CA', 					testAccount.BillingState);
        System.assertEquals('94706', 				testAccount.BillingPostalCode);
        //System.assertEquals(null, 					testAccount.BillingCountry);
        System.assert(String.isBlank(testAccount.BillingCountry));

        System.assertEquals('1149 Dartmouth St', 	testAccount.ShippingStreet);
        System.assertEquals('Albany', 				testAccount.ShippingCity);
        System.assertEquals('CA', 					testAccount.ShippingState);
        System.assertEquals('94706', 				testAccount.ShippingPostalCode);
        //System.assertEquals(null, 					testAccount.ShippingCountry);
        System.assert(String.isBlank(testAccount.ShippingCountry));
		
		// Now insert a Contact and confirm the address is correct.
		// Insert Contact 1 under Account 1 ( w/ Address )				
		Contact contact1 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact1',
				rC_Bios__Preferred_Email__c = 'Home',
				rC_Bios__Home_Email__c = 'testcontact1x@abc.com',
				RecordTypeId = contactHouseholdTypeId
			);
		insert contact1;
			
		// Pull the Address Values from the Contact
		Contact testContact1 = [SELECT 	Id,
										Name, 
										MailingStreet,
										MailingCity,
										MailingState,
										MailingPostalCode,
										MailingCountry,
										OtherStreet,
										OtherCity,
										OtherState,
										OtherPostalCode,
										OtherCountry
									FROM Contact
									WHERE Id =:contact1.Id];

        System.assertEquals('1149 Dartmouth St', 	testContact1.MailingStreet);
        System.assertEquals('Albany', 				testContact1.MailingCity);
        System.assertEquals('CA', 					testContact1.MailingState);
        System.assertEquals('94706', 				testContact1.MailingPostalCode);
        System.assertEquals(null, 					testContact1.MailingCountry);
        System.assert(String.isBlank(testContact1.MailingCountry));

        System.assertEquals('1149 Dartmouth St', 	testContact1.OtherStreet);
        System.assertEquals('Albany', 				testContact1.OtherCity);
        System.assertEquals('CA', 					testContact1.OtherState);
        System.assertEquals('94706', 				testContact1.OtherPostalCode);
        System.assertEquals(null, 					testContact1.OtherCountry);
        System.assert(String.isBlank(testContact1.OtherCountry));

		// Insert Contact 2 under Account 2 ( w/o Address )				
		Contact contact2 =
			new Contact(
				AccountId = account2.Id,
				FirstName = 'Test',
				LastName = 'Contact2',
				rC_Bios__Preferred_Email__c = 'Home',
				rC_Bios__Home_Email__c = 'testcontact2x@abc.com',
				RecordTypeId = contactHouseholdTypeId
			);
		insert contact2;

		// Pull the Address Values from the Contact
		Contact testContact2 = [SELECT 	Id,
										Name, 
										MailingStreet,
										MailingCity,
										MailingState,
										MailingPostalCode,
										MailingCountry,
										OtherStreet,
										OtherCity,
										OtherState,
										OtherPostalCode,
										OtherCountry
									FROM Contact
									WHERE Id =:contact2.Id];
		// Confirm the Address is blank
        System.assert(String.isBlank(testContact2.MailingStreet));
        System.assert(String.isBlank(testContact2.MailingCity));
        System.assert(String.isBlank(testContact2.MailingState));
        System.assert(String.isBlank(testContact2.MailingPostalCode));
        System.assertEquals(null, 	 testContact2.MailingCountry);
        System.assert(String.isBlank(testContact2.MailingCountry));

        System.assert(String.isBlank(testContact2.OtherStreet));
        System.assert(String.isBlank(testContact2.OtherCity));
        System.assert(String.isBlank(testContact2.OtherState));
        System.assert(String.isBlank(testContact2.OtherPostalCode));
        System.assertEquals(null,	 testContact2.OtherCountry);
        System.assert(String.isBlank(testContact2.OtherCountry));

		Test.startTest();

		// Now Move Contact 1 to Account 2
		testContact1.AccountId = account2.Id;
        
        System.debug(':: TestStart ::');
		update testContact1;

		// Pull the Address Values from the Contact
		testContact1 = [SELECT 	Id,
										AccountId,
										Name, 
										MailingStreet,
										MailingCity,
										MailingState,
										MailingPostalCode,
										MailingCountry,
										OtherStreet,
										OtherCity,
										OtherState,
										OtherPostalCode,
										OtherCountry
									FROM Contact
									WHERE Id =:contact1.Id];

		// Has it been moved?
        System.assertEquals(account2.Id, 	testContact1.AccountId);

		// Confirm Contact 2's Address is blank
        //System.assertEquals('Stompyland', 	testContact1.MailingStreet);
        
        System.assert(String.isBlank(testContact1.MailingStreet));
        System.assert(String.isBlank(testContact1.MailingCity));
        System.assert(String.isBlank(testContact1.MailingState));
        System.assert(String.isBlank(testContact1.MailingPostalCode));
        System.assertEquals(null, 	 testContact1.MailingCountry);
        System.assert(String.isBlank(testContact1.MailingCountry));

        System.assert(String.isBlank(testContact1.OtherStreet));
        System.assert(String.isBlank(testContact1.OtherCity));
        System.assert(String.isBlank(testContact1.OtherState));
        System.assert(String.isBlank(testContact1.OtherPostalCode));
        System.assertEquals(null,	 testContact1.OtherCountry);
        System.assert(String.isBlank(testContact1.OtherCountry));
		

		// Now Move Contact 2 to Account 1
		testContact2.AccountId = account1.Id;
		update testContact2;

		// Pull the Address Values from the Contact
		testContact2 = [SELECT 	Id,
										Name, 
										MailingStreet,
										MailingCity,
										MailingState,
										MailingPostalCode,
										MailingCountry,
										OtherStreet,
										OtherCity,
										OtherState,
										OtherPostalCode,
										OtherCountry
									FROM Contact
									WHERE Id =:contact2.Id];


		// Confirm Contact 2's Address is now populated
        System.assertEquals('1149 Dartmouth St', 	testContact2.MailingStreet);
        System.assertEquals('Albany', 				testContact2.MailingCity);
        System.assertEquals('CA', 					testContact2.MailingState);
        System.assertEquals('94706', 				testContact2.MailingPostalCode);
        System.assertEquals(null, 					testContact2.MailingCountry);
        System.assert(String.isBlank(testContact2.MailingCountry));
        System.assertEquals('1149 Dartmouth St', 	testContact2.OtherStreet);
        System.assertEquals('Albany', 				testContact2.OtherCity);
        System.assertEquals('CA', 					testContact2.OtherState);
        System.assertEquals('94706', 				testContact2.OtherPostalCode);
        System.assertEquals(null, 					testContact2.OtherCountry);
        System.assert(String.isBlank(testContact2.OtherCountry));

		Test.stopTest();
		
	}

    static testMethod void myUnitTestTwo() {
    	
		Account account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId
			);
		Account account2 = 
			new Account(
				Name='Account2',
				RecordTypeId = accountHouseholdTypeId
			);
		List<Account> accountList = new List<Account>();
		accountList.add(account1);
		accountList.add(account2);
		insert accountList;

		// Now insert an address for the Account
		rC_Bios__Account_Address__c addr1 = new  rC_Bios__Account_Address__c(
			rC_Bios__Account__c = account1.Id,
			rC_Bios__Type__c = 'Home',
			rC_Bios__Original_Street_Line_1__c 	= '1149 Dartmouth St',
			rC_Bios__Original_City__c 			= 'Albany',
			rC_Bios__Original_State__c 			= 'CA',
			rC_Bios__Original_Postal_Code__c 	= '94706' 
		);
        //System.debug('Inserting addr1');
		insert addr1;
        
		// Pull the Address Values from the Account
		Account testAccount = [SELECT 	Id,
										Name, 
										BillingStreet,
										BillingCity,
										BillingState,
										BillingPostalCode,
										BillingCountry,
										ShippingStreet,
										ShippingCity,
										ShippingState,
										ShippingPostalCode,
										ShippingCountry
									FROM Account
									WHERE Id =:account1.Id];
									
        System.assertEquals('1149 Dartmouth St', 	testAccount.BillingStreet);
        System.assertEquals('Albany', 				testAccount.BillingCity);
        System.assertEquals('CA', 					testAccount.BillingState);
        System.assertEquals('94706', 				testAccount.BillingPostalCode);
        //System.assertEquals(null, 					testAccount.BillingCountry);
        System.assert(String.isBlank(testAccount.BillingCountry));

        System.assertEquals('1149 Dartmouth St', 	testAccount.ShippingStreet);
        System.assertEquals('Albany', 				testAccount.ShippingCity);
        System.assertEquals('CA', 					testAccount.ShippingState);
        System.assertEquals('94706', 				testAccount.ShippingPostalCode);
        //System.assertEquals(null, 					testAccount.ShippingCountry);
        System.assert(String.isBlank(testAccount.ShippingCountry));
		
		// Now insert a Contact and confirm the address is correct.
		// Insert Contact 1 under Account 1 ( w/ Address )				
		Contact contact1 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact1',
				rC_Bios__Preferred_Email__c = 'Home',
				rC_Bios__Home_Email__c = 'testcontact1x@abc.com',
				RecordTypeId = contactHouseholdTypeId
			);
		insert contact1;
			
		// Pull the Address Values from the Contact
		Contact testContact1 = [SELECT 	Id,
										Name, 
										MailingStreet,
										MailingCity,
										MailingState,
										MailingPostalCode,
										MailingCountry,
										OtherStreet,
										OtherCity,
										OtherState,
										OtherPostalCode,
										OtherCountry
									FROM Contact
									WHERE Id =:contact1.Id];

        System.assertEquals('1149 Dartmouth St', 	testContact1.MailingStreet);
        System.assertEquals('Albany', 				testContact1.MailingCity);
        System.assertEquals('CA', 					testContact1.MailingState);
        System.assertEquals('94706', 				testContact1.MailingPostalCode);
        System.assertEquals(null, 					testContact1.MailingCountry);
        System.assert(String.isBlank(testContact1.MailingCountry));

        System.assertEquals('1149 Dartmouth St', 	testContact1.OtherStreet);
        System.assertEquals('Albany', 				testContact1.OtherCity);
        System.assertEquals('CA', 					testContact1.OtherState);
        System.assertEquals('94706', 				testContact1.OtherPostalCode);
        System.assertEquals(null, 					testContact1.OtherCountry);
        System.assert(String.isBlank(testContact1.OtherCountry));

		// Insert Contact 2 under Account 2 ( w/o Address )				
		Contact contact2 =
			new Contact(
				AccountId = account2.Id,
				FirstName = 'Test',
				LastName = 'Contact2',
				rC_Bios__Preferred_Email__c = 'Home',
				rC_Bios__Home_Email__c = 'testcontact2x@abc.com',
				RecordTypeId = contactHouseholdTypeId
			);
		insert contact2;

		// Pull the Address Values from the Contact
		Contact testContact2 = [SELECT 	Id,
										Name, 
										MailingStreet,
										MailingCity,
										MailingState,
										MailingPostalCode,
										MailingCountry,
										OtherStreet,
										OtherCity,
										OtherState,
										OtherPostalCode,
										OtherCountry
									FROM Contact
									WHERE Id =:contact2.Id];
		// Confirm the Address is blank
        System.assert(String.isBlank(testContact2.MailingStreet));
        System.assert(String.isBlank(testContact2.MailingCity));
        System.assert(String.isBlank(testContact2.MailingState));
        System.assert(String.isBlank(testContact2.MailingPostalCode));
        System.assertEquals(null, 	 testContact2.MailingCountry);
        System.assert(String.isBlank(testContact2.MailingCountry));

        System.assert(String.isBlank(testContact2.OtherStreet));
        System.assert(String.isBlank(testContact2.OtherCity));
        System.assert(String.isBlank(testContact2.OtherState));
        System.assert(String.isBlank(testContact2.OtherPostalCode));
        System.assertEquals(null,	 testContact2.OtherCountry);
        System.assert(String.isBlank(testContact2.OtherCountry));

		Test.startTest();

		// Now Move Contact 1 to Account 2
		testContact1.AccountId = account2.Id;
		update testContact1;

		// Pull the Address Values from the Contact
		testContact1 = [SELECT 	Id,
										AccountId,
										Name, 
										MailingStreet,
										MailingCity,
										MailingState,
										MailingPostalCode,
										MailingCountry,
										OtherStreet,
										OtherCity,
										OtherState,
										OtherPostalCode,
										OtherCountry
									FROM Contact
									WHERE Id =:contact1.Id];

		// Confirm Contact 2's Address is blank
        System.assert(String.isBlank(testContact1.MailingStreet));
        System.assert(String.isBlank(testContact1.MailingCity));
        System.assert(String.isBlank(testContact1.MailingState));
        System.assert(String.isBlank(testContact1.MailingPostalCode));
        System.assertEquals(null, 	 testContact1.MailingCountry);
        System.assert(String.isBlank(testContact1.MailingCountry));

        System.assert(String.isBlank(testContact1.OtherStreet));
        System.assert(String.isBlank(testContact1.OtherCity));
        System.assert(String.isBlank(testContact1.OtherState));
        System.assert(String.isBlank(testContact1.OtherPostalCode));
        System.assertEquals(null,	 testContact1.OtherCountry);
        System.assert(String.isBlank(testContact1.OtherCountry));
		

		// Now Move Contact 2 to Account 1
		testContact2.AccountId = account1.Id;
		update testContact2;

		// Pull the Address Values from the Contact
		testContact2 = [SELECT 	Id,
										Name, 
										MailingStreet,
										MailingCity,
										MailingState,
										MailingPostalCode,
										MailingCountry,
										OtherStreet,
										OtherCity,
										OtherState,
										OtherPostalCode,
										OtherCountry
									FROM Contact
									WHERE Id =:contact2.Id];

		// Confirm Contact 2's Address is now populated
        System.assertEquals('1149 Dartmouth St', 	testContact2.MailingStreet);
        System.assertEquals('Albany', 				testContact2.MailingCity);
        System.assertEquals('CA', 					testContact2.MailingState);
        System.assertEquals('94706', 				testContact2.MailingPostalCode);
        System.assertEquals(null, 					testContact2.MailingCountry);
        System.assert(String.isBlank(testContact2.MailingCountry));
        System.assertEquals('1149 Dartmouth St', 	testContact2.OtherStreet);
        System.assertEquals('Albany', 				testContact2.OtherCity);
        System.assertEquals('CA', 					testContact2.OtherState);
        System.assertEquals('94706', 				testContact2.OtherPostalCode);
        System.assertEquals(null, 					testContact2.OtherCountry);
        System.assert(String.isBlank(testContact2.OtherCountry));

		Test.stopTest();
		
	}

}