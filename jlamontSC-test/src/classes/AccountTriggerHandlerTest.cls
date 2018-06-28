/*********************************************************************************************************
Name			: AccountTriggerHandlerTest
Created By		: Vernon Baas
Created Date	: May 24, 2017
Description		: Handler for AccountTriggerHandler ( at least part of it )
Updated			: 2017/06/12 VB: Added tests for No Local Mail / No Local Phone
***********************************************************************************************************/
@isTest
public with sharing class AccountTriggerHandlerTest {


	/**************************************************************************************************************************
 	*	No Phone tests
 	**************************************************************************************************************************/

	// Create an Account & Contact, add a No Phone preference 
	//	then deactivate the preference
    static testMethod void myUnitTestNoPhoneOne() {

		TestrCSettingUtility.createrCSettings();

    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	//rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        //setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        //insert setting; 

		
		// Create an Account    	
		Account A1 = new Account(Name='AccountA');
		insert A1;
		
		// Create a Contact    	
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA1');
		insert C1;


		// Confirm the No Phone is not set.
    	A1 = [select Id, No_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Phone__c);
		C1 = [select Id, No_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Phone__c);


		// Insert a preference for the Account
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			rC_Bios__Account__c = A1.Id,
			//rC_Bios__Contact__c = contact1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Phone'
		);
		insert P1;
		System.debug('pref1:' + P1);

		// Confirm the No Phone is NOW set on the Account and Contact
    	A1 = [select Id, No_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Phone__c);
    	C1 = [select Id, No_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Phone__c);


		// Update the preference and deactivate it.
		rC_Bios__Preference__c P2 =  [select Id, rC_Bios__Active__c from rC_Bios__Preference__c where Id=:P1.Id];
		P2.rC_Bios__Active__c = false;
		update P2;

		// Confirm the No Phone is NOW set back to False on the Account and Contact
		A1 = [select Id, No_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Phone__c);
    	C1 = [select Id, No_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Phone__c);
    }


	// Create an Account & Contact, add a No Phone preference
	//	Add a 2nd Contact and confirm 
    static testMethod void myUnitTestNoPhoneTwo() {
    	
    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        insert setting; 
    	
		// Create an Account
		Account A1 = new Account(Name='AccountA');
		insert A1;

		// Create a Contact		
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA1');
		insert C1;


		// Confirm the No Phone is not set.
    	A1 = [select Id, No_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Phone__c);
    	C1 = [select Id, No_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Phone__c);

		
		// Insert a preference for the Account
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			rC_Bios__Account__c = A1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Phone'
		);
		insert P1;
		System.debug('pref1:' + P1);


		// Confirm the No Phone is NOW set.
    	A1 = [select Id, No_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Phone__c);
    	C1 = [select Id, No_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Phone__c);


		// Now insert a 2nd Contact to the Account
		Contact C2 = new Contact(AccountId=A1.Id, LastName='ContactC2');
		insert C2;


		// Confirm the No Phone is NOW set for all records
    	A1 = [select Id, No_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Phone__c);

    	C1 = [select Id, No_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Phone__c);
		
    	C2 = [select Id, No_Phone__c from Contact where Id=:C2.Id];
    	System.assertEquals(TRUE, C2.No_Phone__c);
		
    }


	// Make sure a No Phone Preference only on a Contact is ignored
    static testMethod void myUnitTestNoPhoneThree() {

    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        insert setting; 
    	
		
		// Create an Account    	
		Account A1 = new Account(Name='AccountA');
		insert A1;
		
		// Create a Contact    	
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA');
		insert C1;


		// Confirm the No Phone is not set.
    	A1 = [select Id, No_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Phone__c);
    	C1 = [select Id, No_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Phone__c);


		// Insert a preference, but for the Contact!
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			//rC_Bios__Account__c = account1.Id,		// Account is blank
			rC_Bios__Contact__c = C1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Phone'
		);
		insert P1;
		System.debug('pref1:' + P1);


		// Confirm the No Phone is still not set.
    	A1 = [select Id, No_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Phone__c);
    	C1 = [select Id, No_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Phone__c);

    }


	/**************************************************************************************************************************
 	*	No Mail tests
 	**************************************************************************************************************************/

	// Create an Account & Contact, add a No Mail preference 
	//	then deactivate the preference
    static testMethod void myUnitTestNoMailOne() {

    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        insert setting; 

		
		// Create an Account    	
		Account A1 = new Account(Name='AccountA');
		insert A1;
		
		// Create a Contact    	
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA1');
		insert C1;


		// Confirm the No Mail is not set.
    	A1 = [select Id, No_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Mail__c);
		C1 = [select Id, No_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Mail__c);


		// Insert a preference for the Account
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			rC_Bios__Account__c = A1.Id,
			//rC_Bios__Contact__c = contact1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Mail'
		);
		insert P1;
		System.debug('pref1:' + P1);

		// Confirm the No Mail is NOW set on the Account and Contact
    	A1 = [select Id, No_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Mail__c);
    	C1 = [select Id, No_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Mail__c);


		// Update the preference and deactivate it.
		rC_Bios__Preference__c P2 =  [select Id, rC_Bios__Active__c from rC_Bios__Preference__c where Id=:P1.Id];
		P2.rC_Bios__Active__c = false;
		update P2;

		// Confirm the No Mail is NOW set back to False on the Account and Contact
		A1 = [select Id, No_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Mail__c);
    	C1 = [select Id, No_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Mail__c);
    }


	// Create an Account & Contact, add a No Mail preference
	//	Add a 2nd Contact and confirm 
    static testMethod void myUnitTestNoMailTwo() {
    	
    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        insert setting; 
    	
		// Create an Account
		Account A1 = new Account(Name='AccountA');
		insert A1;

		// Create a Contact		
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA1');
		insert C1;


		// Confirm the No Mail is not set.
    	A1 = [select Id, No_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Mail__c);
    	C1 = [select Id, No_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Mail__c);

		
		// Insert a preference for the Account
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			rC_Bios__Account__c = A1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Mail'
		);
		insert P1;
		System.debug('pref1:' + P1);


		// Confirm the No Mail is NOW set.
    	A1 = [select Id, No_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Mail__c);
    	C1 = [select Id, No_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Mail__c);


		// Now insert a 2nd Contact to the Account
		Contact C2 = new Contact(AccountId=A1.Id, LastName='ContactC2');
		insert C2;


		// Confirm the No Mail is NOW set for all records
    	A1 = [select Id, No_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Mail__c);

    	C1 = [select Id, No_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Mail__c);
		
    	C2 = [select Id, No_Mail__c from Contact where Id=:C2.Id];
    	System.assertEquals(TRUE, C2.No_Mail__c);
		
    }


	// Make sure a No Mail Preference only on a Contact is ignored
    static testMethod void myUnitTestNoMailThree() {

    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        insert setting; 
    	
		
		// Create an Account    	
		Account A1 = new Account(Name='AccountA');
		insert A1;
		
		// Create a Contact    	
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA');
		insert C1;


		// Confirm the No Mail is not set.
    	A1 = [select Id, No_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Mail__c);
    	C1 = [select Id, No_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Mail__c);


		// Insert a preference, but for the Contact!
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			//rC_Bios__Account__c = account1.Id,		// Account is blank
			rC_Bios__Contact__c = C1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Mail'
		);
		insert P1;
		System.debug('pref1:' + P1);


		// Confirm the No Mail is still not set.
    	A1 = [select Id, No_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Mail__c);
    	C1 = [select Id, No_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Mail__c);
    }


	/**************************************************************************************************************************
 	*	No Local Phone tests
 	**************************************************************************************************************************/

	// Create an Account & Contact, add a No Local Phone preference 
	//	then deactivate the preference
    static testMethod void myUnitTestNoLocalPhoneOne() {

    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        insert setting; 

		
		// Create an Account    	
		Account A1 = new Account(Name='AccountA');
		insert A1;
		
		// Create a Contact    	
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA1');
		insert C1;


		// Confirm the No Local Phone is not set.
    	A1 = [select Id, No_Local_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Local_Phone__c);
		C1 = [select Id, No_Local_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Local_Phone__c);


		// Insert a preference for the Account
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			rC_Bios__Account__c = A1.Id,
			//rC_Bios__Contact__c = contact1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Local Phone'
		);
		insert P1;
		System.debug('pref1:' + P1);

		// Confirm the No Local Phone is NOW set on the Account and Contact
    	A1 = [select Id, No_Local_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Local_Phone__c);
    	C1 = [select Id, No_Local_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Local_Phone__c);


		// Update the preference and deactivate it.
		rC_Bios__Preference__c P2 =  [select Id, rC_Bios__Active__c from rC_Bios__Preference__c where Id=:P1.Id];
		P2.rC_Bios__Active__c = false;
		update P2;

		// Confirm the No Local Phone is NOW set back to False on the Account and Contact
		A1 = [select Id, No_Local_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Local_Phone__c);
    	C1 = [select Id, No_Local_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Local_Phone__c);
    }


	// Create an Account & Contact, add a No Local Phone preference
	//	Add a 2nd Contact and confirm 
    static testMethod void myUnitTestNoLocalPhoneTwo() {
    	
    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        insert setting; 
    	
		// Create an Account
		Account A1 = new Account(Name='AccountA');
		insert A1;

		// Create a Contact		
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA1');
		insert C1;


		// Confirm the No Local Phone is not set.
    	A1 = [select Id, No_Local_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Local_Phone__c);
    	C1 = [select Id, No_Local_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Local_Phone__c);

		
		// Insert a preference for the Account
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			rC_Bios__Account__c = A1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Local Phone'
		);
		insert P1;
		System.debug('pref1:' + P1);


		// Confirm the No Local Phone is NOW set.
    	A1 = [select Id, No_Local_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Local_Phone__c);
    	C1 = [select Id, No_Local_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Local_Phone__c);


		// Now insert a 2nd Contact to the Account
		Contact C2 = new Contact(AccountId=A1.Id, LastName='ContactC2');
		insert C2;


		// Confirm the No Local Phone is NOW set for all records
    	A1 = [select Id, No_Local_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Local_Phone__c);

    	C1 = [select Id, No_Local_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Local_Phone__c);
		
    	C2 = [select Id, No_Local_Phone__c from Contact where Id=:C2.Id];
    	System.assertEquals(TRUE, C2.No_Local_Phone__c);
		
    }


	// Make sure a No Local Phone Preference only on a Contact is ignored
    static testMethod void myUnitTestNoLocalPhoneThree() {

    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        insert setting; 
    	
		
		// Create an Account    	
		Account A1 = new Account(Name='AccountA');
		insert A1;
		
		// Create a Contact    	
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA');
		insert C1;


		// Confirm the No Local Phone is not set.
    	A1 = [select Id, No_Local_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Local_Phone__c);
    	C1 = [select Id, No_Local_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Local_Phone__c);


		// Insert a preference, but for the Contact!
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			//rC_Bios__Account__c = account1.Id,		// Account is blank
			rC_Bios__Contact__c = C1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Local Phone'
		);
		insert P1;
		System.debug('pref1:' + P1);


		// Confirm the No Local Phone is still not set.
    	A1 = [select Id, No_Local_Phone__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Local_Phone__c);
    	C1 = [select Id, No_Local_Phone__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Local_Phone__c);

    }


	/**************************************************************************************************************************
 	*	No Local Mail tests
 	**************************************************************************************************************************/

	// Create an Account & Contact, add a No Local Mail preference 
	//	then deactivate the preference
    static testMethod void myUnitTestNoLocalMailOne() {

    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        insert setting; 

		
		// Create an Account    	
		Account A1 = new Account(Name='AccountA');
		insert A1;
		
		// Create a Contact    	
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA1');
		insert C1;


		// Confirm the No Local Mail is not set.
    	A1 = [select Id, No_Local_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Local_Mail__c);
		C1 = [select Id, No_Local_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Local_Mail__c);


		// Insert a preference for the Account
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			rC_Bios__Account__c = A1.Id,
			//rC_Bios__Contact__c = contact1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Local Mail'
		);
		insert P1;
		System.debug('pref1:' + P1);

		// Confirm the No Local Mail is NOW set on the Account and Contact
    	A1 = [select Id, No_Local_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Local_Mail__c);
    	C1 = [select Id, No_Local_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Local_Mail__c);


		// Update the preference and deactivate it.
		rC_Bios__Preference__c P2 =  [select Id, rC_Bios__Active__c from rC_Bios__Preference__c where Id=:P1.Id];
		P2.rC_Bios__Active__c = false;
		update P2;

		// Confirm the No Local Mail is NOW set back to False on the Account and Contact
		A1 = [select Id, No_Local_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Local_Mail__c);
    	C1 = [select Id, No_Local_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Local_Mail__c);
    }


	// Create an Account & Contact, add a No Local Mail preference
	//	Add a 2nd Contact and confirm 
    static testMethod void myUnitTestNoLocalMailTwo() {
    	
    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        insert setting; 
    	
		// Create an Account
		Account A1 = new Account(Name='AccountA');
		insert A1;

		// Create a Contact		
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA1');
		insert C1;


		// Confirm the No Local Mail is not set.
    	A1 = [select Id, No_Local_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Local_Mail__c);
    	C1 = [select Id, No_Local_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Local_Mail__c);

		
		// Insert a preference for the Account
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			rC_Bios__Account__c = A1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Local Mail'
		);
		insert P1;
		System.debug('pref1:' + P1);


		// Confirm the No Local Mail is NOW set.
    	A1 = [select Id, No_Local_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Local_Mail__c);
    	C1 = [select Id, No_Local_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Local_Mail__c);


		// Now insert a 2nd Contact to the Account
		Contact C2 = new Contact(AccountId=A1.Id, LastName='ContactC2');
		insert C2;


		// Confirm the No Local Mail is NOW set for all records
    	A1 = [select Id, No_Local_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(TRUE, A1.No_Local_Mail__c);

    	C1 = [select Id, No_Local_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(TRUE, C1.No_Local_Mail__c);
		
    	C2 = [select Id, No_Local_Mail__c from Contact where Id=:C2.Id];
    	System.assertEquals(TRUE, C2.No_Local_Mail__c);
		
    }


	// Make sure a No Local Mail Preference only on a Contact is ignored
    static testMethod void myUnitTestNoLocalMailThree() {

    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        insert setting; 
    	
		
		// Create an Account    	
		Account A1 = new Account(Name='AccountA');
		insert A1;
		
		// Create a Contact    	
		Contact C1 = new Contact(AccountId=A1.Id, LastName='ContactA');
		insert C1;


		// Confirm the No Local Mail is not set.
    	A1 = [select Id, No_Local_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Local_Mail__c);
    	C1 = [select Id, No_Local_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Local_Mail__c);


		// Insert a preference, but for the Contact!
		rC_Bios__Preference__c P1 = new rC_Bios__Preference__c(
			//rC_Bios__Account__c = account1.Id,		// Account is blank
			rC_Bios__Contact__c = C1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'Contact Preference',
			rC_Bios__Subcategory__c = 'No Local Mail'
		);
		insert P1;
		System.debug('pref1:' + P1);


		// Confirm the No Local Mail is still not set.
    	A1 = [select Id, No_Local_Mail__c from Account where Id=:A1.Id];
    	System.assertEquals(FALSE, A1.No_Local_Mail__c);
    	C1 = [select Id, No_Local_Mail__c from Contact where Id=:C1.Id];
    	System.assertEquals(FALSE, C1.No_Local_Mail__c);
    }
    
}