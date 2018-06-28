/**
 * This is Test class for AccountCheck class
 * Coverage - 100% 
*/

@isTest
private class AccountsCheckTest {
	
    @isTest 
    private static void noResultTest()
    {
        Account ac1 = new Account(Name = 'tect acc1', Phone = '123456');
        Account ac2 = new Account(Name = 'tect acc2', Phone = '456789');
        Account ac3 = new Account(Name = 'tect acc3', Phone = '654321');
        insert ac1;
        insert ac2;
        insert ac3;
        AccountsCheck ac = new AccountsCheck();
        ac.wrapping();
        
        System.assertEquals('No Account is in process!', ac.result);
    }
    
    @isTest 
    private static void oneResultTest()
    {
        Account ac1 = new Account(Name = 'tect acc1', Phone = '123456');
        Account ac2 = new Account(Name = 'tect acc2', Phone = '456789');
        Account ac3 = new Account(Name = 'tect acc3', Phone = '654321');
        insert ac1;
        insert ac2;
        insert ac3;
        AccountsCheck ac = new AccountsCheck();
        
        AccountsCheck.Wrap wrap = new AccountsCheck.Wrap();
        wrap.myAccount = ac1;
        wrap.isSelected = true;
        ac.wrappList.add(wrap);
        ac.wrapping();
        
        System.assertEquals(1, ac.toProcess.size());
    }
    
    @isTest 
    private static void someResultsTest()
    {
        Account ac1 = new Account(Name = 'tect acc1', Phone = '123456');
        Account ac2 = new Account(Name = 'tect acc2', Phone = '456789');
        Account ac3 = new Account(Name = 'tect acc3', Phone = '654321');
        insert ac1;
        insert ac2;
        insert ac3;
        AccountsCheck ac = new AccountsCheck();
        
        AccountsCheck.Wrap wrap1 = new AccountsCheck.Wrap();
        wrap1.myAccount = ac1;
        wrap1.isSelected = true;
        ac.wrappList.add(wrap1);
        
        AccountsCheck.Wrap wrap2 = new AccountsCheck.Wrap();
        wrap2.myAccount = ac1;
        wrap2.isSelected = true;
        ac.wrappList.add(wrap2);
        
        ac.wrapping();
        
        System.assertEquals(2, ac.toProcess.size());
    }
}
