@isTest
private class ManageAddressExtensionKWTest {
    
    //*********************************************************************
// (c) 2014 Appirio, Inc.
//
//  Test Class for ManageAddressesExtensionKW 
//  8 March 2014    Virendra (Appirio)     Original
// 23 April 2015    Peter Churchill - Changed to use ZDM Address Service
//**********************************************************************/

   @testSetup
   private static void setupAddressSettings() {
   kwzd.KWD_ExternalAccess_TESTS.setZDMSetupData();
  
    List<StreetAddressTwoValues__c> street2values = new List<StreetAddressTwoValues__c>();
    street2values.add(new StreetAddressTwoValues__c (Name = 'Apt'));
    insert street2values;

        kwzd__ZDMCustomObjectLookup__c zdmobject = new kwzd__ZDMCustomObjectLookup__c();
        zdmobject.Name = 'rC_Bios__Account_Address__c';
        zdmobject.kwzd__Alias__c = 'RCAA';
        zdmobject.kwzd__Namespace__c = 'kwrc__';
        insert zdmobject;
        
        List<kwzd__ZDM_Settings__c> zdmsettings = new List<kwzd__ZDM_Settings__c>();
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAStreet', kwzd__Field_Name__c = 'rC_Bios__Original_Street_Line_1__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAStreet2', kwzd__Field_Name__c = 'rC_Bios__Original_Street_Line_2__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAACity', kwzd__Field_Name__c = 'rC_Bios__Original_City__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAState', kwzd__Field_Name__c = 'rC_Bios__Original_State__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAZip', kwzd__Field_Name__c = 'rC_Bios__Original_Postal_Code__c'));
        insert zdmsettings;

   }
    @IsTest
    static void testManageAddress () {  
        
     

        PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        rC_Bios__Account_Address__c addressToInsert = testData.createNewValidAccountAddress(false);
        addressToInsert.rC_Bios__Account__c = testAccount.Id;
        addressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        addressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        addressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        addressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        addressToinsert.rC_Bios__Preferred_Billing__c = true;
        addressToinsert.rC_Bios__Preferred_Shipping__c = true;
        addressToinsert.rC_Bios__Active__c = true;
       
        insert addressToInsert;
        
        system.debug(':::addressToInsert:::'+addressToInsert);
        ApexPages.currentPage().getParameters().put('id',testAccount.Id);
       
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        ManageAddressesExtensionKW manageAddressCtrl = new ManageAddressesExtensionKW(sc);
        
        rC_Bios__Account_Address__c addressToInsert2 = testData.createNewValidAccountAddress(false);
        addressToInsert2.rC_Bios__Original_Street_Line_2__c = 'c/o KnowWho';
     
        addressToInsert2.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(-1).month();
        addressToInsert2.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day(); 
        addressToInsert2.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(-1).month();
        addressToInsert2.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        //manageAddressCtrl.upsertAccountAddressList();
        //manageAddressCtrl.maservice.queryAddress();
        addressToinsert2.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(-2).month();
        addressToinsert2.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        addressToinsert2.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(-2).month();
        addressToinsert2.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        addressToinsert2.rC_Bios__Preferred_Billing__c = false;
        addressToinsert2.rC_Bios__Preferred_Shipping__c = false;
        addressToinsert2.rC_Bios__Active__c = true;
       
        manageAddressCtrl.maservice.addressToInsert = addressToInsert2;
        manageAddressCtrl.upsertAccountAddressListAndReturn();
        
        List<ApexPages.Message> messages = ApexPages.getMessages();
        //ApexPages.Message msg = messages.get(4);
        system.debug(':: Messages 11 ::'+messages);
       
        sc = new ApexPages.StandardController(testAccount);
        manageAddressCtrl = new ManageAddressesExtensionKW(sc);
        
        rC_Bios__Account_Address__c addressToInsert3  = testData.createNewInvalidAccountAddress(false);
        
        //Test for Zip and Country is blank
        addressToInsert3.rC_Bios__Original_City__c = null;
        addressToInsert3.rC_Bios__Original_Country__c = null;
        addressToInsert3.rC_Bios__Original_Postal_Code__c = null;
        addressToInsert3.rC_Bios__Seasonal_Start_Month__c = ''+System.today().month();
        addressToInsert3.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        addressToInsert3.rC_Bios__Start_Date__c = System.today();
        addressToInsert3.rC_Bios__Seasonal_End_Month__c = ''+System.today().month();
        addressToInsert3.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        addressToInsert3.rC_Bios__End_Date__c = System.today().addDays(10);
        addressToInsert3.rC_Bios__Preferred_Billing__c = true;
        addressToInsert3.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert3.rC_Bios__Active__c = true;
        
        manageAddressCtrl.maservice.addressToInsert = addressToInsert3;
               
        //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        
        messages = ApexPages.getMessages();
        ApexPages.Message msg = messages.get(0);
        system.debug(':: Messages 22 ::'+messages);
        //system.assertEquals(msg.getDetail(), 'City field is required to validate the address');
        
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Preferred_Billing__c',true);
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Preferred_Shipping__c', true);
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Active__c', false);
        
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Original_City__c','San Francisco');
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Original_Country__c', 'USA');
        
         //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        messages = ApexPages.getMessages();
        //msg = messages.get(0);
        system.debug(':: Messages 33 ::'+messages);
        //system.assertEquals(msg.getDetail(), 'City field is required to validate the address');
        
        //test for Active address should be  Preffered
        
        sc = new ApexPages.StandardController(testAccount);
        manageAddressCtrl = new ManageAddressesExtensionKW(sc);
        
        manageAddressCtrl.maservice.addressToInsert  = testData.createNewValidAccountAddress(false);
        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.maservice.addressToInsert);  
        
        //Test for Zip and Country is blank
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Preferred_Billing__c',true);
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Preferred_Shipping__c',true);
        
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Active__c',true);
        manageAddressCtrl.upsertAccountAddressList();
        
        messages = ApexPages.getMessages();
        //msg = messages.get(1);
        system.debug(':: Messages 44 ::'+messages);
        //system.assertEquals(msg.getDetail(), 'Active Dates of Same Type of addresses are overlapping');
       
        
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Seasonal_Start_Month__c', string.valueof(System.today().addMonths(1).month()));
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Seasonal_Start_Day__c', string.valueof(System.today().day()));
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Seasonal_End_Month__c', string.valueof(System.today().addMonths(1).month()));
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Seasonal_End_Day__c', string.valueof(System.today().day()+10));
         
        manageAddressCtrl.maservice.lstAddress.get(0).rcAddress.put('rC_Bios__Original_City__c',null);
         //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        
        manageAddressCtrl.maservice.lstAddress.get(0).rcAddress.put('rC_Bios__Original_City__c','Sen');
        manageAddressCtrl.maservice.lstAddress.get(0).rcAddress.put('rC_Bios__Original_Street_Line_1__c','Test Long Name Exception Test Long Name Exception Test Long Name Exception Test Long Name Exception Test Long Name Exception');
        //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        
        manageAddressCtrl.maservice.lstAddress.get(0).rcAddress.put('rC_Bios__Original_Street_Line_1__c', 'One Market St');
        manageAddressCtrl.maservice.lstAddress.get(0).rcAddress.put('rC_Bios__Original_City__c','Test City');
        //manageAddressCtrl.lstAddress.get(1).acctAddress.rC_Bios__Original_State__c = 'Test State';
        //manageAddressCtrl.lstAddress.get(1).acctAddress.rC_Bios__Original_Country__c = 'USA';
        
        //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        messages = ApexPages.getMessages();
        //msg = messages.get(3);
        system.debug(':: Messages 163 ::'+messages);
        //Now test for Valid Address
        
        sc = new ApexPages.StandardController(testAccount);
        manageAddressCtrl = new ManageAddressesExtensionKW(sc);
        
        rC_Bios__Account_Address__c addressToInsert4  = testData.createNewInvalidAccountAddress(false);
        
        //Test for Zip and Country is blank
        addressToInsert4.rC_Bios__Original_Street_Line_1__c = '2546 S Arlington Mill Drive';
        addressToInsert4.rC_Bios__Original_Street_Line_2__c = 'Apt E';
        addressToInsert4.rC_Bios__Original_City__c = 'Arlington';
        addressToInsert4.rC_Bios__Original_State__c = 'VA';
        addressToInsert4.rC_Bios__Original_Country__c = 'USA';
        addressToInsert4.rC_Bios__Original_Postal_Code__c = '22206';
        addressToInsert4.rC_Bios__Seasonal_Start_Month__c = null;
        addressToInsert4.rC_Bios__Seasonal_Start_Day__c = null;
        addressToInsert4.rC_Bios__Start_Date__c = null;
        addressToInsert4.rC_Bios__Seasonal_End_Month__c = null;
        addressToInsert4.rC_Bios__Seasonal_End_Day__c = null;
        addressToInsert4.rC_Bios__End_Date__c = null;
        addressToInsert4.rC_Bios__Preferred_Billing__c = true;
        addressToInsert4.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert4.rC_Bios__Active__c = true;
        
        manageAddressCtrl.maservice.addressToInsert = addressToInsert4;

        kwzd.KWD_ExternalAccess_TESTS.setZDMMockData(addressToInsert4, FALSE);  
        
        test.StartTest();
        manageAddressCtrl.upsertAccountAddressList(); 
        test.StopTest();

        messages = ApexPages.getMessages();
        //msg = messages.get(3);
        system.debug(':: Messages 197 ::'+messages);
       
        //system.assertEquals(msg.getDetail(), 'Address(es) not Validated.');
        
   
    }
    
    @isTest 
    private static void testAddress2CO() {
    PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        rC_Bios__Account_Address__c addressToInsert = testData.createNewValidAccountAddress(false);
        addressToInsert.rC_Bios__Account__c = testAccount.Id;
        addressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        addressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        addressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        addressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        addressToinsert.rC_Bios__Preferred_Billing__c = true;
        addressToinsert.rC_Bios__Preferred_Shipping__c = true;
        addressToinsert.rC_Bios__Active__c = true;
       
        insert addressToInsert;
        
        system.debug(':::addressToInsert:::'+addressToInsert);
        ApexPages.currentPage().getParameters().put('id',testAccount.Id);
       
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        ManageAddressesExtensionKW manageAddressCtrl = new ManageAddressesExtensionKW(sc);

        rC_Bios__Account_Address__c addressToInsert4  = testData.createNewInvalidAccountAddress(false);
        
        //Test for Zip and Country is blank
        addressToInsert4.rC_Bios__Original_Street_Line_1__c = '2546 S Arlington Mill Drive';
        addressToInsert4.rC_Bios__Original_Street_Line_2__c = 'C/O KnowWho';
        addressToInsert4.rC_Bios__Original_City__c = 'Arlington';
        addressToInsert4.rC_Bios__Original_State__c = 'VA';
        addressToInsert4.rC_Bios__Original_Country__c = 'USA';
        addressToInsert4.rC_Bios__Original_Postal_Code__c = '22206';
        addressToInsert4.rC_Bios__Seasonal_Start_Month__c = null;
        addressToInsert4.rC_Bios__Seasonal_Start_Day__c = null;
        addressToInsert4.rC_Bios__Start_Date__c = null;
        addressToInsert4.rC_Bios__Seasonal_End_Month__c = null;
        addressToInsert4.rC_Bios__Seasonal_End_Day__c = null;
        addressToInsert4.rC_Bios__End_Date__c = null;
        addressToInsert4.rC_Bios__Preferred_Billing__c = true;
        addressToInsert4.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert4.rC_Bios__Active__c = true;
        
        manageAddressCtrl.maservice.addressToInsert = addressToInsert4;

        kwzd.KWD_ExternalAccess_TESTS.setZDMMockData(addressToInsert4, FALSE);  
        
        test.StartTest();
        manageAddressCtrl.upsertAccountAddressList(); 
        test.StopTest();

       
    }

@isTest 
    private static void testAddressZDMError() {
    PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        rC_Bios__Account_Address__c addressToInsert = testData.createNewValidAccountAddress(false);
        addressToInsert.rC_Bios__Account__c = testAccount.Id;
        addressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        addressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        addressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        addressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        addressToinsert.rC_Bios__Preferred_Billing__c = true;
        addressToinsert.rC_Bios__Preferred_Shipping__c = true;
        addressToinsert.rC_Bios__Active__c = true;
       
        insert addressToInsert;
        
        system.debug(':::addressToInsert:::'+addressToInsert);
        ApexPages.currentPage().getParameters().put('id',testAccount.Id);
       
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        ManageAddressesExtensionKW manageAddressCtrl = new ManageAddressesExtensionKW(sc);

        rC_Bios__Account_Address__c addressToInsert4  = testData.createNewInvalidAccountAddress(false);
        
        //Test for Zip and Country is blank
        addressToInsert4.rC_Bios__Original_Street_Line_1__c = '2546 S Arlington Mill Drive';
        addressToInsert4.rC_Bios__Original_Street_Line_2__c = 'C/O KnowWho';
        addressToInsert4.rC_Bios__Original_City__c = 'Arlington';
        addressToInsert4.rC_Bios__Original_State__c = 'VA';
        addressToInsert4.rC_Bios__Original_Country__c = 'USA';
        addressToInsert4.rC_Bios__Original_Postal_Code__c = '22206';
        addressToInsert4.rC_Bios__Seasonal_Start_Month__c = null;
        addressToInsert4.rC_Bios__Seasonal_Start_Day__c = null;
        addressToInsert4.rC_Bios__Start_Date__c = null;
        addressToInsert4.rC_Bios__Seasonal_End_Month__c = null;
        addressToInsert4.rC_Bios__Seasonal_End_Day__c = null;
        addressToInsert4.rC_Bios__End_Date__c = null;
        addressToInsert4.rC_Bios__Preferred_Billing__c = true;
        addressToInsert4.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert4.rC_Bios__Active__c = true;
        
        manageAddressCtrl.maservice.addressToInsert = addressToInsert4;

        kwzd.KWD_ExternalAccess_TESTS.setZDMMockData(addressToInsert4, TRUE);  
        
        test.StartTest();
        manageAddressCtrl.upsertAccountAddressList(); 
        test.StopTest();

       
    }


    @IsTest
    static void testManageAddressValidations () {  
        PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        rC_Bios__Account_Address__c addressToInsert = testData.createNewValidAccountAddress(false);
        addressToInsert.rC_Bios__Account__c = testAccount.Id;
        addressToInsert.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(1).month();
        addressToInsert.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        addressToInsert.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(1).month();
        addressToInsert.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        addressToinsert.rC_Bios__Preferred_Billing__c = true;
        addressToinsert.rC_Bios__Preferred_Shipping__c = true;
        addressToinsert.rC_Bios__Active__c = true;
        insert addressToInsert;
        system.debug(':::addressToInsert:::'+addressToInsert);
         ApexPages.currentPage().getParameters().put('id',testAccount.Id);
       
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        ManageAddressesExtensionKW manageAddressCtrl = new ManageAddressesExtensionKW(sc);
        
        rC_Bios__Account_Address__c addressToInsert2 = testData.createNewValidAccountAddress(false);
        addressToInsert2.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(-1).month();
        addressToInsert2.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day(); 
        addressToInsert2.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(-1).month();
        addressToInsert2.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        //manageAddressCtrl.upsertAccountAddressList();
        //manageAddressCtrl.maservice.queryAddress();
        addressToinsert2.rC_Bios__Seasonal_Start_Month__c = ''+System.today().addMonths(-2).month();
        addressToinsert2.rC_Bios__Seasonal_Start_Day__c = ''+System.today().day();
        addressToinsert2.rC_Bios__Seasonal_End_Month__c = ''+System.today().addMonths(-2).month();
        addressToinsert2.rC_Bios__Seasonal_End_Day__c =''+System.today().day()+10;
        addressToinsert2.rC_Bios__Preferred_Billing__c = false;
        addressToinsert2.rC_Bios__Preferred_Shipping__c = false;
        addressToinsert2.rC_Bios__Active__c = true;
       
        manageAddressCtrl.maservice.addressToInsert  = addressToinsert2;
        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.maservice.addressToInsert);  
        
         //Test for Zip and Country is blank
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Original_Country__c', null);
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Original_Postal_Code__c', null);
        manageAddressCtrl.upsertAccountAddressList();
    
        List<ApexPages.Message> messages = ApexPages.getMessages();
        //ApexPages.Message msg = messages.get(3);
        system.debug(':: Messages 88 ::'+messages);
        
        
        manageAddressCtrl.maservice.addressToInsert  = testData.createNewValidAccountAddress(false);
        system.debug('::newAccountController.accountAddress::'+manageAddressCtrl.maservice.addressToInsert);  
        
         //Test for Zip and Wrong State
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Original_Postal_Code__c', '00000');
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Original_State__c','CAT');
        manageAddressCtrl.maservice.addressToInsert.put('rC_Bios__Original_Country__c', 'USA');
        
        System.debug('::: INvalid State Code:::');
        //manageAddressCtrl.upsertAccountAddressList();
    
        messages = ApexPages.getMessages();
        //ApexPages.Message msg = messages.get(0);
        system.debug(':: Messages 99 ::'+messages);
        //system.assertEquals(msg.getDetail(), 'Please enter two letter state abbreviation');
        
        
    }

    @IsTest
    static void SavewithOverride () {  
        PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(false,'Test Acccount','Household');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        insert testAccount;

        ManageAddressesExtensionKW manageAddressCtrl = new ManageAddressesExtensionKW(new ApexPages.StandardController(testAccount));
        
        rC_Bios__Account_Address__c addressToInsert3  = testData.createNewInvalidAccountAddress(false);
        
        //Test for Zip and Country is blank
        addressToInsert3.rC_Bios__Original_City__c = 'Arlington';
        addressToInsert3.rC_Bios__Original_Country__c = null;
        addressToInsert3.rC_Bios__Original_Postal_Code__c = null;
        addressToInsert3.rC_Bios__Preferred_Billing__c = true;
        addressToInsert3.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert3.rC_Bios__Active__c = true;
        
        manageAddressCtrl.maservice.addressToInsert = addressToInsert3;
               
        //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        
        List<ApexPages.Message> messages = ApexPages.getMessages();
        ApexPages.Message msg = messages.get(0);
        system.debug(':: Messages 22 ::'+messages);
        
        //Now override
        manageAddressCtrl.maservice.isOverride = TRUE;
        manageAddressCtrl.upsertAccountAddressList();
        

        rC_Bios__Account_Address__c addressToConfirm = [Select Id FROM rC_Bios__Account_Address__c];
        system.debug(addressToConfirm);

        
        manageAddressCtrl = new ManageAddressesExtensionKW(new ApexPages.StandardController(testAccount));
        
        addressToInsert3  = testData.createNewInvalidAccountAddress(false);
        
        //Test for Zip and Country is blank
        addressToInsert3.rC_Bios__Original_City__c = 'Spalding';
        addressToInsert3.rC_Bios__Original_Country__c = 'UK';
        addressToInsert3.rC_Bios__Original_Postal_Code__c = null;
        addressToInsert3.rC_Bios__Preferred_Billing__c = true;
        addressToInsert3.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert3.rC_Bios__Active__c = true;
        
        manageAddressCtrl.maservice.addressToInsert = addressToInsert3;
               
        //Save Address With International Address
        manageAddressCtrl.upsertAccountAddressList();
        
        addressToConfirm = [Select Id FROM rC_Bios__Account_Address__c];
        system.debug(addressToConfirm);

    }



    @IsTest
    static void UpdateExistingAddress () {  
        /*
        kwzd.KWD_ExternalAccess_TESTS.setZDMSetupData();

        kwzd__ZDMCustomObjectLookup__c zdmobject = new kwzd__ZDMCustomObjectLookup__c();
        zdmobject.Name = 'rC_Bios__Account_Address__c';
        zdmobject.kwzd__Alias__c = 'RCAA';
        zdmobject.kwzd__Namespace__c = 'kwrc__';
        insert zdmobject;
        
        List<kwzd__ZDM_Settings__c> zdmsettings = new List<kwzd__ZDM_Settings__c>();
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAStreet', kwzd__Field_Name__c = 'rC_Bios__Original_Street_Line_1__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAStreet2', kwzd__Field_Name__c = 'rC_Bios__Original_Street_Line_2__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAACity', kwzd__Field_Name__c = 'rC_Bios__Original_City__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAState', kwzd__Field_Name__c = 'rC_Bios__Original_State__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAZip', kwzd__Field_Name__c = 'rC_Bios__Original_Postal_Code__c'));
        insert zdmsettings;
        */

        PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(false,'Test Acccount','Household');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        insert testAccount;

        rC_Bios__Account_Address__c addressToInsert4  = testData.createNewInvalidAccountAddress(false);
        
        //Test for Zip and Country is blank
        addressToInsert4.rC_Bios__Original_Street_Line_1__c = '2546 S Arlington Mill Drive';
        addressToInsert4.rC_Bios__Original_City__c = 'Arlington';
        addressToInsert4.rC_Bios__Original_State__c = 'VA';
        addressToInsert4.rC_Bios__Original_Country__c = 'USA';
        addressToInsert4.rC_Bios__Original_Postal_Code__c = '22206';
        addressToInsert4.rC_Bios__Seasonal_Start_Month__c = null;
        addressToInsert4.rC_Bios__Seasonal_Start_Day__c = null;
        addressToInsert4.rC_Bios__Start_Date__c = null;
        addressToInsert4.rC_Bios__Seasonal_End_Month__c = null;
        addressToInsert4.rC_Bios__Seasonal_End_Day__c = null;
        addressToInsert4.rC_Bios__End_Date__c = null;
        addressToInsert4.rC_Bios__Preferred_Billing__c = true;
        addressToInsert4.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert4.rC_Bios__Active__c = true;
        addressToInsert4.rC_Bios__Account__c = testAccount.Id;
        insert addressToInsert4;

        rC_Bios__Account_Address__c addressToInsert5  = testData.createNewValidAccountAddress(false);
        
        //Test for Zip and Country is blank
        addressToInsert5.rC_Bios__Original_Street_Line_1__c = '2546 S Arlington Mill Drive';
        addressToInsert5.rC_Bios__Original_City__c = 'Arlington';
        addressToInsert5.rC_Bios__Original_State__c = 'VA';
        addressToInsert5.rC_Bios__Original_Country__c = 'USA';
        addressToInsert5.rC_Bios__Original_Postal_Code__c = '22206';
        addressToInsert5.rC_Bios__Seasonal_Start_Month__c = null;
        addressToInsert5.rC_Bios__Seasonal_Start_Day__c = null;
        addressToInsert5.rC_Bios__Start_Date__c = null;
        addressToInsert5.rC_Bios__Seasonal_End_Month__c = null;
        addressToInsert5.rC_Bios__Seasonal_End_Day__c = null;
        addressToInsert5.rC_Bios__End_Date__c = null;
        addressToInsert5.rC_Bios__Preferred_Billing__c = true;
        addressToInsert5.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert5.rC_Bios__Active__c = true;
        
        ManageAddressesExtensionKW manageAddressCtrl = new ManageAddressesExtensionKW(new ApexPages.StandardController(testAccount));
        manageAddressCtrl.maservice.addressToInsert = addressToInsert5;

        ManageAddressService.AddressWrapper testwrap = manageAddressCtrl.maservice.lstAddress[0];
        system.debug(testwrap.rcAddress);   
        testwrap.rcAddress.put('rC_Bios__Original_City__c','Bedford');
        testwrap.rcAddress.put('rC_Bios__Original_Postal_Code__c','23456');
        
        kwzd.KWD_ExternalAccess_TESTS.setZDMMockData(testwrap.rcAddress, FALSE);  
        
        test.StartTest();       
        //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        test.stoptest();

        rC_Bios__Account_Address__c addressToConfirm = [Select Id FROM rC_Bios__Account_Address__c];
        system.debug(addressToConfirm);

    }

    @IsTest
    static void TestDateOverlapsSameType () {  
        /*
        kwzd.KWD_ExternalAccess_TESTS.setZDMSetupData();

        kwzd__ZDMCustomObjectLookup__c zdmobject = new kwzd__ZDMCustomObjectLookup__c();
        zdmobject.Name = 'rC_Bios__Account_Address__c';
        zdmobject.kwzd__Alias__c = 'RCAA';
        zdmobject.kwzd__Namespace__c = 'kwrc__';
        insert zdmobject;
        
        List<kwzd__ZDM_Settings__c> zdmsettings = new List<kwzd__ZDM_Settings__c>();
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAStreet', kwzd__Field_Name__c = 'rC_Bios__Original_Street_Line_1__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAStreet2', kwzd__Field_Name__c = 'rC_Bios__Original_Street_Line_2__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAACity', kwzd__Field_Name__c = 'rC_Bios__Original_City__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAState', kwzd__Field_Name__c = 'rC_Bios__Original_State__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAZip', kwzd__Field_Name__c = 'rC_Bios__Original_Postal_Code__c'));
        insert zdmsettings;
        */

        PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(false,'Test Acccount','Household');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        insert testAccount;

        rC_Bios__Account_Address__c addressToInsert4  = testData.createNewInvalidAccountAddress(false);
        
        //Test for Zip and Country is blank
        addressToInsert4.rC_Bios__Original_Street_Line_1__c = '2546 S Arlington Mill Drive';
        addressToInsert4.rC_Bios__Original_City__c = 'Arlington';
        addressToInsert4.rC_Bios__Original_State__c = 'VA';
        addressToInsert4.rC_Bios__Original_Country__c = 'USA';
        addressToInsert4.rC_Bios__Original_Postal_Code__c = '22206';
        addressToInsert4.rC_Bios__Seasonal_Start_Month__c = '1';
        addressToInsert4.rC_Bios__Seasonal_Start_Day__c = '1';
        addressToInsert4.rC_Bios__Start_Date__c = system.today();
        addressToInsert4.rC_Bios__Seasonal_End_Month__c = '12';
        addressToInsert4.rC_Bios__Seasonal_End_Day__c = '31';
        addressToInsert4.rC_Bios__End_Date__c = system.today().adddays(365);
        addressToInsert4.rC_Bios__Preferred_Billing__c = true;
        addressToInsert4.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert4.rC_Bios__Active__c = true;
        addressToInsert4.rC_Bios__Account__c = testAccount.Id;
        addressToInsert4.rC_Bios__Type__c = 'Business';
        insert addressToInsert4;

        rC_Bios__Account_Address__c addressToInsert5  = testData.createNewValidAccountAddress(false);
        
        
        addressToInsert5.rC_Bios__Original_Street_Line_1__c = '2544 S Arlington Mill Drive';
        addressToInsert5.rC_Bios__Original_City__c = 'Arlington';
        addressToInsert5.rC_Bios__Original_State__c = 'VA';
        addressToInsert5.rC_Bios__Original_Country__c = 'USA';
        addressToInsert5.rC_Bios__Original_Postal_Code__c = '22206';
        addressToInsert5.rC_Bios__Seasonal_Start_Month__c = '1';
        addressToInsert5.rC_Bios__Seasonal_Start_Day__c = '1';
        addressToInsert5.rC_Bios__Start_Date__c = system.today();
        addressToInsert5.rC_Bios__Seasonal_End_Month__c = '12';
        addressToInsert5.rC_Bios__Seasonal_End_Day__c = '31';
        addressToInsert5.rC_Bios__End_Date__c = system.today().adddays(365);
        addressToInsert5.rC_Bios__Preferred_Billing__c = true;
        addressToInsert5.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert5.rC_Bios__Active__c = true;
        addressToInsert5.rC_Bios__Type__c = 'Business';

        ManageAddressesExtensionKW manageAddressCtrl = new ManageAddressesExtensionKW(new ApexPages.StandardController(testAccount));
        manageAddressCtrl.maservice.addressToInsert = addressToInsert5;

        ManageAddressService.AddressWrapper testwrap = manageAddressCtrl.maservice.lstAddress[0];
        
        kwzd.KWD_ExternalAccess_TESTS.setZDMMockData(testwrap.rcAddress, FALSE);  
        
        test.StartTest();       
        //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        List<ApexPages.Message> messages = ApexPages.getMessages();
        ApexPages.Message msg = messages.get(0);
        system.debug(':: Messages 500 ::'+messages);
        
        test.stoptest();

       
    }

    @IsTest
    static void TestDateOverlapsSamePreference () {  
        /*
        kwzd.KWD_ExternalAccess_TESTS.setZDMSetupData();

        kwzd__ZDMCustomObjectLookup__c zdmobject = new kwzd__ZDMCustomObjectLookup__c();
        zdmobject.Name = 'rC_Bios__Account_Address__c';
        zdmobject.kwzd__Alias__c = 'RCAA';
        zdmobject.kwzd__Namespace__c = 'kwrc__';
        insert zdmobject;
        
        List<kwzd__ZDM_Settings__c> zdmsettings = new List<kwzd__ZDM_Settings__c>();
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAStreet', kwzd__Field_Name__c = 'rC_Bios__Original_Street_Line_1__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAStreet2', kwzd__Field_Name__c = 'rC_Bios__Original_Street_Line_2__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAACity', kwzd__Field_Name__c = 'rC_Bios__Original_City__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAState', kwzd__Field_Name__c = 'rC_Bios__Original_State__c'));
        zdmsettings.add(new kwzd__ZDM_Settings__c(Name = 'RCAAZip', kwzd__Field_Name__c = 'rC_Bios__Original_Postal_Code__c'));
        insert zdmsettings;
        */

        PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(false,'Test Acccount','Household');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        insert testAccount;

        rC_Bios__Account_Address__c addressToInsert4  = testData.createNewInvalidAccountAddress(false);
        
        //Test for Zip and Country is blank
        addressToInsert4.rC_Bios__Original_Street_Line_1__c = '2546 S Arlington Mill Drive';
        addressToInsert4.rC_Bios__Original_City__c = 'Arlington';
        addressToInsert4.rC_Bios__Original_State__c = 'VA';
        addressToInsert4.rC_Bios__Original_Country__c = 'USA';
        addressToInsert4.rC_Bios__Original_Postal_Code__c = '22206';
        addressToInsert4.rC_Bios__Seasonal_Start_Month__c = '1';
        addressToInsert4.rC_Bios__Seasonal_Start_Day__c = '1';
        addressToInsert4.rC_Bios__Start_Date__c = system.today();
        addressToInsert4.rC_Bios__Seasonal_End_Month__c = '12';
        addressToInsert4.rC_Bios__Seasonal_End_Day__c = '31';
        addressToInsert4.rC_Bios__End_Date__c = system.today().adddays(365);
        addressToInsert4.rC_Bios__Preferred_Billing__c = true;
        addressToInsert4.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert4.rC_Bios__Active__c = true;
        addressToInsert4.rC_Bios__Account__c = testAccount.Id;
        addressToInsert4.rC_Bios__Type__c = 'Business';
        insert addressToInsert4;

        rC_Bios__Account_Address__c addressToInsert5  = testData.createNewValidAccountAddress(false);
        
        
        addressToInsert5.rC_Bios__Original_Street_Line_1__c = '2544 S Arlington Mill Drive';
        addressToInsert5.rC_Bios__Original_City__c = 'Arlington';
        addressToInsert5.rC_Bios__Original_State__c = 'VA';
        addressToInsert5.rC_Bios__Original_Country__c = 'USA';
        addressToInsert5.rC_Bios__Original_Postal_Code__c = '22206';
        addressToInsert5.rC_Bios__Seasonal_Start_Month__c = '1';
        addressToInsert5.rC_Bios__Seasonal_Start_Day__c = '1';
        addressToInsert5.rC_Bios__Start_Date__c = system.today();
        addressToInsert5.rC_Bios__Seasonal_End_Month__c = '12';
        addressToInsert5.rC_Bios__Seasonal_End_Day__c = '31';
        addressToInsert5.rC_Bios__End_Date__c = system.today().adddays(365);
        addressToInsert5.rC_Bios__Preferred_Billing__c = true;
        addressToInsert5.rC_Bios__Preferred_Shipping__c = true;
        addressToInsert5.rC_Bios__Active__c = true;
        addressToInsert5.rC_Bios__Type__c = 'Home';

        ManageAddressesExtensionKW manageAddressCtrl = new ManageAddressesExtensionKW(new ApexPages.StandardController(testAccount));
        manageAddressCtrl.maservice.addressToInsert = addressToInsert5;

        ManageAddressService.AddressWrapper testwrap = manageAddressCtrl.maservice.lstAddress[0];
        
        kwzd.KWD_ExternalAccess_TESTS.setZDMMockData(testwrap.rcAddress, FALSE);  
        
        test.StartTest();       
        //Save Address With invalid Valid Address
        manageAddressCtrl.upsertAccountAddressList();
        List<ApexPages.Message> messages = ApexPages.getMessages();
        ApexPages.Message msg = messages.get(0);
        system.debug(':: Messages 500 ::'+messages);
        
        //Change to just overlap on shipping
        addressToInsert5.rC_Bios__Preferred_Billing__c = false;
        manageAddressCtrl.upsertAccountAddressList();
        messages = ApexPages.getMessages();
        msg = messages.get(0);
        system.debug(':: Messages 595 ::'+messages);
        
        addressToInsert4.rC_Bios__Preferred_Billing__c = false;
        addressToInsert5.rC_Bios__Preferred_Billing__c = false;

        manageAddressCtrl.upsertAccountAddressList();
        messages = ApexPages.getMessages();
        msg = messages.get(0);
        system.debug(':: Messages 602 ::'+messages);


        test.stoptest();

       
    }

}