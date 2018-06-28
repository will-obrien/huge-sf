/**
 * This is the test class for the PGICompanyTrigger class and SortingHelper class. 
 * It contains test methods to test the functionality of Count of Companies and Count of All Companies values on account object.
 *
 * @author Amit M.
 * @version 1.0
 */
@isTest
private class Test_PGICompanyTrigger {
	
	/* Stores list of company objects. */
	private static List<Company__c> companyList;
	
	/* Stores account object. */
	private static Account account;
	
	/* Stores list of account objects. */
	private static List<Account> accountList;
	
	/* Stores list of company revenue objects. */
	private static List<Company_Revenue__c> companyRevenueList;

	/**
	 * Tests that count of company is updated properly on account after insert of company object.
	 */
    static testMethod void UnitTest_CompanyCountOnInsert() 
    {
    	Test.startTest();
    	setUp(false);
    	account = [Select Id, Count_of_Companies__c, Count_of_all_Companies__c From Account Where Id =:account.Id];
    	system.assertEquals(account.Count_of_Companies__c, 10);
    	system.assertEquals(account.Count_of_all_Companies__c, 10);
    	Test.stopTest();
    }
    
    /**
	 * Tests that count of company is updated properly on account after delete of company object.
	 */
    static testMethod void UnitTest_CompanyCountOnDelete() 
    {
    	Test.startTest();
    	setUp(false);
    	account = [Select Id, Count_of_Companies__c, Count_of_all_Companies__c From Account Where Id =:account.Id];
    	system.assertEquals(account.Count_of_Companies__c, 10);
    	system.assertEquals(account.Count_of_all_Companies__c, 10);
    	List<Company__c> deleteCompanyList = new List<Company__c>();
    	deleteCompanyList.add(companyList.get(0));
    	deleteCompanyList.add(companyList.get(1));
    	delete deleteCompanyList;
    	account = [Select Id, Count_of_Companies__c, Count_of_all_Companies__c From Account Where Id =:account.Id];
    	system.assertEquals(account.Count_of_Companies__c, 8);
    	system.assertEquals(account.Count_of_all_Companies__c, 8);
    	Test.stopTest();
    }
    
    /**
	 * Tests that count of company is updated properly on account after update of company object.
	 */
    static testMethod void UnitTest_CompanyCountOnUpdate() 
    {
    	Test.startTest();
    	setUp(false);
    	account = [Select Id, Count_of_Companies__c, Count_of_all_Companies__c From Account Where Id =:account.Id];
    	system.assertEquals(account.Count_of_Companies__c, 10);
    	system.assertEquals(account.Count_of_all_Companies__c, 10);
    	for (Company__c company : companyList)
    	{
    		company.Account__c = accountList[1].Id;
    	}
    	update companyList;
    	account = [Select Id, Count_of_Companies__c, Count_of_all_Companies__c From Account Where Id =:account.Id];
    	system.assertEquals(account.Count_of_Companies__c, 0);
    	system.assertEquals(account.Count_of_all_Companies__c, 0);
    	for (Company__c company : companyList)
    	{
    		company.Account__c = accountList[0].Id;
    	}
    	update companyList;
    	account = [Select Id, Count_of_Companies__c, Count_of_all_Companies__c From Account Where Id =:account.Id];
    	system.assertEquals(account.Count_of_Companies__c, 10);
    	system.assertEquals(account.Count_of_all_Companies__c, 10);
    	Test.stopTest();
    }
    
    static testMethod void UnitTest_CompanyCountNegative() 
    {
    	Test.startTest();
    	setUp(false);
    	account.Count_of_Companies__c = 0;
    	account.Count_of_all_Companies__c = 0;
    	update account;
    	//reduce company count
    	for (Company__c company : companyList)
    	{
    		company.Account__c = accountList[1].Id;
    	}
    	update companyList;
    	account = [Select Id, Count_of_Companies__c, Count_of_all_Companies__c From Account Where Id =:account.Id];
    	system.assertEquals(account.Count_of_Companies__c, 0);
    	system.assertEquals(account.Count_of_all_Companies__c, 0);
    	Test.stopTest();
    }
    /**
	 * Tests that count of company is updated properly on account after update of company object.
	 */
    /*static testMethod void UnitTest_CompanyCountOnUpdateOfAccount() 
    {
    	Test.startTest();
    	setUp(false);
    	Account secondAccount = accountList[1];
    	
    	// change the account on the company.
    	for (Company__c company : companyList)
    	{
    		company.Account__c = secondAccount.Id;
    	}
    	update companyList;
    	Map<Id, Account> accountMap= new Map<Id, Account>([Select Id, Count_of_Companies__c, Count_of_all_Companies__c From Account Where Id IN:accountList]);
    	system.assertEquals(accountMap.get(account.Id).Count_of_Companies__c, 0);
    	system.assertEquals(accountMap.get(secondAccount.Id).Count_of_Companies__c, 10);
    	system.assertEquals(accountMap.get(account.Id).Count_of_all_Companies__c, 0);
    	system.assertEquals(accountMap.get(secondAccount.Id).Count_of_all_Companies__c, 10);
    	// change the account on the company and set the TESLA_InactiveDate__c date on company.*/
    	/*for (Company__c company : companyList)
    	{
    		company.Account__c = account.Id;
    		company.TESLA_InactiveDate__c = system.today();
    	}
    	update companyList;
    	accountMap= new Map<Id, Account>([Select Id, Count_of_Companies__c, Count_of_all_Companies__c From Account Where Id IN:accountList]);
    	system.assertEquals(accountMap.get(account.Id).Count_of_Companies__c, 10);
    	system.assertEquals(accountMap.get(secondAccount.Id).Count_of_Companies__c, 0);
    	system.assertEquals(accountMap.get(account.Id).Count_of_all_Companies__c, 10);
    	system.assertEquals(accountMap.get(secondAccount.Id).Count_of_all_Companies__c, 0);
    	// change the account on the company and set the TESLA_InactiveDate__c date on company to null.
    	for (Company__c company : companyList)
    	{
    		company.Account__c = secondAccount.Id;
    		company.TESLA_InactiveDate__c = null;
    	}
    	update companyList;
    	accountMap= new Map<Id, Account>([Select Id, Count_of_Companies__c, Count_of_all_Companies__c From Account Where Id IN:accountList]);
    	system.assertEquals(accountMap.get(account.Id).Count_of_Companies__c, 0);
    	system.assertEquals(accountMap.get(secondAccount.Id).Count_of_Companies__c, 10);
    	system.assertEquals(accountMap.get(account.Id).Count_of_all_Companies__c, 0);
    	system.assertEquals(accountMap.get(secondAccount.Id).Count_of_all_Companies__c, 10);*/
    	/*Test.stopTest();
    }*/
    
    /**
	 * Tests that total of account revenue after account is udpated on company object.
	 */
    /*static testMethod void UnitTest_CompanyRevenueOnChangeOfAccount() 
    {
    	Test.startTest();
    	setUp(true);
    	
    	Account secondAccount = accountList[1];
    	// change the account on the company.
    	for (Company__c company : companyList)
    	{
    		company.Account__c = secondAccount.Id;
    	}
    	update companyList;
    	
    	// assert to check that owner and account revenue has been updated properly on change of account.
    	companyList = [Select Id, OwnerId, Account__c, (Select Id, Related_Account__c, OwnerId From Company_Revenue__r) From Company__c Where Id IN:companyList Order By Account__c];
    	for (Company__c company : companyList)
    	{
    		system.assertEquals(company.OwnerId, secondAccount.OwnerId); 
    		for (Company_Revenue__c companyRevenue : company.Company_Revenue__r)
    		{
	    		system.assertEquals(companyRevenue.Related_Account__c, secondAccount.Id);
	    		system.assertEquals(companyRevenue.OwnerId, secondAccount.OwnerId); 
    		}
    	}
    	Map<Id, Account> accountMap= new Map<Id, Account>([Select Id, Billed_Rev_Prev_13_Months__c From Account Where Id IN:accountList]);
    	//system.assertEquals(accountMap.get(account.Id).Billed_Rev_Prev_13_Months__c, 0);
    	//system.assertEquals(accountMap.get(secondAccount.Id).Billed_Rev_Prev_13_Months__c, 200);
    	Test.stopTest();
    }*/
    
    /**
	 * Creates the test data for the test methods.
	 */
    private static void setUp(Boolean createCompanyRevenue)
    {
    	accountList = new List<Account>();
    	
    	User testUser = PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
    	insert testUser;
    	system.assertNotEquals(testUser.Id, null);
    	
    	for (Integer i = 0; i < 2; i++)
    	{
    		Account testAccount = PGITestUtilities.getAccountDetails();
    		testAccount.Billed_Rev_Prev_13_Months__c = 0;
    		if (i == 1)
    		{
	    		testAccount.OwnerId = testUser.Id;
    		}
	    	accountList.add(testAccount);
    	}
    	insert accountList;
    	account = accountList[0];
    	system.assertNotEquals(account.Id, null);
    	companyList = new List<Company__c>();
    	for (Integer i = 0; i < 10; i++)
    	{
    		Company__c company = PGITestUtilities.getCompany(account.Id);
    		company.Account__c = accountList[0].Id;
    		companyList.add(company);
    	}
    	insert companyList;
    	if (createCompanyRevenue)
    	{
	    	companyRevenueList = new List<Company_Revenue__c>();
	    	for (Company__c company : companyList)
	    	{
	    		companyRevenueList.add(PGITestUtilities.createCompanyRevenue(account.Id, company.Id));
	    		companyRevenueList.add(PGITestUtilities.createCompanyRevenue(account.Id, company.Id));
	    	}
	    	insert companyRevenueList;
    	}
    }
}