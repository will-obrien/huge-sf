@isTest
// *********************************************************************************** 
// 
//  MS_Notify_ClientRelations_TEST
//  
//  Desciption:
//  Class for all of the unit tests associated with the 
//  MS_Notify_ClientRelations trigger.
//
//  NOTE: The bulk of system testing this trigger requires manual testing
//        as there is no way to inspect the contents of an email message
//        in the current SFDC Automated Test mechanism.  These test simply
//        insure basic operation and provide required code coverage.
//
//  Developed for Microsystems by InSitu Software LLC.
//  
//  History:
//  RMN    12/24/2009    Original version
// ***********************************************************************************
private class MS_Notify_ClientRelations_TEST 
{
	// ----------------------------------------------------------
	// Test1 - New, not Active
	// ----------------------------------------------------------
    static testMethod void Test1() 
    {
     	// Set up the Settings
     	User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs( thisUser )
		{
			CRCN_Settings__c settings = CRCN_Settings__c.getInstance();
		  
			if(settings == null) 
			{
				settings = new CRCN_Settings__c();
			    settings.Active__c = false;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = false;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    insert settings;
			}
			else
			{
				settings.Active__c = false;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = false;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    update settings;		
			}
		}  
     	
     	// Setup the Account(s)
     	Account acctTest = new Account (Name = 'CRCN Test Account 1');
     	insert acctTest;
     	
     	// Set up the Contacts
     	Contact contactTest = new Contact (LastName = 'CRCN Test Contact 1',
     	                                   AccountId = acctTest.Id);
     	
     	// Get Message Tracking Info
     	Integer iMessagesSent = Limits.getEmailInvocations();
     	    	
     	// Execute Tests
     	insert contactTest;
     	System.assertEquals(iMessagesSent, Limits.getEmailInvocations());

    } // End Test1()
    
    // ----------------------------------------------------------
	// Test2 - New, Not a Customer
	// ----------------------------------------------------------
    static testMethod void Test2() 
    {
     	// Set up the Settings
     	User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs( thisUser )
		{
			CRCN_Settings__c settings = CRCN_Settings__c.getInstance();
		  
			if(settings == null) 
			{
				settings = new CRCN_Settings__c();
			    settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    insert settings;
			}
			else
			{
				settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    update settings;		
			}
		}  
     	
     	// Setup the Account(s)
     	Account acctTest = new Account (Name = 'CRCN Test Account 1',
     	                                Customer__c = 'No');
     	insert acctTest;
     	
     	// Set up the Contacts
     	Contact contactTest = new Contact (LastName = 'CRCN Test Contact 1',
     	                                   AccountId = acctTest.Id);
     	
     	// Get Message Tracking Info
     	Integer iMessagesSent = Limits.getEmailInvocations();
     	    	
     	// Execute Tests
     	insert contactTest;
     	System.assertEquals(iMessagesSent, Limits.getEmailInvocations());

    } // End Test2()
    
    // ----------------------------------------------------------
	// Test3 - New send Notice
	// ----------------------------------------------------------
    static testMethod void Test3() 
    {
     	// Set up the Settings
     	User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs( thisUser )
		{
			CRCN_Settings__c settings = CRCN_Settings__c.getInstance();
		  
			if(settings == null) 
			{
				settings = new CRCN_Settings__c();
			    settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    insert settings;
			}
			else
			{
				settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    update settings;		
			}
		}  
     	
     	// Setup the Account(s)
     	Account acctTest = new Account (Name = 'CRCN Test Account 1',
     	                                Customer__c = 'Yes');
     	insert acctTest;
     	
     	// Set up the Contacts
     	Contact contactTest = new Contact (LastName = 'CRCN Test Contact 1',
     	                                   AccountId = acctTest.Id);
     	
     	// Get Message Tracking Info
     	Integer iMessagesSent = Limits.getEmailInvocations();
     	    	
     	// Execute Tests
     	insert contactTest;
     	// NOTE: Have to comment this assert out because SFDC will not send messages
     	//       (even the ones that get stopped in tests) from a Sandbox environment.
     	//       This assert can be uncommented if testing in a DE or if they fix the
     	//       test infrastruction in the future.
     	// System.assertNotEquals(iMessagesSent, Limits.getEmailInvocations());

    } // End Test3()
    
    // ----------------------------------------------------------
	// Test4 - Multiple New send Notice
	// ----------------------------------------------------------
    static testMethod void Test4() 
    {
     	// Set up the Settings
     	User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs( thisUser )
		{
			CRCN_Settings__c settings = CRCN_Settings__c.getInstance();
		  
			if(settings == null) 
			{
				settings = new CRCN_Settings__c();
			    settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    insert settings;
			}
			else
			{
				settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    update settings;		
			}
		}  
     	
     	// Setup the Account(s)
     	Account acctTest1 = new Account (Name = 'CRCN Test Account 1',
     	                                Customer__c = 'Yes');
     	insert acctTest1;
     	
     	Account acctTest2 = new Account (Name = 'CRCN Test Account 2',
     	                                Customer__c = 'No');
     	insert acctTest2;
     	
     	// Set up the Contacts
     	List<Contact> listTestContacts = new List<Contact>();
     	Contact contactTest1 = new Contact (LastName = 'CRCN Test Contact 1',
     	                                    FirstName = 'Bob',
     	                                    Title = 'Cook',
     	                                    AccountId = acctTest1.Id);
     	listTestContacts.add(contactTest1);
     	
     	Contact contactTest2 = new Contact (LastName = 'CRCN Test Contact 2',
     	                                    AccountId = acctTest2.Id);
     	listTestContacts.add(contactTest2);
     	
     	Contact contactTest3 = new Contact (LastName = 'CRCN Test Contact 3',
     	                                    AccountId = acctTest1.Id);
     	listTestContacts.add(contactTest3);                             
     	
     	// Get Message Tracking Info
     	Integer iMessagesSent = Limits.getEmailInvocations();
     	    	
     	// Execute Tests
     	insert listTestContacts;
     	// NOTE: Have to comment this assert out because SFDC will not send messages
     	//       (even the ones that get stopped in tests) from a Sandbox environment.
     	//       This assert can be uncommented if testing in a DE or if they fix the
     	//       test infrastruction in the future.
     	// System.assertNotEquals(iMessagesSent, Limits.getEmailInvocations());

    } // End Test4()
    
    // ----------------------------------------------------------
	// Test5 - Change, all non-customers, Send Notify
	// ----------------------------------------------------------
    static testMethod void Test5() 
    {
     	// Set up the Settings
     	User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs( thisUser )
		{
			CRCN_Settings__c settings = CRCN_Settings__c.getInstance();
		  
			if(settings == null) 
			{
				settings = new CRCN_Settings__c();
			    settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = false;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    insert settings;
			}
			else
			{
				settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = false;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    update settings;		
			}
		}  
     	
     	// Setup the Account(s)
     	Account acctTest1 = new Account (Name = 'CRCN Test Account 1',
     	                                Customer__c = 'No');
     	insert acctTest1;
     	
     	Account acctTest2 = new Account (Name = 'CRCN Test Account 2',
     	                                Customer__c = 'No');
     	insert acctTest2;
     	
     	// Set up the Contacts
     	Contact contactTest = new Contact (LastName = 'CRCN Test Contact 1',
     	                                   AccountId = acctTest1.Id);
     	insert contactTest;
     	
     	// Get Message Tracking Info
     	Integer iMessagesSent = Limits.getEmailInvocations();
     	    	
     	// Execute Tests
     	contactTest.AccountId = acctTest2.Id;
     	update contactTest;
     	// NOTE: Have to comment this assert out because SFDC will not send messages
     	//       (even the ones that get stopped in tests) from a Sandbox environment.
     	//       This assert can be uncommented if testing in a DE or if they fix the
     	//       test infrastruction in the future.
     	// System.assertNotEquals(iMessagesSent, Limits.getEmailInvocations());

    } // End Test5()

	// ----------------------------------------------------------
	// Test6 - Change, all non-customers, NO Send Notify
	// ----------------------------------------------------------
    static testMethod void Test6() 
    {
     	// Set up the Settings
     	User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs( thisUser )
		{
			CRCN_Settings__c settings = CRCN_Settings__c.getInstance();
		  
			if(settings == null) 
			{
				settings = new CRCN_Settings__c();
			    settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    insert settings;
			}
			else
			{
				settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    update settings;		
			}
		}  
     	
     	// Setup the Account(s)
     	Account acctTest1 = new Account (Name = 'CRCN Test Account 1',
     	                                Customer__c = 'No');
     	insert acctTest1;
     	
     	Account acctTest2 = new Account (Name = 'CRCN Test Account 2',
     	                                Customer__c = 'No');
     	insert acctTest2;
     	
     	// Set up the Contacts
     	Contact contactTest = new Contact (LastName = 'CRCN Test Contact 1',
     	                                   AccountId = acctTest1.Id);
     	insert contactTest;
     	
     	// Get Message Tracking Info
     	Integer iMessagesSent = Limits.getEmailInvocations();
     	    	
     	// Execute Tests
     	contactTest.AccountId = acctTest2.Id;
     	update contactTest;
     	System.assertEquals(iMessagesSent, Limits.getEmailInvocations());

    } // End Test6()
    
    // ----------------------------------------------------------
	// Test7 - Change, From Customer to Non-Customer, Send Notify
	// ----------------------------------------------------------
    static testMethod void Test7() 
    {
     	// Set up the Settings
     	User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs( thisUser )
		{
			CRCN_Settings__c settings = CRCN_Settings__c.getInstance();
		  
			if(settings == null) 
			{
				settings = new CRCN_Settings__c();
			    settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    insert settings;
			}
			else
			{
				settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    update settings;		
			}
		}  
     	
     	// Setup the Account(s)
     	Account acctTest1 = new Account (Name = 'CRCN Test Account 1',
     	                                Customer__c = 'Yes');
     	insert acctTest1;
     	
     	Account acctTest2 = new Account (Name = 'CRCN Test Account 2',
     	                                Customer__c = 'No');
     	insert acctTest2;
     	
     	// Set up the Contacts
     	Contact contactTest = new Contact (LastName = 'CRCN Test Contact 1',
     	                                   AccountId = acctTest1.Id);
     	insert contactTest;
     	
     	// Get Message Tracking Info
     	Integer iMessagesSent = Limits.getEmailInvocations();
     	    	
     	// Execute Tests
     	contactTest.AccountId = acctTest2.Id;
     	update contactTest;
     	// NOTE: Have to comment this assert out because SFDC will not send messages
     	//       (even the ones that get stopped in tests) from a Sandbox environment.
     	//       This assert can be uncommented if testing in a DE or if they fix the
     	//       test infrastruction in the future.
     	// System.assertNotEquals(iMessagesSent, Limits.getEmailInvocations());

    } // End Test7()
    
    // ----------------------------------------------------------
	// Test8 - Change, From Non-Customer to Customer, Send Notify
	// ----------------------------------------------------------
    static testMethod void Test8() 
    {
     	// Set up the Settings
     	User thisUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs( thisUser )
		{
			CRCN_Settings__c settings = CRCN_Settings__c.getInstance();
		  
			if(settings == null) 
			{
				settings = new CRCN_Settings__c();
			    settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    insert settings;
			}
			else
			{
				settings.Active__c = true;
			    settings.Notification_Address__c = 'clientrelations@microsystems.com';
			    settings.Customers_Only__c = true;
			    settings.Sender_Display_Name__c = 'Contact Notify Test';
			    update settings;		
			}
		}  
     	
     	// Setup the Account(s)
     	Account acctTest1 = new Account (Name = 'CRCN Test Account 1',
     	                                Customer__c = 'No');
     	insert acctTest1;
     	
     	Account acctTest2 = new Account (Name = 'CRCN Test Account 2',
     	                                Customer__c = 'Yes');
     	insert acctTest2;
     	
     	// Set up the Contacts
     	Contact contactTest = new Contact (LastName = 'CRCN Test Contact 1',
     	                                   AccountId = acctTest1.Id);
     	insert contactTest;
     	
     	// Get Message Tracking Info
     	Integer iMessagesSent = Limits.getEmailInvocations();
     	    	
     	// Execute Tests
     	contactTest.AccountId = acctTest2.Id;
     	update contactTest;
     	// NOTE: Have to comment this assert out because SFDC will not send messages
     	//       (even the ones that get stopped in tests) from a Sandbox environment.
     	//       This assert can be uncommented if testing in a DE or if they fix the
     	//       test infrastruction in the future.
     	// System.assertNotEquals(iMessagesSent, Limits.getEmailInvocations());

    } // End Test8()
  
}