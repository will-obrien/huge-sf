//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//  Test Class for NewAccountExtension 
//  7 March 2014     Virendra (Appirio)  
//**********************************************************************/
@isTest
private class   NewAccountExtensionTest {
/*    
    static testMethod void testForHouseHold() {
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
        NewAccountExtension newAccountController = new NewAccountExtension(sc);
        
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
        
        System.assertEquals(msg.getDetail(),'Account record must have at least 1 method of contact (Either Postal Address or Email/Phone on Preferred Contact)');
        
        
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
        
        //Now Test for Invalid Address
        
        testAccount = testData.createNewAccount(false,'Test Account2','Household');
        sc = new ApexPages.StandardController(testAccount);
        newAccountController = new NewAccountExtension(sc);
         //Populate Account Address with Valid Address
        newAccountController.accountAddress = testData.createNewInvalidAccountAddress(false);
        system.debug('::newAccountController.accountAddress::'+newAccountController.accountAddress);  
        
        //Test for Zip and Country is blank
        newAccountController.accountAddress.rC_Bios__Original_City__c = null;
        newAccountController.accountAddress.rC_Bios__Original_Country__c = null;
        newAccountController.accountAddress.rC_Bios__Original_Postal_Code__c = null;
        //Save Address With invalid Valid Address
        newAccountController.saveAccount();
        
        messages = ApexPages.getMessages();
        msg = messages.get(3);
        system.debug(':: Messages 55 ::'+messages);
        System.assertEquals(msg.getDetail(),'Street 1, City and State can not be left blank. Either remove all of these');
    
        newAccountController.accountAddress.rC_Bios__Original_City__c = 'San Francisco';
        newAccountController.accountAddress.rC_Bios__Original_Country__c = 'USA';
        //Save Address Without postal code
        newAccountController.saveAccount();
        
    
        testAccount = testData.createNewAccount(false,'Test AccountCon5','Household');
        sc = new ApexPages.StandardController(testAccount);
        newAccountController = new NewAccountExtension(sc);
       
        newAccountController.accountAddress = testData.createNewValidAccountAddress(false);
         //Save Address With Valid Address
        newAccountController.isInvalidTestAddress = true;
        contact1 = newAccountController.contactList.get(0);
        contact1.firstName = 'Test First';
        contact1.lastName = 'Test Last';
        contact1.rC_Bios__Preferred_Contact__c = true;
        contact1.rC_Bios__Preferred_Phone__c = 'Home';
        contact1.rC_Bios__Work_Phone__c = '1312312';
        contact1.rC_Bios__Preferred_Email__c = 'Home';
        contact1.rC_Bios__Home_Email__c = 'Hometest3232112@mymail.com';
        contact1.Club_FullName__c = 'Test Club Sal'; 
        newAccountController.saveAccount();
        
        messages = ApexPages.getMessages();
        msg = messages.get(4);
        system.debug(':: Messages 66 ::'+messages);
        System.assertEquals(msg.getDetail(),'Not a valid Address Please check Override to use this');
        System.assertEquals(newAccountController.isOverride, false);
        System.assertEquals(newAccountController.showOverride, true);
       
       //Override Invalid Address and use to save 
        newAccountController.isOverride = true;
        newAccountController.saveAccount();
        
        
        
        //Now Test for Valid Address
        
        testAccount = testData.createNewAccount(false,'Test AccountCon2','Household');
        sc = new ApexPages.StandardController(testAccount);
        newAccountController = new NewAccountExtension(sc);
         //Populate Account Address with Valid Address
        newAccountController.accountAddress = testData.createNewValidAccountAddress(false);
   
        newAccountController.accountAddress.rC_Bios__Original_State__c = 'AT';
        contact1 = newAccountController.contactList.get(0);
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
        contact2.rC_Bios__Home_Email__c = 'Hometest2222@myma22il.com'; 
        contact2.Private_Email__c = 'Private123@mymail.com'; 
        contact2.Club_FullName__c = 'Test Club Sal';
        newAccountController.saveAccount();
        
        messages = ApexPages.getMessages();
        msg = messages.get(4);
        system.debug(':: Messages 77 ::'+messages);
        msg = messages.get(5);
        System.assertEquals(msg.getDetail(), 'Multiple preferred contacts are selected.');
        
        //msg = messages.get(7);
        //System.assertEquals(msg.getDetail(), 'Not a valid Address Please check Override to use this');
                
        contact2.rC_Bios__Preferred_Contact__c = false;
        newAccountController.accountAddress.rC_Bios__Original_State__c = 'CAT';
        newAccountController.saveAccount();
        
        messages = ApexPages.getMessages();
        msg = messages.get(3);
        system.debug(':: Messages 88 ::'+messages);
    }
    
    static testMethod void testForOrganizationAccount() {
        PageReference prPageLink = Page.NewAccount;
        test.setCurrentPage(prPageLink);
        TestDataUtility testData = new TestDataUtility();
        Id organizationRecordTypeId = testData.getAccountRecordTypeId('Organization');
        
        //Now Test for Organization type account
        
        Account testOrganizationAccount = testData.createNewAccount(false,'Test Account2','Organization');
        system.debug('Organization Account Record Type ::'+testOrganizationAccount.RecordTypeId);
       
        ApexPages.currentPage().getParameters().put('RecordType',organizationRecordTypeId);
        ApexPages.currentPage().getParameters().put('save_new','1');
        ApexPages.currentPage().getParameters().put('sfdc.override','1');
        ApexPages.currentPage().getParameters().put('ent','Account');
      
        ApexPages.StandardController sc = new ApexPages.StandardController(testOrganizationAccount);
        NewAccountExtension newAccountController = new NewAccountExtension(sc);
        
         //Populate Account Address with Valid Address
        newAccountController.accountAddress = testData.createNewInvalidAccountAddress(false);
        newAccountController.accountAddress.rC_Bios__Original_State__c = 'CA';
        newAccountController.saveAccount();
        
        List<ApexPages.Message> messages = ApexPages.getMessages();
        system.debug(':: Messages 99 ::'+messages);
        
        
        Account testOrganizationAccount1 = testData.createNewAccount(false,'Test Account3','Organization');
        sc = new ApexPages.StandardController(testOrganizationAccount1);
        newAccountController = new NewAccountExtension(sc);
        
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
*/
}