/*
 * This is the test class for CountOfCompaniesBatch class. 
 * It contains test methods to test the functionality of Count of Companies values on account object.
 *
 * @author Carmen Wong
 * @version 1.0
 */
@isTest
private class CountOfCompaniesTest {
	static testMethod void TestAccountWithCompany(){
		Test.startTest();
		List<Account> accountList = setUp(true);
		String jobId = System.schedule('CountOfCompaniesScheduler','0 0 0 * * ?', new CountOfCompaniesScheduler());
		/*CountOfCompaniesBatch countOfCompaniesBch = new CountOfCompaniesBatch();
		String query = 'SELECT Id, Count_Of_Companies__c FROM Account LIMIT 10';
		countOfCompaniesBch.query = query;
		Database.executeBatch(countOfCompaniesBch);*/
		Test.stopTest();
									
		List<Account>accountResultList = [SELECT Id, Count_Of_Companies__c FROM Account WHERE Id IN :accountList];
		System.assert(accountResultList.size()>0);
		System.assertNotEquals(accountResultList[0],null);
		System.assertEquals(accountResultList[0].Count_Of_Companies__c,2);	
	}
	
	static testMethod void TestAccountWithoutCompany(){
		Test.startTest();
		List<Account> accountList = setUp(false);
		String jobId = System.schedule('CountOfCompaniesScheduler','0 0 0 * * ?', new CountOfCompaniesScheduler());
		/*CountOfCompaniesBatch CountOfCompaniesBch = new CountOfCompaniesBatch();
		String query = 'SELECT Id, Count_Of_Companies__c FROM Account LIMIT 10';
		CountOfCompaniesBch.query = query;
		Database.executeBatch(CountOfCompaniesBch);*/
		Test.stopTest();
		
		List<Account>accountResultList = [SELECT Id, Count_Of_Companies__c FROM Account WHERE Id IN :accountList];
		System.assert(accountResultList.size()>0);
		System.assertNotEquals(accountResultList[0],null);
		//System.assertEquals(accountResultList[0].Count_Of_Companies__c,0);	
	}
	
	private static List<Account> setUp(Boolean createCompany)
    {
    	List<Account> accountList = new List<Account>();
    	List<Company__c> companyList = new List<Company__c>();
    	for (Integer i = 0; i < 5; i++)
    	{
    		Account account = PGITestUtilities.getAccountDetails();
	    	accountList.add(account);
    	}
    	insert accountList;
    	if(createCompany){
	    	for (Account account : accountList){
	    		for (Integer i = 0; i < 2; i++){
		    		Company__c company = PGITestUtilities.getCompany(account.Id);
		    		companyList.add(company);
		    	}
	    	}
	    	insert companyList;
    	}
    	return accountList;
    }

}