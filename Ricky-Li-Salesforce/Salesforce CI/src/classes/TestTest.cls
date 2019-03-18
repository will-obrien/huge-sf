@isTest
private class TestTest{
    static testMethod void testTestData(){
        Account acc = TestCreateData.createAccount();
        System.debug(acc.Id);
    }
}