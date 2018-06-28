@isTest
private class NewAccountExtensionCampSearchTest {
    //*********************************************************************
// (c) 2014 Appirio, Inc.
//
//  Test Class for NewAccountExtensionKW 
//  23 April 2015     Peter Churchill  
//**********************************************************************/
    

@isTest
    private static void TestValidAddressbadContact() {
        //Setup Required data for KnoWho ZDM Mock Service
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

        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(false,'Test AccountCon2','Household');
        NewAccountExtensionCampSearch newAccountController = new NewAccountExtensionCampSearch(new ApexPages.StandardController(testAccount));
         //Populate Account Address with Valid Address
        newAccountController.accountAddress = testData.createNewValidAccountAddress(false);
   
        newAccountController.accountAddress.rC_Bios__Original_State__c = 'AT';
        Contact contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Contact__c = true;
        contact1.rC_Bios__Preferred_Phone__c = 'Home';
        contact1.rC_Bios__Work_Phone__c = '1312312';
        contact1.rC_Bios__Preferred_Email__c = 'Home';
        contact1.rC_Bios__Home_Email__c = 'Hometest32321@mymail.com'; 
        contact1.Private_Email__c = 'Private123@mymail.com'; 
        contact1.Club_FullName__c = 'Test Club Sal';
       // Create 2 Contact for houseHold with preferred true on both
        newAccountController.noOfContacts =2;
        newAccountController.contactsToCreate();
       
        Contact contact2 = newAccountController.contactList.get(1);
        contact2.firstName = 'Test First';
        contact2.lastName = 'Test Last';
        contact2.rC_Bios__Preferred_Contact__c = false;
        contact2.rC_Bios__Preferred_Phone__c = 'Home';
        contact2.rC_Bios__Work_Phone__c = '1312312';
        contact2.rC_Bios__Preferred_Email__c = 'Home';
        contact2.rC_Bios__Home_Email__c = 'Hometest2222@myma22il.com'; 
        contact2.Private_Email__c = 'Private123@mymail.com'; 
        contact2.Club_FullName__c = 'Test Club Sal';

        //Populate mock data response
        kwzd.KWD_ExternalAccess_TESTS.setZDMMockData(newAccountController.accountAddress, FALSE);  
        test.StartTest();
        newAccountController.saveAccount();
        test.StopTest();

        rC_Bios__Account_Address__c testconfirm = [Select Id, kwrc__Elected_Officials_Ids__c, kwrc__KW_StateHouseDistrict__c, kwrc__KW_USHouseDistrict__c, kwrc__USPS_Street__c FROM rC_Bios__Account_Address__c];
        system.assertequals('KWTFSO1;KWTFSO2;KWTFHO1;KWTSTO1;KWTSTHO1;KWTLOCO1', testconfirm.kwrc__Elected_Officials_Ids__c);
        system.assertequals('VA045', testconfirm.kwrc__KW_StateHouseDistrict__c);
        system.assertequals('VA08', testconfirm.kwrc__KW_USHouseDistrict__c);
        
        Contact cConfirm = [Select Id, MailingStreet, MailingPostalCode,kwzd__Elected_Officials_Ids__c, kwzd__KWD_Encrypted_Action_Id__c, rC_Connect__Public_Token__c FROM Contact WHERE Id = :contact1.Id];
        system.assertequals('KWTFSO1;KWTFSO2;KWTFHO1;KWTSTO1;KWTSTHO1;KWTLOCO1', cConfirm.kwzd__Elected_Officials_Ids__c);
        system.assertnotequals(NULL, cConfirm.rC_Connect__Public_Token__c);
        system.assertnotequals(NULL, cConfirm.kwzd__KWD_Encrypted_Action_Id__c);
        
    }

@isTest
    private static void TestValidAddressWithRollback() {
        //Setup Required data for KnoWho ZDM Mock Service
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

        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(false,'Test AccountCon2','Household');
        NewAccountExtensionCampSearch newAccountController = new NewAccountExtensionCampSearch(new ApexPages.StandardController(testAccount));
         //Populate Account Address with Valid Address
        newAccountController.accountAddress = testData.createNewValidAccountAddress(false);
   
        newAccountController.accountAddress.rC_Bios__Original_State__c = 'AT';
        Contact contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Contact__c = true;
        contact1.rC_Bios__Preferred_Phone__c = 'Home';
        contact1.rC_Bios__Work_Phone__c = '1312312';
        contact1.rC_Bios__Preferred_Email__c = 'Home';
        contact1.rC_Bios__Home_Email__c = 'Hometest32321@mymail.com'; 
        contact1.Private_Email__c = 'Private123@mymail.com'; 
        contact1.Club_FullName__c = 'Test Club Sal';
       // Create 2 Contact for houseHold with preferred true on both
        newAccountController.noOfContacts = 2;
        newAccountController.contactsToCreate();
        
        Contact contact2 = newAccountController.contactList.get(1);
        contact2.firstName = 'Test First';
        contact2.lastName = 'Test Last';
        contact2.rC_Bios__Preferred_Contact__c = true;
        contact2.rC_Bios__Preferred_Phone__c = 'Home';
        contact2.rC_Bios__Work_Phone__c = '1312312';
        contact2.rC_Bios__Preferred_Email__c = 'Home';
        //Use same to trigger rollback
        contact2.rC_Bios__Home_Email__c = 'Hometest 32321@mymail.com'; 
        contact2.Private_Email__c = 'Private123 @mymail.com'; 
        contact2.Club_FullName__c = 'Test Club Sal';

        //Populate mock data response
        kwzd.KWD_ExternalAccess_TESTS.setZDMMockData(newAccountController.accountAddress, FALSE);  
        test.StartTest();
            newAccountController.saveAccount();
        test.StopTest();

        
    }

@isTest
    static void testForHouseHold() {
        PageReference prPageLink = Page.NewAccount;
        test.setCurrentPage(prPageLink);
        TestDataUtility testData = new TestDataUtility();
        Id houseHoldRecordTypeId = testData.getAccountRecordTypeId('Household');
        
        Account testAccount = testData.createNewAccount(false,'Test Account1','Household');
        system.debug('Test Account Record Type ::'+testAccount.RecordTypeId);
        
        ApexPages.currentPage().getParameters().put('RecordType',houseHoldRecordTypeId);
        ApexPages.currentPage().getParameters().put('save_new','1');
        ApexPages.currentPage().getParameters().put('sfdc.override','1');
        ApexPages.currentPage().getParameters().put('ent','Account');
      
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        NewAccountExtensionCampSearch newAccountController = new NewAccountExtensionCampSearch(sc);
        
        //Save Address With Valid Address
        newAccountController.saveAccount();
        //HouseHold Account required Atleast One Contact with address
        System.assertEquals(ApexPages.hasMessages(), true);
        List<Apexpages.Message> messages = ApexPages.getMessages();
        Apexpages.Message msg = messages.get(0);
        system.debug(':: Messages 11  ::'+messages);
        System.assertEquals(msg.getDetail(),'Required fields are missing: [First Name]');
        
        Contact contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Phone__c = 'Work';
        contact1.rC_Bios__Work_Phone__c = '1234234';
        contact1.Club_FullName__c = 'Test Club Sal';
        //Test At least one of contact is specified as the preferred contact.
        contact1.rC_Bios__Preferred_Contact__c = false;
        
         //Save HouseHold Account with Valid Address and One Contact
        newAccountController.saveAccount();
        messages = ApexPages.getMessages();
        msg = messages.get(1);
        system.debug(':: Messages 22 ::'+messages);
        System.assertEquals(msg.getDetail(),'At least one of contact is specified as the preferred contact.');
        
         //Mark  contact  as the preferred contact.
        contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Contact__c = true;
        contact1.Club_FullName__c = 'Test Club Sal';
        //Test Without preferred Contact
        contact1.rC_Bios__Preferred_Phone__c = null;
        contact1.rC_Bios__Work_Phone__c = null;
       
        messages = ApexPages.getMessages();
        msg = messages.get(1);
        system.debug(':: Messages 33 ::'+messages);
        newAccountController.saveAccount();
        
        
        contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Contact__c = true;
        contact1.rC_Bios__Preferred_Phone__c = 'Home';
        contact1.rC_Bios__Preferred_Email__c = 'Home';
        contact1.Club_FullName__c = 'Test Club Sal';
        
        newAccountController.saveAccount();
        
        
        messages = ApexPages.getMessages();
        msg = messages.get(2);
        system.debug(':: Messages 44 ::'+messages);
        newAccountController.saveAccount();
        
        System.assertEquals(msg.getDetail(),'Account record must have at least 1 method of contact (Either Full Postal Address or Email/Phone on Preferred Contact)');
        
        
        contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Contact__c = true;
        contact1.rC_Bios__Preferred_Phone__c = 'Home';
        contact1.rC_Bios__Work_Phone__c = '1312312';
        contact1.rC_Bios__Preferred_Email__c = 'Home';
        contact1.rC_Bios__Home_Email__c = 'Hometest323@mymail.com';
        contact1.Club_FullName__c = 'Test Club Sal';
        
        newAccountController.saveAccount();
     }


    @isTest
    static void testForHouseHoldSuccess() {
        TestDataUtility testData = new TestDataUtility();
         //Setup Required data for KnoWho ZDM Mock Service
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

        Account testAccount = testData.createNewAccount(false,'Test AccountCon2','Household');
        NewAccountExtensionCampSearch newAccountController = new NewAccountExtensionCampSearch(new ApexPages.StandardController(testAccount));
         //Populate Account Address with Valid Address
        newAccountController.accountAddress = testData.createNewValidAccountAddress(false);
   
        Contact contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Contact__c = true;
        contact1.rC_Bios__Preferred_Phone__c = 'Home';
        contact1.rC_Bios__Work_Phone__c = '1312312';
        contact1.rC_Bios__Preferred_Email__c = 'Home';
        contact1.rC_Bios__Home_Email__c = 'Hometest32321@mymail.com'; 
        contact1.Private_Email__c = 'Private123@mymail.com'; 
        contact1.Club_FullName__c = 'Test Club Sal';
        
        kwzd.KWD_ExternalAccess_TESTS.setZDMMockData(newAccountController.accountAddress, FALSE);  
        test.StartTest();
            newAccountController.saveAccount();
        test.Stoptest();
       }
    
@isTest
        static void testForOrganizationAccount() {
        PageReference prPageLink = Page.NewAccount;
        test.setCurrentPage(prPageLink);
        TestDataUtility testData = new TestDataUtility();
        Id organizationRecordTypeId = testData.getAccountRecordTypeId('Organization');
        
           /*
        *  Now Test for Organization type account
        */
        Account testOrganizationAccount = testData.createNewAccount(false,'Test Account2','Organization');
        system.debug('Organization Account Record Type ::'+testOrganizationAccount.RecordTypeId);
       
        ApexPages.currentPage().getParameters().put('RecordType',organizationRecordTypeId);
        ApexPages.currentPage().getParameters().put('save_new','1');
        ApexPages.currentPage().getParameters().put('sfdc.override','1');
        ApexPages.currentPage().getParameters().put('ent','Account');
      
        ApexPages.StandardController sc = new ApexPages.StandardController(testOrganizationAccount);
        NewAccountExtensionCampSearch newAccountController = new NewAccountExtensionCampSearch(sc);
        
         //Populate Account Address with Valid Address
        newAccountController.accountAddress = testData.createNewInvalidAccountAddress(false);
        newAccountController.accountAddress.rC_Bios__Original_State__c = 'CA';
        newAccountController.saveAccount();
        
        List<ApexPages.Message> messages = ApexPages.getMessages();
        system.debug(':: Messages 99 ::'+messages);
        
        
        Account testOrganizationAccount1 = testData.createNewAccount(false,'Test Account3','Organization');
        sc = new ApexPages.StandardController(testOrganizationAccount1);
        newAccountController = new NewAccountExtensionCampSearch(sc);
        
         //Populate Account Address with Valid Address
        newAccountController.accountAddress = testData.createNewValidAccountAddress(false);
        // Create 2 Contact for houseHold with preferred true on both
        newAccountController.noOfContacts =2;
        newAccountController.contactsToCreate();
       
        Contact contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Contact__c = true;
        contact1.rC_Bios__Preferred_Phone__c = 'Home';
        contact1.rC_Bios__Work_Phone__c = '1312312';
        contact1.rC_Bios__Preferred_Email__c = 'Home';
        contact1.rC_Bios__Home_Email__c = 'Hometest32321@mymail.com'; 
        contact1.Private_Email__c = 'Private123@mymail.com'; 
        contact1.Club_FullName__c = 'Test Club Sal';
       // Create 2 Contact for houseHold with preferred true on both
        newAccountController.noOfContacts =2;
        newAccountController.contactsToCreate();
       
        Contact contact2 = newAccountController.contactList.get(1);
        contact2.firstName = 'Test First';
        contact2.lastName = 'Test Last';
        contact2.rC_Bios__Preferred_Contact__c = true;
        contact2.rC_Bios__Preferred_Phone__c = 'Home';
        contact2.rC_Bios__Work_Phone__c = '1312312';
        contact2.rC_Bios__Preferred_Email__c = 'Home';
        contact2.rC_Bios__Home_Email__c = 'Hometest32321@mymail.com'; 
        contact2.Club_FullName__c = 'Test Club Sal';
        newAccountController.saveAccount();
        
        messages = ApexPages.getMessages();
        system.debug(':: Messages 10 ::'+messages);
        
        
        contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Contact__c = true;
        contact1.rC_Bios__Preferred_Phone__c = 'Home';
        contact1.rC_Bios__Work_Phone__c = '1312312';
        contact1.rC_Bios__Preferred_Email__c = 'Work';
        contact1.rC_Bios__Work_Email__c = 'Hometest32321@mymail.com'; 
        contact1.Private_Email__c = 'Private123@mymail.com'; 
        contact1.Club_FullName__c = 'Test Club Sal';
       // Create 2 Contact for houseHold with preferred true on both
        newAccountController.noOfContacts =2;
        newAccountController.contactsToCreate();
       
        contact2 = newAccountController.contactList.get(1);
        contact2.firstName = 'Test First';
        contact2.lastName = 'Test Last';
        contact2.rC_Bios__Preferred_Contact__c = true;
        contact2.rC_Bios__Preferred_Phone__c = 'Home';
        contact2.rC_Bios__Work_Phone__c = '1312312';
        contact2.rC_Bios__Preferred_Email__c = 'Work';
        contact2.rC_Bios__Work_Email__c = 'Hometest32321@mymail.com';
        contact2.Club_FullName__c = 'Test Club Sal'; 
        
        newAccountController.saveAccount();
        
        messages = ApexPages.getMessages();
        system.debug(':: Messages 11 ::'+messages);
        
        contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Contact__c = true;
        contact1.rC_Bios__Preferred_Phone__c = 'Home';
        contact1.rC_Bios__Work_Phone__c = '1312312';
        contact1.rC_Bios__Preferred_Email__c = 'Assistant';
        contact1.rC_Bios__Assistant_Email__c = 'Hometest32321A@mymail.com'; 
        contact1.Private_Email__c = 'Private123@mymail.com'; 
        contact1.Club_FullName__c = 'Test Club Sal';
       // Create 2 Contact for houseHold with preferred true on both
        newAccountController.noOfContacts =2;
        newAccountController.contactsToCreate();
       
        contact2 = newAccountController.contactList.get(1);
        contact2.firstName = 'Test First';
        contact2.lastName = 'Test Last';
        contact2.rC_Bios__Preferred_Contact__c = true;
        contact2.rC_Bios__Preferred_Phone__c = 'Home';
        contact2.rC_Bios__Work_Phone__c = '1312312';
        contact2.rC_Bios__Preferred_Email__c = 'Assistant';
        contact2.rC_Bios__Assistant_Email__c = 'Hometest32321A@mymail.com'; 
        contact2.Club_FullName__c = 'Test Club Sal';
        newAccountController.saveAccount();
        
        messages = ApexPages.getMessages();
        system.debug(':: Messages 12 ::'+messages);
        
        contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Contact__c = true;
        contact1.rC_Bios__Preferred_Phone__c = 'Home';
        contact1.rC_Bios__Work_Phone__c = '1312312';
        contact1.rC_Bios__Preferred_Email__c = 'Other';
        contact1.rC_Bios__Other_Email__c = 'Hometest32321A@mymail.com'; 
        contact1.Private_Email__c = 'Private123@mymail.com'; 
        contact1.Club_FullName__c = 'Test Club Sal';
       // Create 2 Contact for houseHold with preferred true on both
        newAccountController.noOfContacts =2;
        newAccountController.contactsToCreate();
       
        contact2 = newAccountController.contactList.get(1);
        contact2.firstName = 'Test First';
        contact2.lastName = 'Test Last';
        contact2.rC_Bios__Preferred_Contact__c = true;
        contact2.rC_Bios__Preferred_Phone__c = 'Home';
        contact2.rC_Bios__Work_Phone__c = '1312312';
        contact2.rC_Bios__Preferred_Email__c = 'Other';
        contact2.rC_Bios__Other_Email__c = 'Hometest32321A@mymail.com'; 
        contact2.Club_FullName__c = 'Test Club Sal';
        newAccountController.saveAccount();
        
        messages = ApexPages.getMessages();
        system.debug(':: Messages 12 ::'+messages);
               
    }

@isTest
        static void testPageReferences() {
            PageReference prPageLink = Page.NewAccount;
            test.setCurrentPage(prPageLink);
            TestDataUtility testData = new TestDataUtility();
            Id organizationRecordTypeId = testData.getAccountRecordTypeId('Organization');
          
            Account testOrganizationAccount = testData.createNewAccount(false,'Test Account2','Organization');
            system.debug('Organization Account Record Type ::'+testOrganizationAccount.RecordTypeId);
           
            ApexPages.currentPage().getParameters().put('RecordType',organizationRecordTypeId);
            ApexPages.currentPage().getParameters().put('save_new','1');
            ApexPages.currentPage().getParameters().put('sfdc.override','1');
            ApexPages.currentPage().getParameters().put('ent','Account');
          
            ApexPages.StandardController sc = new ApexPages.StandardController(testOrganizationAccount);
            NewAccountExtensionCampSearch newAccountController = new NewAccountExtensionCampSearch(sc);
            newAccountController.updatePreferred();
            newAccountController.cancelNewAccount();
            
            newAccountController.acceptDups();
            newAccountController.acceptAccountDups();
            newAccountController.getHasDups();
            newAccountController.getHasDupAccounts();
            
        }
@isTest
	static void testCampaignSearchController() {
        TestDataUtility testData = new TestDataUtility();
        Id organizationRecordTypeId = testData.getAccountRecordTypeId('Organization');
        Account testOrganizationAccount = testData.createNewAccount(false,'Test Account2','Organization');
        ApexPages.StandardController sc = new ApexPages.StandardController(testOrganizationAccount);

		CampaignSearchController controller = new CampaignSearchController();
        NewAccountExtensionCampSearch newAccountController = new NewAccountExtensionCampSearch(sc);
		newAccountController.setCampSearchController(controller);
		System.assertEquals(controller, newAccountController.getCampSearchController());
		System.assertEquals(newAccountController, newAccountController.getThis());
		Campaign camp = new Campaign();
		newAccountController.setSelectedCampaign(camp);
	}
}