//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//  Test Class for ManageAddressExtension 
//  8 March 2014    Virendra (Appirio)     Original
//**********************************************************************/
@isTest
private class ManageAddressExtensionTest {

    @IsTest
    static void testManageAddress () {  
        PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        rC_Bios__Account_Address__c accountAddressToInsert = testData.createNewValidAccountAddress(false);
        accountAddressToInsert.rC_Bios__Account__c = testAccount.Id;
        accountAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        accountAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        accountAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        accountAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        insert accountAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+accountAddressToInsert);
         ApexPages.currentPage().getParameters().put('id',testAccount.Id);
       
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        ManageAddressExtension manageAddressCtrl = new ManageAddressExtension(sc);
        
        manageAddressCtrl.accountAddressToInsert = testData.createNewValidAccountAddress(false);
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(-1).month();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(-1).month();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        manageAddressCtrl.upsertAccountAddressList();
        manageAddressCtrl.queryAccountAddress();
        
        manageAddressCtrl.accountAddressToInsert = testData.createNewValidAccountAddress(false);
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(-2).month();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(-2).month();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Preferred_Billing__c = true;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Preferred_Shipping__c = true;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Active__c = true;
        manageAddressCtrl.upsertAccountAddressListAndReturn();
        
        List<ApexPages.Message> messages = ApexPages.getMessages();
        //ApexPages.Message msg = messages.get(4);
        system.debug(':: Messages 11 ::'+messages);
       
        sc = new ApexPages.StandardController(testAccount);
        manageAddressCtrl = new ManageAddressExtension(sc);
        
        manageAddressCtrl.accountAddressToInsert  = testData.createNewInvalidAccountAddress(false);
        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.accountAddressToInsert);  
        
        //Test for Zip and Country is blank
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_City__c = null;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_Country__c = null;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_Postal_Code__c = null;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().month();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Start_Date__c = System.today();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().month();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__End_Date__c = System.today().addDays(10);
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Preferred_Billing__c = true;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Preferred_Shipping__c = true;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Active__c = true;
               
        //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        
        messages = ApexPages.getMessages();
        ApexPages.Message msg = messages.get(0);
        system.debug(':: Messages 22 ::'+messages);
        //system.assertEquals(msg.getDetail(), 'City field is required to validate the address');
        
            manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_City__c = 'San Francisco';
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_Country__c = 'USA';
        
         //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        messages = ApexPages.getMessages();
        //msg = messages.get(0);
        system.debug(':: Messages 33 ::'+messages);
        //system.assertEquals(msg.getDetail(), 'City field is required to validate the address');
        
        //test for Active address should be  Preffered
        
        sc = new ApexPages.StandardController(testAccount);
        manageAddressCtrl = new ManageAddressExtension(sc);
        
        manageAddressCtrl.accountAddressToInsert  = testData.createNewValidAccountAddress(false);
        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.accountAddressToInsert);  
        
        //Test for Zip and Country is blank
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Preferred_Billing__c = true;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Active__c = true;
        manageAddressCtrl.upsertAccountAddressList();
        
        messages = ApexPages.getMessages();
        //msg = messages.get(1);
        system.debug(':: Messages 44 ::'+messages);
        //system.assertEquals(msg.getDetail(), 'Active Dates of Same Type of addresses are overlapping');
       
        
          manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        
        manageAddressCtrl.lstAddress.get(0).acctAddress.rC_Bios__Original_City__c = null;
         //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        
        manageAddressCtrl.lstAddress.get(0).acctAddress.rC_Bios__Original_City__c = 'Sen';
        manageAddressCtrl.lstAddress.get(0).acctAddress.rC_Bios__Original_Street_Line_1__c = 'Test Long Name Exception Test Long Name Exception Test Long Name Exception Test Long Name Exception Test Long Name Exception';
        //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        
        manageAddressCtrl.lstAddress.get(0).acctAddress.rC_Bios__Original_Street_Line_1__c = 'One Market St';
        manageAddressCtrl.lstAddress.get(0).acctAddress.rC_Bios__Original_City__c = 'Test City';
        //manageAddressCtrl.lstAddress.get(1).acctAddress.rC_Bios__Original_State__c = 'Test State';
        //manageAddressCtrl.lstAddress.get(1).acctAddress.rC_Bios__Original_Country__c = 'USA';
        
        manageAddressCtrl.isInvalidTestAddress = true;
        //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        
        
        
        //test for Invalid Adderss
        
        sc = new ApexPages.StandardController(testAccount);
        manageAddressCtrl = new ManageAddressExtension(sc);
        
        manageAddressCtrl.accountAddressToInsert  = testData.createNewValidAccountAddress(false);
        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.accountAddressToInsert);  
        
         //Test for Zip and Country is blank
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_City__c = null;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_Country__c = null;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_Postal_Code__c = null;
        
        manageAddressCtrl.upsertAccountAddressList();
      
        
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_City__c = 'San Francisco';
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_Country__c = 'USA';
        manageAddressCtrl.isInvalidTestAddress = true;
       
        manageAddressCtrl.upsertAccountAddressList(); 
        
        messages = ApexPages.getMessages();
        //msg = messages.get(3);
        system.debug(':: Messages 77 ::'+messages);
       
        //system.assertEquals(msg.getDetail(), 'Address(es) not Validated.');
               
   
    }
    
    @IsTest
    static void testManageAddressValidations () {  
        PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        rC_Bios__Account_Address__c accountAddressToInsert = testData.createNewValidAccountAddress(false);
        accountAddressToInsert.rC_Bios__Account__c = testAccount.Id;
        insert accountAddressToInsert;
        system.debug(':::accountAddressToInsert:::'+accountAddressToInsert);
         ApexPages.currentPage().getParameters().put('id',testAccount.Id);
       
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        ManageAddressExtension manageAddressCtrl = new ManageAddressExtension(sc);
        
        manageAddressCtrl.accountAddressToInsert  = testData.createNewValidAccountAddress(false);
        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.accountAddressToInsert);  
        
         //Test for Zip and Country is blank
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_Country__c = null;
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_Postal_Code__c = null;
        manageAddressCtrl.upsertAccountAddressList();
    
        List<ApexPages.Message> messages = ApexPages.getMessages();
        //ApexPages.Message msg = messages.get(3);
        system.debug(':: Messages 88 ::'+messages);
        
        
        manageAddressCtrl.accountAddressToInsert  = testData.createNewValidAccountAddress(false);
        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.accountAddressToInsert);  
        
         //Test for Zip and Wrong State
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_Postal_Code__c = '00000';
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_State__c = 'CAT';
        manageAddressCtrl.accountAddressToInsert.rC_Bios__Original_Country__c = 'USA';
        
        System.debug('::: INvalid State Code:::');
        manageAddressCtrl.upsertAccountAddressList();
    
        messages = ApexPages.getMessages();
        //ApexPages.Message msg = messages.get(0);
        system.debug(':: Messages 99 ::'+messages);
        //system.assertEquals(msg.getDetail(), 'Please enter two letter state abbreviation');
        
        
    }

}