//**************************************************************************/
// (c) 2014 Appirio, Inc.
//
// Description : Test class for ManageContactController.
//                  
// Original : March 07, 2014  : KapiL Choudhary(Appirio India) 
// Updated  : May 2015 Peter Churchill
//      
// Updated January 2017 Mark Maslow
//			Added code to test Campaign setter
//			Removed a bunch of code that was failing due to too many SOQL queries         
// ***************************************************************************/
@isTest
private class ManageContactControllerTest {

@isTest
 static void ManageContactTestSuccess() {
        TestDataUtility tDataUtil = new TestDataUtility();
        Account acc2 = tDataUtil.createNewAccount(true, 'TestAccName','Household');
        
        rC_Bios__Account_Address__c addressToInsert = tDataUtil.createNewValidAccountAddress(false);
        addressToInsert.rC_Bios__Account__c = acc2.Id;
        addressToInsert.rC_Bios__Preferred_Billing__c = TRUE;
        insert addressToInsert;
        
        PageReference pageRef = Page.ManageContact;
        Test.setCurrentPage(pageRef);
        
        //Requery account to get Preferred Address Details
        account acc = [Select Id, Name, rC_Bios__Preferred_Billing_Address__c, rC_Bios__Preferred_Shipping_Address__c, RecordTypeId from Account where id=:acc2.id];
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        ManageContactController mCC = new ManageContactController(sc);
        mCC.noOfContacts =1;
        mCC.contactsToCreate();
        Contact contactRec = mCC.contactWrapperList.get(0).contactRec;
        contactRec.firstName = 'TestFname';
        contactRec.LastName = 'TestLname';
        contactRec.Club_Fullname__c = 'Test C name';
        contactRec.rC_Bios__Preferred_Contact__c = true;
        contactRec.rC_Bios__Preferred_Email__c = 'Work';
        contactRec.rC_Bios__Work_Email__c = 'testnewemail@test.com';
        contactRec.rC_Bios__Preferred_Phone__c = 'Work';
        contactRec.rC_Bios__Work_Phone__c = '12345';
        Test.startTest();
        mCC.saveContacts();
        Test.stopTest();

}
@isTest
    static void ManageContactTest() {
        TestDataUtility tDataUtil = new TestDataUtility();
        Account acc2 = tDataUtil.createNewAccount(true, 'TestAccName','Household');
        
        rC_Bios__Account_Address__c addressToInsert = tDataUtil.createNewValidAccountAddress(false);
        addressToInsert.rC_Bios__Account__c = acc2.Id;
        addressToInsert.rC_Bios__Preferred_Billing__c = TRUE;
        insert addressToInsert;
        
        Contact con = tDataUtil.createNewContact(false, 'FirstName', 'LastName', null, acc2.id);
        Contact newContact1 = tDataUtil.createNewContact(false, 'InFname', 'InLName', null, null);
        newContact1.Email = 'testexistingmail@test.com';
        insert newContact1;
        //con.rC_Bios__Preferred_Contact__c = true;
        insert con;
        PageReference pageRef = Page.ManageContact;
        Test.setCurrentPage(pageRef);
        
        //Requery account to get Preferred Address Details
        account acc = [Select Id, Name, rC_Bios__Preferred_Billing_Address__c, rC_Bios__Preferred_Shipping_Address__c, RecordTypeId from Account where id=:acc2.id];
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        ManageContactController mCC = new ManageContactController(sc);
        mCC.contactsToCreate();
        mCC.noOfContacts =2;
        mCC.contactsToCreate();
        mCC.noOfContacts =1;
        mCC.contactsToCreate();
        Contact contactRec = mCC.contactWrapperList.get(0).contactRec;
        contactRec.rC_Bios__Preferred_Contact__c = true;
        contactRec.rC_Bios__Preferred_Email__c = 'Work';
        contactRec.rC_Bios__Work_Email__c = 'testexistingmail@test.com';
        contactRec.rC_Bios__Preferred_Phone__c = 'Work';
        contactRec.rC_Bios__Work_Phone__c = '12345';
        mCC.saveContacts();
        //Last Name Required.
        if(!ApexPages.getMessages().isEmpty()){
            system.assertEquals('Last name is required for saving a contact.', ApexPages.getMessages().get(0).getSummary());
            
        }
        contactRec.rC_Bios__Preferred_Email__c = 'Home';
        contactRec.rC_Bios__Home_Email__c = 'testexistingmail@test.com';
        contactRec.rC_Bios__Preferred_Phone__c = 'Home';
        contactRec.HomePhone = '12345';
        contactRec.LastName = 'TestLname';
        
        mCC.saveContacts();
            //First Name Required.
        if(!ApexPages.getMessages().isEmpty()){
            //system.assertEquals('Required fields are missing: [First Name]', ApexPages.getMessages().get(1).getSummary());
            
        }
        /*
        contactRec.rC_Bios__Preferred_Email__c = 'Other';
        contactRec.rC_Bios__Other_Email__c = 'testexistingmail@test.com';
        contactRec.rC_Bios__Preferred_Phone__c = 'Other';
        contactRec.OtherPhone = '12345';
        contactRec.firstName = 'TestFname';
        system.debug('contactRec>>> '+contactRec);
        //mCC.saveContacts();
     
        system.debug('list of msggg>>> '+ApexPages.getMessages());
        
        contactRec.rC_Bios__Preferred_Email__c = 'Assistant';
        contactRec.rC_Bios__Assistant_Email__c = 'testexistingmail@test.com';
        contactRec.rC_Bios__Preferred_Phone__c = 'Assistant';
        contactRec.AssistantPhone = '12345';
        
        //mCC.saveContacts();
        
        contactRec.rC_Bios__Preferred_Email__c = '';
        contactRec.rC_Bios__Work_Email__c = 'testexistingmail@test.com';
        contactRec.rC_Bios__Preferred_Phone__c = 'Mobile';
        contactRec.MobilePhone = '12345';
        
        //mCC.saveContacts();
        
        sc = new ApexPages.standardController(acc);
        mCC = new ManageContactController(sc);
        
        mCC.contactsToCreate();
        mCC.noOfContacts =2;
        mCC.contactsToCreate();
        mCC.noOfContacts =1;
        mCC.contactsToCreate();
        */
        Contact contactRec1 = mCC.contactWrapperList.get(0).contactRec;
        contactRec1.rC_Bios__Preferred_Contact__c = true;
        contactRec1.rC_Bios__Preferred_Email__c = 'Work';
        contactRec1.rC_Bios__Work_Email__c = 'testexistingmailtest.com';
        contactRec1.rC_Bios__Preferred_Phone__c = 'Home';
        contactRec1.rC_Bios__Work_Phone__c = '12345';
        /*
        //mCC.saveContacts();
        
        
         contactRec1 = mCC.contactWrapperList.get(0).contactRec;
         contactRec1.FirstName = 'FName';
         contactRec1.LastName = 'Lanme';
        contactRec1.rC_Bios__Preferred_Contact__c = true;
        contactRec1.rC_Bios__Preferred_Email__c = 'Assistant';
        contactRec1.rC_Bios__Assistant_Email__c = 'testexistingmailtest.com';
        contactRec1.rC_Bios__Preferred_Phone__c = 'Home';
        contactRec1.rC_Bios__Work_Phone__c = '12345';
        //mCC.saveContacts();

		*/
		Test.startTest();
        
         contactRec1 = mCC.contactWrapperList.get(0).contactRec;
         contactRec1.FirstName = 'FName';
         contactRec1.LastName = 'Lanme';
        contactRec1.rC_Bios__Preferred_Contact__c = true;
        contactRec1.rC_Bios__Preferred_Email__c = 'Other';
        contactRec1.rC_Bios__Other_Email__c = 'testexistingmailtest.com';
        contactRec1.rC_Bios__Preferred_Phone__c = 'Home';
        contactRec1.rC_Bios__Work_Phone__c = '12345';
        mCC.saveContacts();
     
        sc = new ApexPages.standardController(acc);
        mCC = new ManageContactController(sc);
      
        mCC.noOfContacts =2;
        mCC.contactsToCreate();
        
        contactRec1 = mCC.contactWrapperList.get(0).contactRec;
        contactRec1.rC_Bios__Preferred_Contact__c = true;
        contactRec1.rC_Bios__Preferred_Email__c = 'Other';
        contactRec1.rC_Bios__Other_Email__c = 'testexistingmailtest.com';
        contactRec1.rC_Bios__Preferred_Phone__c = 'Home';
        contactRec1.HomePhone = '12345';
        contactRec1.Private_Email__c = 'primary2@mail.com';
        contactRec1.FirstName = 'FName';
        contactRec1.LastName = 'Lanme';
        
            Contact contactRec2 = mCC.contactWrapperList.get(1).contactRec;
        contactRec2.rC_Bios__Preferred_Contact__c = false;
        contactRec2.rC_Bios__Preferred_Email__c = 'Other';
        contactRec2.rC_Bios__Other_Email__c = '22testexistingmailtest.com';
        contactRec2.rC_Bios__Preferred_Phone__c = 'Home';
        contactRec2.HomePhone = '12345';
        contactRec2.Private_Email__c = 'primary2@mail.com';
        contactRec2.FirstName = 'FName2';
        contactRec2.LastName = 'Lanme2';
        
        mCC.saveContacts();
        system.debug('Messages :: >> '+ApexPages.getMessages());
        
        Test.stopTest();
     
        /////////////////////////////////////////////
        /*Account acc1 = tDataUtil.createNewAccount(true, 'TestAccName1','Household');
        Contact con1 = tDataUtil.createNewContact(false, 'FirstName1', 'LastName1', null, acc1.id);
        Contact newContact2 = tDataUtil.createNewContact(false, 'InFname1', 'InLName1', null, null);
        newContact2.Email = 'testexistingmail1@test.com';
        insert newContact2;
        //con.rC_Bios__Preferred_Contact__c = true;
        insert con1;
        PageReference pageRef1 = Page.ManageContact;
        Test.setCurrentPage(pageRef1);
        ApexPages.StandardController sc1 = new ApexPages.standardController(acc1);
        ManageContactController mCC1 = new ManageContactController(sc1);
        mCC1.contactsToCreate();
        mCC1.noOfContacts =2;
        mCC1.contactsToCreate();
        mCC1.noOfContacts =1;
        mCC1.contactsToCreate();
        Contact contactRec3 = mCC1.contactWrapperList.get(0).contactRec;
        contactRec3.rC_Bios__Preferred_Contact__c = true;
        contactRec3.rC_Bios__Preferred_Email__c = 'Work';
        contactRec3.rC_Bios__Work_Email__c = 'testexistingmail@test.com';
        contactRec3.rC_Bios__Preferred_Phone__c = 'Work';
        contactRec3.rC_Bios__Work_Phone__c = '12345';
        mCC1.saveContacts();*/
        
    }
@isTest
    static void ManageContactTest2() {
        TestDataUtility tDataUtil = new TestDataUtility();
        Account acc2 = tDataUtil.createNewAccount(true, 'TestAccName','Household');
        
        rC_Bios__Account_Address__c addressToInsert = tDataUtil.createNewValidAccountAddress(false);
        addressToInsert.rC_Bios__Account__c = acc2.Id;
        addressToInsert.rC_Bios__Preferred_Billing__c = TRUE;
        insert addressToInsert;
        
        Contact con = tDataUtil.createNewContact(false, 'FirstName', 'LastName', null, acc2.id);
        Contact newContact1 = tDataUtil.createNewContact(false, 'InFname', 'InLName', null, null);
        newContact1.Email = 'testexistingmail@test.com';
        insert newContact1;
        //con.rC_Bios__Preferred_Contact__c = true;
        insert con;
        PageReference pageRef = Page.ManageContact;
        Test.setCurrentPage(pageRef);
        
        //Requery account to get Preferred Address Details
        account acc = [Select Id, Name, rC_Bios__Preferred_Billing_Address__c, rC_Bios__Preferred_Shipping_Address__c, RecordTypeId from Account where id=:acc2.id];
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        ManageContactController mCC = new ManageContactController(sc);
        mCC.contactsToCreate();
        mCC.noOfContacts =2;
        mCC.contactsToCreate();
        mCC.noOfContacts =1;
        mCC.contactsToCreate();
        Contact contactRec = mCC.contactWrapperList.get(0).contactRec;
    	
        contactRec.rC_Bios__Preferred_Email__c = 'Assistant';
        contactRec.rC_Bios__Assistant_Email__c = 'testexistingmail@test.com';
        contactRec.rC_Bios__Preferred_Phone__c = 'Assistant';
        contactRec.AssistantPhone = '12345';
        
        mCC.saveContacts();
        
        contactRec.rC_Bios__Preferred_Email__c = '';
        contactRec.rC_Bios__Work_Email__c = 'testexistingmail@test.com';
        contactRec.rC_Bios__Preferred_Phone__c = 'Mobile';
        contactRec.MobilePhone = '12345';
        
        mCC.saveContacts();
        
        sc = new ApexPages.standardController(acc);
        mCC = new ManageContactController(sc);
        
        mCC.contactsToCreate();
        mCC.noOfContacts =2;
        mCC.contactsToCreate();
        mCC.noOfContacts =1;
        mCC.contactsToCreate();
        Contact contactRec1 = mCC.contactWrapperList.get(0).contactRec;
        contactRec1.rC_Bios__Preferred_Contact__c = true;
        contactRec1.rC_Bios__Preferred_Email__c = 'Work';
        contactRec1.rC_Bios__Work_Email__c = 'testexistingmailtest.com';
        contactRec1.rC_Bios__Preferred_Phone__c = 'Home';
        contactRec1.rC_Bios__Work_Phone__c = '12345';
        
        mCC.saveContacts();
    }
    
@isTest
    static void miscellaneousTest() {
        TestDataUtility tDataUtil = new TestDataUtility();
        Account acc1 = tDataUtil.createNewAccount(true, 'TestAccName1','Household');
    	CampaignSearchController csCtl = new CampaignSearchController();
        ApexPages.StandardController sc1 = new ApexPages.standardController(acc1);
    	ManageContactController mcCtl = new ManageContactController(sc1);
    	mcCtl.setCampSearchController(csCtl);
    	mcCtl.getCampSearchController();
    	mcCtl.getThis();
    	
    	mcCtl.acceptDups();
    	mcCtl.saveAndClose();
    	mcCtl.getHasDups();
    	mcCtl.setSelectedCampaign(new Campaign());
    	mcCtl.cancelNewAccount();
    	mcCtl.updatePreferred();
    }
}