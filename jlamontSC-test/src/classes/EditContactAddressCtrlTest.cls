//
// (c) 2014 Appirio, Inc.
//
//  Test Class for AddUPRedirect 
//  1 July 2014    Parul Gupta     Original
//
@isTest
private class EditContactAddressCtrlTest {

    static testMethod void testEditContactAddressCtrl() {
        PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        Contact testContact = testData.createNewContact(true,'Test First Name', 'Test Last Name', 'Household', testAccount.id);
        
        rC_Bios__Contact_Address__c contactAddress  = testData.createNewValidContactAddress(false);
        contactAddress.rc_Bios__Contact__c = testContact.Id;
        insert contactAddress;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(contactAddress);
        EditContactAddressCtrl editContactAddressCtrl = new EditContactAddressCtrl(sc);
        PageReference pageRef = editContactAddressCtrl.redirectToManageAddress();
        system.assert(pageRef != null);
    }
}