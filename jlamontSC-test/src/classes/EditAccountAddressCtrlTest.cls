//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Test Class for EditAccountAddressCtrl 
//	8 March 2014    Virendra (Appirio)     Original
//**********************************************************************/
@isTest
private class EditAccountAddressCtrlTest {
	
	@IsTest
	static void testEditAccountAddressOverride() {  
		PageReference prPageLink = Page.ManageAddress;
        test.setCurrentPage(prPageLink);
        
        TestDataUtility testData = new TestDataUtility();
        Account testAccount = testData.createNewAccount(true,'Test Acccount','Household');
        
        rC_Bios__Account_Address__c actAddress  = testData.createNewValidAccountAddress(false);
        actAddress.rC_Bios__Account__c = testAccount.Id;
        insert actAddress;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(actAddress);
        EditAccountAddressCtrl editAccountAddressCtrl = new EditAccountAddressCtrl(sc);
        editAccountAddressCtrl.redirectToManageAddress();
    
	}
}