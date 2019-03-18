@isTest
private class AddContactsControllerTest {

	@isTest
    static void myUnitTest() {
    	Test.startTest();
    	Account testAccount = PGITestUtilities.getAccountDetails();
    	insert testAccount;
    	Lead testLead = PGITestUtilities.getLeadDetails();
    	insert testLead;
    	Map<String, String> accountMap = new Map<String, String>();
    	accountMap.put('AccountID', testAccount.Id);
    	accountMap.put('AccountName', testAccount.Name);
        ApexPages.StandardController stdController = new ApexPages.StandardController(testLead);
		addContactsController controller = new addContactsController(stdController);
		Test.stopTest();
		
		controller.getLeadID();
		controller.getFinishPage();
    }
}