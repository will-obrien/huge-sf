@isTest
private class TestThinkingInApexLimits {


    // Demonstration of using a single query for an object and related object to reduce SOQL calls
    // First examples shows a straightforward approach:
    
    static testMethod void TestContactsWithAccountRevenue1() {
        // Set up a dummy account and contact
        Account newact = new Account(Name = 'testaccount');
        insert newact;
        Contact newct = new Contact(LastName = 'testcontactln');
        newct.AccountId = newact.id;
        insert newct;
        
        Test.startTest();
        
        // Query for contact info
        List<Contact> cts = [SELECT ID, AccountID from Contact where Name = 'testcontactln'];
        
        // Some code that operates on the contacts here....
        
        // Get list of account IDs.
        Set<ID> accountids = new Set<ID>();
        for(Contact ct: cts) if(ct.AccountID!=null) accountids.add(ct.AccountID);
        
        if(accountids.size()>0)
        {
        	List<Account> accounts = [Select ID, AnnualRevenue from Account where ID in :accountids];
        	for(Account accountfound: accounts) if(accountfound.AnnualRevenue == null) accountfound.AnnualRevenue = 500;
        	update accounts;
        }
        
        Test.stopTest();
        
        // Make sure it worked
       	if(accountids.size()>0)
		{
       		List<Account> accounts2 = [Select ID, AnnualRevenue from Account where ID in :accountids];
       		for(Account accountfound: accounts2) system.assertEquals(500, accountfound.AnnualRevenue);
		}
        
        
    }
    
	// Second example shows how you can use a related query
    static testMethod void TestContactsWithAccountRevenue2() {
        // Set up a dummy account and contact
        Account newact = new Account(Name = 'testaccount');
        insert newact;
        Contact newct = new Contact(LastName = 'testcontactln');
        newct.AccountId = newact.id;
        insert newct;
        
        Test.startTest();
        
        // Query for contact info and annual revenue on account in a single query
        List<Contact> cts = [SELECT ID, AccountID, Account.ID, Account.AnnualRevenue from Contact where Name = 'testcontactln'];

        // Some code that operates on the contacts here....
        
        Map<ID, Account> accountstoupdate = new Map<ID,Account>();
        
        for(Contact ct: cts)
        {
        	if (ct.Account.AnnualRevenue == null) 
        	{
        		ct.Account.AnnualRevenue = 500;
        		accountstoupdate.put(ct.AccountID, ct.Account);
        	}
        }
        
		update accountstoupdate.values();
        
        Test.stopTest();
        
        // Make sure it worked
       	if(accountstoupdate.size()>0)
		{
       		List<Account> accounts2 = [Select ID, AnnualRevenue from Account where ID in :accountstoupdate.keyset()];
       		for(Account accountfound: accounts2) system.assertEquals(500, accountfound.AnnualRevenue);
		}
        
        
    }   
    
    // The following three examples demonstrate some sipmle code optimization techniques
    
    
    static testMethod void TestScriptLines1() {
		List<Account> accounts = new List<Account>();
    	for(Integer x = 0; x< 100; x++)
    	{
			// Worst case account on comparison
    		accounts.add(new Account(Name='act_'+ accounts, AnnualRevenue = 50, Industry='Engineering', NumberOfEmployees = 100));
    	}
    	
    	Test.StartTest();
    	for(Account act: accounts) IsAccountInteresting(act);
    	Test.StopTest();
    }

    static testMethod void TestScriptLines2() {
		List<Account> accounts = new List<Account>();
    	for(Integer x = 0; x< 100; x++)
    	{
			// Worst case account on comparison
    		accounts.add(new Account(Name='act_'+ accounts, AnnualRevenue = 50, Industry='Engineering', NumberOfEmployees = 100));
    	}
    	
    	Test.StartTest();
    	for(Account act: accounts) IsAccountInteresting2(act);
    	Test.StopTest();
    }    
    
    
    
    private static boolean IsAccountInteresting(Account act)
    {
    	if(act.AnnualRevenue==null) return false;
    	if(act.Industry=='Banking') return true;
    	if(act.Industry!= 'Engineering' && act.Industry != 'Healthcare' ) return false;
    	if(act.NumberOfEmployees ==null || act.NumberOfEmployees < 50) return false;
    	return (act.TickerSymbol !=null);
    }
    
    private static boolean IsAccountInteresting2(Account act)
    {
    	return(
    		!(act.AnnualRevenue==null) &&
    			( act.Industry=='Banking' ||
    				( ( act.Industry == 'Engineering' || act.Industry=='Healthcare') &&
    					act.NumberOfEmployees>=50 && act.TickerSymbol!=null
    				)
    			)
    		);
    }    
    
    
    
     
}