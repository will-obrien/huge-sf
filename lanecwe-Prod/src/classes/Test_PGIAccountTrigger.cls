/**
 * This is the test class for the PGIAccountTrigger class and PGIAccountTriggerHelper class. 
 * It contains test methods to test the functionality of company count value on account object.
 *
 * @author Amit M.
 * @version 1.0
 */
@isTest
private class Test_PGIAccountTrigger {

	/* Stores list of company objects. */
	private static List<Company__c> companyList;
	
	/* Stores account object. */
	private static Account account;
	
	/**
	 * Tests the account trigger to check whether company count is set properly or not.
	 */
    static testMethod void UnitTest_CompanyCountOnAccount() {
        Test.startTest();
        setUp(false);
        account.Name = 'Test Account';
        Account masterAccount = PGITestUtilities.getAccountDetails();
        masterAccount.Name = 'Merge Account';
        insert masterAccount;
        merge masterAccount account;
        account = [Select Id, Count_Of_Companies__c, Count_of_all_Companies__c From Account Where Id=:masterAccount.Id];
        system.assertEquals(account.Count_of_Companies__c, 10);
        system.assertEquals(account.Count_of_all_Companies__c, 10);
        Test.stopTest();
    }
    
    /**
	 * Tests the account trigger to check whether owner is updated properly on Company and Company Revenue objects if account owner is changed.
	 */
    /*static testMethod void UnitTest_ChangedOwnerOnCompanyAndCompanyRevenue() {
        Test.startTest();
        setUp(true);
        account = [Select Id, OwnerId From Account Where Id=:account.Id];
        User testUser = PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        insert testUser;
        system.assertNotEquals(testUser.Id, null);
        account.OwnerId = testUser.Id;
        update account;
        for (Company__c company : [Select Id, OwnerId, (Select Id, OwnerId From Company_Revenue__r) From Company__c Where Account__c=:account.Id])
        {
        	system.assertEquals(company.OwnerId, testUser.Id);
        	for (Company_Revenue__c companyRevenue : company.Company_Revenue__r)
        	{
        		system.assertEquals(companyRevenue.OwnerId, testUser.Id);
        	}
        }
        Test.stopTest();
    }*/
    
    /**
	 * Tests ValidateDataComFields() and UpdateDataComFields() methods
	 */
    /*static testMethod void UnitTest_DataComFields() {
        Test.startTest();
        
        Account ultimateAccount = PGITestUtilities.getAccountDetails();
    	ultimateAccount.Count_of_Companies__c = 0;
    	ultimateAccount.Duns_Number__c = '101010';
    	ultimateAccount.Global_Ultimate_Duns__c = '';
    	ultimateAccount.Type = 'Unknown';
    	ultimateAccount.Duns_Annual_Revenue__c = 12345;
    	ultimateAccount.BillingCountry = 'testUltimateCountry';
    	insert ultimateAccount;
    	
        Account parentAccount = PGITestUtilities.getAccountDetails();
    	parentAccount.Count_of_Companies__c = 0;
    	parentAccount.Duns_Number__c = '111111';
    	parentAccount.Global_Ultimate_Duns__c = '';
    	parentAccount.Type = 'Unknown';
    	parentAccount.Duns_Annual_Revenue__c = 67890;
    	parentAccount.BillingCountry = 'testParentCountry';
    	insert parentAccount;
    	
    	//Test UpdateDataComFields() for insert
	    Account childAccount = PGITestUtilities.getAccountDetails();
	    childAccount.Count_of_Companies__c = 0;
	    childAccount.Duns_Number__c = '100001';
	    childAccount.Global_Ultimate_Duns__c = ultimateAccount.Duns_Number__c;
	    childAccount.Parent_Duns_Number__c = parentAccount.Duns_Number__c;
	    insert childAccount;

		List<Account> acc1 = [SELECT Id, Type, Global_Ultimate_Country__c, Global_Ultimate_Annual_Revenue__c, Duns_Parent_Country__c FROM Account where Id =:childAccount.Id];
		system.assert(acc1.size()>0);
		system.assertEquals(acc1[0].Type, ultimateAccount.Type);
		system.assertEquals(acc1[0].Global_Ultimate_Country__c, ultimateAccount.BillingCountry);
		system.assertEquals(acc1[0].Global_Ultimate_Annual_Revenue__c, ultimateAccount.Duns_Annual_Revenue__c);
		system.assertEquals(acc1[0].Duns_Parent_Country__c, parentAccount.BillingCountry);
		
		//Test UpdateDataComFields() for update
		childAccount.Parent_Duns_Number__c = ultimateAccount.Duns_Number__c;
		update childAccount;
		
		List<Account> acc2 =  [SELECT Duns_Parent_Country__c FROM Account where Id =:childAccount.Id];
		system.assert(acc2.size()>0);
		system.assertEquals(acc2[0].Duns_Parent_Country__c, ultimateAccount.BillingCountry);
		
		//Test ValidateDataComFields()
	    Account childAccount2 = PGITestUtilities.getAccountDetails();
	    childAccount2.Count_of_Companies__c = 0;
	    childAccount2.Duns_Number__c = '100002';
	    childAccount2.Global_Ultimate_Duns__c = ultimateAccount.Duns_Number__c;
	    User testUser = PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
	    insert testUser;
 		
	    try{
	    	System.runAs(testUser){
	    		insert childAccount2;	
	    	}
	    	system.assert(false);
	    }
	    catch(Exception ex){
    		system.assert(true);
    	}

        Test.stopTest();
    }
    
    /*static testMethod void UnitTest_SetEmailOptOutToFalse(){
    	Test.startTest();
    	Account testAccount = PGITestUtilities.getAccountDetails();
    	testAccount.Status__c = 'Prospect';
    	insert testAccount;
    	
    	Contact contact = PGITestUtilities.getContactDetails(testAccount.Id);
    	contact.HasOptedOutOfEmail = true;
    	contact.Channel__c = 'Canada';
    	insert contact;
    	
    	testAccount.Status__c = 'Customer';
    	update testAccount;
    	Contact contactUpdated = [SELECT HasOptedOutOfEmail, Date_of_Opt_in__c FROM Contact where Id =: contact.Id];
    	System.assertEquals(contactUpdated.HasOptedOutOfEmail, false);
    	System.assert(contactUpdated.Date_of_Opt_in__c != null);
    	Test.stopTest();
    }*/
    
    /**
	 * Creates the test data for the test methods.
	 */
    private static void setUp(Boolean createCompanyRevenue)
    {
    	account = PGITestUtilities.getAccountDetails();
    	account.Count_of_Companies__c = 0;
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
    	if (createCompanyRevenue)
    	{
	    	List<Company_Revenue__c> companyRevenueList = new List<Company_Revenue__C>();
	    	for (Company__c company : companyList)
	    	{
	    		companyRevenueList.add(PGITestUtilities.createCompanyRevenue(account.Id, company.Id));
	    		companyRevenueList.add(PGITestUtilities.createCompanyRevenue(account.Id, company.Id));
	    	}
	    	insert companyRevenueList;
    	}
    }
}