/**
 * This is the test class for the PGICompanyRevenueTrigger and helper class. 
 * It contains test methods to test the functionality of company revenue object business requirements.
 *
 * @author Amit M.
 * @version 1.0
 */
@isTest
private class Test_PGICompanyRevenueTrigger {

	/* Stores list of company objects. */
	private static List<Company__c> companyList;
	
	/* Stores account object. */
	private static Account account;
	
	/* Stores list of company revenue objects. */
	private static List<Company_Revenue__c> companyRevenueList;
	
	/**
	 * Creates the test data for the test methods.
	 */
    private static void setUp()
    {
    	account = PGITestUtilities.getAccountDetails();
    	account.Billed_Rev_Prev_13_Months__c = 0;
    	insert account;
    	system.assertNotEquals(account.Id, null);
    	companyList = new List<Company__c>();
    	for (Integer i = 0; i < 10; i++)
    	{
    		Company__c company = PGITestUtilities.getCompany(account.Id);
    		company.TESLA_InactiveDate__c = null;
    		companyList.add(company);
    	}
    	insert companyList;
    	companyRevenueList = new List<Company_Revenue__c>();
    	for (Company__c company : companyList)
    	{
    		companyRevenueList.add(PGITestUtilities.createCompanyRevenue(account.Id, company.Id));
    		companyRevenueList.add(PGITestUtilities.createCompanyRevenue(account.Id, company.Id));
    	}
    	insert companyRevenueList;
    }
    
    /**
	 * Tests that count of company is updated properly on account after insert of company object.
	 */
    /*static testMethod void UnitTest_CompanyRevenueInsertUpdateDelete() 
    {
    	Test.startTest();
    	setUp();
    	account = [Select Id, Billed_Rev_Prev_13_Months__c From Account Where Id =:account.Id];
    	//system.assertEquals(account.Billed_Rev_Prev_13_Months__c, 200);
    	
    	for (Company_Revenue__c companyRevenue : companyRevenueList)
    	{
    		companyRevenue.Revenue__c = 20;
    	}
    	update companyRevenueList;
    	account = [Select Id, Billed_Rev_Prev_13_Months__c From Account Where Id =:account.Id];
    	//system.assertEquals(account.Billed_Rev_Prev_13_Months__c, 400);
    	
    	delete companyRevenueList;
    	account = [Select Id, Billed_Rev_Prev_13_Months__c From Account Where Id =:account.Id];
    	//system.assertEquals(account.Billed_Rev_Prev_13_Months__c, 0);
    	Test.stopTest();
    }*/
}