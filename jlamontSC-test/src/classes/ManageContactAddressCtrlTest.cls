//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Test Class for ManageContactAddressCtrl 
//	7 April 2014    Pitamber (Appirio)     Original
//**********************************************************************/

@isTest
private class ManageContactAddressCtrlTest {
	
	
	@IsTest
    static void testManageCA_Scenario1() {
    	PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert contactAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+contactAddressToInsert);
        ApexPages.currentPage().getParameters().put('id',testContact.Id);
        
        test.startTest();	       
	        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
	        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
	        
	        manageAddressCtrl.contactAddressToInsert = testData.createNewValidContactAddress(false);
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(-1).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(-1).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
	        manageAddressCtrl.upsertContactAddressList();
	        manageAddressCtrl.queryContactAddress();
	        
	        manageAddressCtrl.contactAddressToInsert = testData.createNewValidContactAddress(false);
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(-2).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(-2).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Preferred_Other__c = true;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Preferred_Mailing__c = true;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Active__c = true;
	        manageAddressCtrl.upsertContactAddressListAndReturn();
	        List<ApexPages.Message> messages = ApexPages.getMessages();
	        //ApexPages.Message msg = messages.get(4);
	        system.debug(':: Messages 11 ::'+messages);
	    Test.stopTest();
    }
    @IsTest
    static void testManageCA_Scenario2() {
    	PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert contactAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+contactAddressToInsert);
        ApexPages.currentPage().getParameters().put('id',testContact.Id);
        
        test.startTest();	       
	        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
	        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
	        
	        manageAddressCtrl.contactAddressToInsert  = testData.createNewInvalidContactAddress(false);
	        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.contactAddressToInsert);  
	        
	        //Test for Zip and Country is blank
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_City__c = null;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Country__c = null;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Postal_Code__c = null;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Start_Date__c = System.today();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__End_Date__c = System.today().addDays(10);
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Preferred_Other__c = true;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Preferred_Mailing__c = true;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Active__c = true;
	               
	        //Save Address With invalid Valid Address
	        manageAddressCtrl.upsertContactAddressList();
	        
	        List<ApexPages.Message> messages = ApexPages.getMessages();
	        ApexPages.Message msg = messages.get(0);
	        system.debug(':: Messages 22 ::'+messages);
	        //system.assertEquals(msg.getDetail(), 'City field is required to validate the address');
	        
	   		manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_City__c = 'San Francisco';
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Country__c = 'USA';
	        
	         //Save Address With invalid Valid Address
	        manageAddressCtrl.upsertContactAddressList();
	        messages = ApexPages.getMessages();
	        //msg = messages.get(0);
	        system.debug(':: Messages 33 ::'+messages);
	        //system.assertEquals(msg.getDetail(), 'City field is required to validate the address');
			
			//test for Active address should be  Preffered
		Test.stopTest();
    	
    }
    
    @IsTest
    static void testManageCA_Scenario3() {
    		
    		
    	PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert contactAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+contactAddressToInsert);
        ApexPages.currentPage().getParameters().put('id',testContact.Id);
        
        test.startTest();	       
	        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
	        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
	        manageAddressCtrl.contactAddressToInsert  = testData.createNewValidContactAddress(false);
	        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.contactAddressToInsert);  
	        
	        //Test for Zip and Country is blank
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Preferred_Other__c = true;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Active__c = true;
	        manageAddressCtrl.upsertContactAddressList();
	    test.stopTest();
	        List<ApexPages.Message> messages = ApexPages.getMessages();
	        //msg = messages.get(1);
	        system.debug(':: Messages 44 ::'+messages);
	        //system.assertEquals(msg.getDetail(), 'Active Dates of Same Type of addresses are overlapping');
	       
	        
	    	manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
	        
	        manageAddressCtrl.lstAddress.get(0).cntAddress.rC_Bios__Original_City__c = null;
	         //Save Address With invalid Valid Address
	        manageAddressCtrl.upsertContactAddressList();
	    
	        
    	
    }
    
    @IsTest
    static void testManageCA_Scenario4() {
    	PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert contactAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+contactAddressToInsert);
        ApexPages.currentPage().getParameters().put('id',testContact.Id);
        
        test.startTest();	       
	        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
	        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
	        manageAddressCtrl.contactAddressToInsert  = testData.createNewValidContactAddress(false);
	        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.contactAddressToInsert);  
	        
	        //Test for Zip and Country is blank
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Preferred_Other__c = true;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Active__c = true;
	        List<ApexPages.Message> messages = ApexPages.getMessages();

	    	manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
	        
	        manageAddressCtrl.lstAddress.get(0).cntAddress.rC_Bios__Original_City__c = 'Sen';
	        manageAddressCtrl.lstAddress.get(0).cntAddress.rC_Bios__Original_Street_Line_1__c = 'Test Long Name Exception Test Long Name Exception Test Long Name Exception Test Long Name Exception Test Long Name Exception';
	        //Save Address With invalid Valid Address
	        manageAddressCtrl.upsertContactAddressList();
		test.stopTest();    
	        manageAddressCtrl.lstAddress.get(0).cntAddress.rC_Bios__Original_Street_Line_1__c = 'One Market St';
	        //Save Address With invalid Valid Address
	        manageAddressCtrl.upsertContactAddressList();
    }
    
    @IsTest
    static void testManageCA_Scenario5() {
    	//Address inactive error
    	PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert contactAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+contactAddressToInsert);
        ApexPages.currentPage().getParameters().put('id',testContact.Id);
        
        test.startTest();	       
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
    	manageAddressCtrl.lstAddress[0].cntAddress.rC_Bios__Preferred_Other__c = true;
    	manageAddressCtrl.lstAddress[0].cntAddress.rC_Bios__Active__c = false;
    	manageAddressCtrl.upsertContactAddressList();
    	system.assertEquals(true,String.valueOf(ApexPages.getMessages()).contains('Address can not be inactive if it is selected as preferred'));
    }
    
    @IsTest
    static void testManageCA_Scenario6() {
    	//Address invalid seasonal dates
    	PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert contactAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+contactAddressToInsert);
        ApexPages.currentPage().getParameters().put('id',testContact.Id);
        
        test.startTest();	       
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
    	manageAddressCtrl.lstAddress[0].cntAddress.rC_Bios__Seasonal_End_Month__c = null;
    	manageAddressCtrl.upsertContactAddressList();
    	system.assertEquals(true,String.valueOf(ApexPages.getMessages()).contains('Please either complete or clear out seasonal address information'));
    }
    
    @IsTest
    static void testManageCA_Scenario7() {
    	//Address invalid active dates
    	PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert contactAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+contactAddressToInsert);
        ApexPages.currentPage().getParameters().put('id',testContact.Id);
        
        test.startTest();	       
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
    	manageAddressCtrl.lstAddress[0].cntAddress.rC_Bios__Start_Date__c = System.today();
    	manageAddressCtrl.upsertContactAddressList();
    	system.assertEquals(true,String.valueOf(ApexPages.getMessages()).contains('Please either complete or clear out active address information'));
    }
    
    @IsTest
    static void testManageCA_Scenario8() {
    	//Address invalid active dates
    	PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert contactAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+contactAddressToInsert);
        ApexPages.currentPage().getParameters().put('id',testContact.Id);
        
        test.startTest();	       
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
    	manageAddressCtrl.lstAddress[0].cntAddress.rC_Bios__Start_Date__c = System.today().addDays(2);
    	manageAddressCtrl.lstAddress[0].cntAddress.rC_Bios__End_Date__c = System.today();
    	manageAddressCtrl.upsertContactAddressList();
    	system.assertEquals(true,String.valueOf(ApexPages.getMessages()).contains('Active End Date can not be less then Start Date'));
    }
    
    @IsTest
    static void testManageCA_Scenario9() {
    	//Address invalid State
    	PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert contactAddressToInsert;
        test.startTest();	
        ApexPages.currentPage().getParameters().put('id',testContact.Id);       
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
    	manageAddressCtrl.lstAddress[0].cntAddress.rC_Bios__Original_Country__c = 'US';
    	manageAddressCtrl.lstAddress[0].cntAddress.rC_Bios__Original_State__c = 'ABC';
    	manageAddressCtrl.lstAddress[0].cntAddress.rC_Bios__Original_Postal_Code__c = '00000';
    	manageAddressCtrl.upsertContactAddressList();
    	system.assertEquals(true,String.valueOf(ApexPages.getMessages()).contains('Please enter two letter state abbreviation'));
    }
    
    @IsTest
    static void testManageCA_Scenario10() {
    	//Address service down
    	PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert contactAddressToInsert;
        test.startTest();	
        ApexPages.currentPage().getParameters().put('id',testContact.Id);       
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
        manageAddressCtrl.lstAddress[0].cntAddress.rC_Bios__Original_Postal_Code__c = '00000';
        manageAddressCtrl.isServiceDown = true;
    	manageAddressCtrl.upsertContactAddressList();
    	system.assertEquals(true,String.valueOf(ApexPages.getMessages()).contains('Address can not be validated now, Please check Override if you still want to save this.'));
    }
    	
	/*@IsTest
    static void testManageContactAddress () {  

        // VB:7/16/14: Blanking this out
	    
		PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert contactAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+contactAddressToInsert);
        ApexPages.currentPage().getParameters().put('id',testContact.Id);
		test.startTest();	       
	        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
	        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
	        
	        manageAddressCtrl.contactAddressToInsert = testData.createNewValidContactAddress(false);
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(-1).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(-1).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
	        manageAddressCtrl.upsertContactAddressList();
	        manageAddressCtrl.queryContactAddress();
	        
	        manageAddressCtrl.contactAddressToInsert = testData.createNewValidContactAddress(false);
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(-2).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(-2).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Preferred_Other__c = true;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Preferred_Mailing__c = true;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Active__c = true;
	        manageAddressCtrl.upsertContactAddressListAndReturn();
	        List<ApexPages.Message> messages = ApexPages.getMessages();
	        //ApexPages.Message msg = messages.get(4);
	        system.debug(':: Messages 11 ::'+messages);
	       ///
	        sc = new ApexPages.StandardController(testContact);
	        manageAddressCtrl = new ManageContactAddressCtrl(sc);
	        
	        manageAddressCtrl.contactAddressToInsert  = testData.createNewInvalidContactAddress(false);
	        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.contactAddressToInsert);  
	        
	        //Test for Zip and Country is blank
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_City__c = null;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Country__c = null;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Postal_Code__c = null;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Start_Date__c = System.today();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__End_Date__c = System.today().addDays(10);
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Preferred_Other__c = true;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Preferred_Mailing__c = true;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Active__c = true;
	               
	        //Save Address With invalid Valid Address
	        manageAddressCtrl.upsertContactAddressList();
	        
	        messages = ApexPages.getMessages();
	        ApexPages.Message msg = messages.get(0);
	        system.debug(':: Messages 22 ::'+messages);
	        //system.assertEquals(msg.getDetail(), 'City field is required to validate the address');
	        
	   		manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_City__c = 'San Francisco';
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Country__c = 'USA';
	        
	         //Save Address With invalid Valid Address
	        manageAddressCtrl.upsertContactAddressList();
	        messages = ApexPages.getMessages();
	        //msg = messages.get(0);
	        system.debug(':: Messages 33 ::'+messages);
	        //system.assertEquals(msg.getDetail(), 'City field is required to validate the address');
			
			//test for Active address should be  Preffered
			///
			//sc = new ApexPages.StandardController(testContact);
	        manageAddressCtrl = new ManageContactAddressCtrl(sc);
	        
	        manageAddressCtrl.contactAddressToInsert  = testData.createNewValidContactAddress(false);
	        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.contactAddressToInsert);  
	        
	        //Test for Zip and Country is blank
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Preferred_Other__c = true;
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Active__c = true;
	        manageAddressCtrl.upsertContactAddressList();
	        messages = ApexPages.getMessages();
	        //msg = messages.get(1);
	        system.debug(':: Messages 44 ::'+messages);
	        //system.assertEquals(msg.getDetail(), 'Active Dates of Same Type of addresses are overlapping');
	       
	        
	    	  manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
	        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
	        
	        manageAddressCtrl.lstAddress.get(0).cntAddress.rC_Bios__Original_City__c = null;
	         //Save Address With invalid Valid Address
	        manageAddressCtrl.upsertContactAddressList();
	        test.stopTest();
	        manageAddressCtrl.lstAddress.get(0).cntAddress.rC_Bios__Original_City__c = 'Sen';
	        manageAddressCtrl.lstAddress.get(0).cntAddress.rC_Bios__Original_Street_Line_1__c = 'Test Long Name Exception Test Long Name Exception Test Long Name Exception Test Long Name Exception Test Long Name Exception';
	        //Save Address With invalid Valid Address
	        manageAddressCtrl.upsertContactAddressList();
	        
	        manageAddressCtrl.lstAddress.get(0).cntAddress.rC_Bios__Original_Street_Line_1__c = 'One Market St';
	        //Save Address With invalid Valid Address
	        manageAddressCtrl.upsertContactAddressList();
        
        
        
        //test for Invalid Adderss
    
		
    }*/

    @IsTest
    static void testManageAddressValidations () {  
		PageReference prPageLink = Page.ManageContactAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true, 'Test F', 'Last', 'Household', testAccount.Id);
        rC_Bios__Contact_Address__c contactAddressToInsert = testData.createNewValidContactAddress(false);
        contactAddressToInsert.rC_Bios__Contact__c = testContact.Id;
        insert contactAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+contactAddressToInsert);
         ApexPages.currentPage().getParameters().put('id',testContact.Id);
       
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        ManageContactAddressCtrl manageAddressCtrl = new ManageContactAddressCtrl(sc);
        
        manageAddressCtrl.contactAddressToInsert  = testData.createNewValidContactAddress(false);
        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.contactAddressToInsert);  
        
         //Test for Zip and Country is blank
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Country__c = null;
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Postal_Code__c = null;
        manageAddressCtrl.upsertContactAddressList();
    
        List<ApexPages.Message> messages = ApexPages.getMessages();
        //ApexPages.Message msg = messages.get(3);
        system.debug(':: Messages 88 ::'+messages);
        
        
        manageAddressCtrl.contactAddressToInsert  = testData.createNewValidContactAddress(false);
        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.contactAddressToInsert);  
        
         //Test for Zip and Wrong State
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Postal_Code__c = '00000';
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_State__c = 'CAT';
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Country__c = 'USA';
        
        System.debug('::: INvalid State Code:::');
        manageAddressCtrl.upsertContactAddressList();
    
        messages = ApexPages.getMessages();
        //ApexPages.Message msg = messages.get(0);
        system.debug(':: Messages 99 ::'+messages);
        //system.assertEquals(msg.getDetail(), 'Please enter two letter state abbreviation');
        
        sc = new ApexPages.StandardController(testContact);
        manageAddressCtrl = new ManageContactAddressCtrl(sc);
        
        manageAddressCtrl.contactAddressToInsert  = testData.createNewValidContactAddress(false);
        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.contactAddressToInsert);  
        
         //Test for Zip and Country is blank
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_City__c = null;
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Country__c = null;
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Postal_Code__c = null;
        
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        
        manageAddressCtrl.lstAddress.get(0).cntAddress.rC_Bios__Original_City__c = '';
        manageAddressCtrl.lstAddress.get(0).cntAddress.rC_Bios__Original_Street_Line_2__c = '';
        //manageAddressCtrl.lstAddress.get(1).cntAddress.rC_Bios__Original_State__c = 'Test State';
        //manageAddressCtrl.lstAddress.get(1).cntAddress.rC_Bios__Original_Country__c = 'USA';
        
        manageAddressCtrl.isInvalidTestAddress = true;
        
        manageAddressCtrl.upsertContactAddressList();
      
        
        //manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_City__c = 'San Francisco';
        //manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_Country__c = 'USA';
        manageAddressCtrl.contactAddressToInsert  = testData.createNewValidContactAddress(false);
        manageAddressCtrl.contactAddressToInsert.rC_Bios__Original_City__c = 'This is now longer then 30 characters.';
        manageAddressCtrl.isOverride = true;
        manageAddressCtrl.isInvalidTestAddress = true;
       
        manageAddressCtrl.upsertContactAddressList(); 
        
        messages = ApexPages.getMessages();
        //msg = messages.get(3);
        system.debug(':: Messages 77 ::'+messages);
        //system.assertEquals(msg.getDetail(), 'Address(es) not Validated.');
    }
}