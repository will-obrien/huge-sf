@isTest
private class Test_AccountRemoter {

	static Account acc;
	static void testData(){
		Acc = new Account(Name = 'test');
        insert acc;
	
	}
	
    static testMethod void myUnitTest_1() {

		testData();
		test.startTest();
		AccountRemoter.returnData  data = new AccountRemoter.returnData ();
		AccountRemoter remtr = new AccountRemoter();
		AccountRemoter.fetchPanel('Account');		
		AccountRemoter.getAccount('test');
		AccountRemoter.getUserName(new AccountRemoter.appData());
		AccountRemoter.getMembershipTypeFieldMetaData();
		remtr.getMemeberShip();
		test.stopTest();
    }
}