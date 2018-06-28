@isTest
public class AccountContactJSRTest 
{
    static testMethod void AccountContactJSRTest()
    {
        Account account = new Account(Name = 'Prison');
        insert account;
        Contact contact = new Contact(FirstName = 'Rick', LastName = 'James', Phone = '555-555', AccountID = account.ID);
        insert contact;
        Account testAccount = new Account();
        
        Test.startTest();
        	testAccount = AccountContactJSR.getAccountData(account.ID);
        Test.stopTest();
        
        system.assertEquals(testAccount.ID, account.ID, 'Error: Wrong account ID.');
        system.assertEquals(testAccount.Contacts[0].FirstName, contact.FirstName, 'Error: Wrong contact FirstName.');
        system.assertEquals(testAccount.Contacts[0].LastName, contact.LastName, 'Error: Wrong contact LastName.');
        system.assertEquals(testAccount.Contacts[0].Phone, contact.Phone, 'Error: Wrong contact Phone.');
    }
}