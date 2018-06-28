//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Test Class for AccountOpportunityRelatedListExtension 
//	9 March 2014    Virendra (Appirio)     Original
//**********************************************************************/
@isTest
private class AccountOppRtdListExtensionTest {
	
	static testMethod void testAccountOppRtdList() {
		PageReference prPageLink = Page.AccountOpportunityRelatedList;
        test.setCurrentPage(prPageLink);
        TestDataUtility testData = new TestDataUtility();
        Id houseHoldRecordTypeId = testData.getAccountRecordTypeId('Household');
        
        Account testAccount = testData.createNewAccount(false,'Test Account1','Household');
        system.debug('Test Account Record Type ::'+testAccount.RecordTypeId);
        
        ApexPages.currentPage().getParameters().put('RecordType',houseHoldRecordTypeId);
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        AccountOpportunityRelatedListExtension newAccountController = new AccountOpportunityRelatedListExtension(sc);
   }

}