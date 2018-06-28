@isTest

public class caseUpdationTest {

    static testMethod void testUpdateCase() {
        Account objAccount = new Account(Name = 'Foo',
                                         PersonEmail__c='a@b.com',
                                         Email_Address__c = 'a@b.com');

        insert objAccount;

        Case objCase = new Case();
        objCase.Origin = 'Web';
        objCase.Status = 'New';
        objCase.Supplied_Mail__c = 'a@b.com';

        test.startTest();
        insert objCase;
        System.debug('/*/*/*/*/*/*/*/*/*/*/*/*/*/ 1: ' + objCase.AccountId);
        test.stopTest();

        objAccount = [SELECT Id FROM Account a];
        System.debug('/*/*/*/*/*/*/*/*/*/*/*/*/*/ : ' + objCase.AccountId);
        System.assertEquals(objAccount.Id,objCase.AccountId);
    }
}