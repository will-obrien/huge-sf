/*********************************************************************************************************
Name			: ContactTriggerHandler
Created By		: KapiL Choudhary(Jaipur D.C.)
Created Date	: March 18, 2014
Description		: Test Class for contact trigger.
Updated			: 2014/04/04 VB:  Removed ContactTriggerTest and copied defaultCampaignTest() method here
				: 2015/08/05 VB:  
***********************************************************************************************************/
@isTest
private class ContactTriggerHandlerTest {

    static testMethod void defaultCampaignTest() {
    	TestDataUtility tDu = new TestDataUtility();
    	Campaign camp = new Campaign (Name='Z17Z567890');
    	OriginalCampaignName__c oCampName = new OriginalCampaignName__c(name = camp.Name);
    	insert oCampName;
    	
    	contact con = tDu.createNewContact(true, 'FirstName', 'LastName', null, null);
    	list<contact> conList = [select Original_Campaign__c from contact where id=:con.id];
    	// original campaign is set.
    	system.assertEquals(conList[0].Original_Campaign__c, camp.id);
    }

	//
	// Tests for Contact Address Updates
	//
	static Id accountHouseholdTypeId;
	static Id contactHouseholdTypeId;

	static {
		accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	}
	
    static testMethod void myUnitTest() {
    	
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
        
        // Confirm the Address exists
        //rC_Bios__Account_Address__c addr1 = [select Id, rC_Bios__Original_Street_Line_1__c, CastIron_Integration_Status__c from rC_Bios__Account_Address__c where Id=:addr1.Id];
        //System.assertEquals('Success', addr1.CastIron_Integration_Status__c);

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
				
		Contact contact2 =
			new Contact(
				AccountId = account1.Id,
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
		
	}
	
}