/**
 * This is Test class for AccountInfoJSR class  
*/ 

@isTest
private class AccountInfoJSRTest {
	@isTest
	static void getAccountDataTest()
	{
        Account acc = new Account(Name = 'account name', Phone = '123-456');
        insert acc;
        Contact con = new Contact(FirstName = 'contact first name', LastName = 'contact last name', Phone = '456-123');
        con.Accountid= acc.id;
        insert con;
		Account testacc = AccountInfoJSR.getAccountData(acc.Id);
        
        System.assertEquals('account name', testacc.Name);
        System.assertEquals('123-456', testacc.Phone);
        System.assertEquals('contact first name', testacc.Contacts[0].FirstName);
        System.assertEquals('contact last name', testacc.Contacts[0].LastName);
        System.assertEquals('456-123', testacc.Contacts[0].Phone);
	}
}