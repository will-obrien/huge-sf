@isTest
// *********************************************************************************** 
// 
//  Acct_Case_CRU_OnCase_TEST
//  
//  Description:
//  Class for all of the unit tests associated with the 
//  Acct_Case_CRU_OnCase trigger.
//
//  Developed for Microsystems by InSitu Software LLC.
//
//  History:
//  RMN    01/10/2010    Original version
// ***********************************************************************************
private class Acct_Case_CRU_OnCase_TEST 
{
	// ----------------------------------------------------------
	// Test1 - Insert Processing, 1 Case
	// ----------------------------------------------------------
    static testMethod void Test1() 
    {
    	// Setup the Account
     	Account acctTest = new Account (Name = 'ACCRS Test Account 1');
     	insert acctTest;
     	
     	// Set up the Case
     	Case caseTest = new Case (AccountId = acctTest.Id,
     	                          Origin = 'Web',
     	                          Type = 'Document Support',
     	                          Subject = 'Test');
     	
     	insert caseTest;
     	
     	acct_case_custom_rollup__c resultAcctCase =  
     			[SELECT Id, Case_Type__c FROM acct_case_custom_rollup__c WHERE Case__r.Id = :caseTest.Id]; 
     			
     	System.assertEquals('Document Support', resultAcctCase.Case_Type__c);                         	   
    }
    
    // ----------------------------------------------------------
	// Test2 - Insert Processing, Multiple Cases
	// ----------------------------------------------------------
    static testMethod void Test2() 
    {
    	// Setup the Account
     	Account acctTest = new Account (Name = 'ACCRS Test Account 1');
     	insert acctTest;
     	
     	// Set up the Cases
     	List<Case> listTestCases = new List<Case>();
     	Case caseTest1 = new Case (AccountId = acctTest.Id,
     	                           Origin = 'Web',
     	                           Type = 'Document Support',
     	                           Subject = 'Test 1');
     	listTestCases.add(caseTest1);  
     	                         
     	Case caseTest2 = new Case (AccountId = acctTest.Id,
     	                           Origin = 'Web',
     	                           Type = 'Admin / Billing',
     	                           Subject = 'Test 2');
     	listTestCases.add(caseTest2);  
     	                         
     	Case caseTest3 = new Case (AccountId = acctTest.Id,
     	                           Origin = 'Web',
     	                           Type = 'Sales Support',
     	                           Subject = 'Test 3');
     	listTestCases.add(caseTest3);  
     	                                                    
     	
     	insert listTestCases;
     	
     	List<acct_case_custom_rollup__c> listTestAcctCaseResults = new List<acct_case_custom_rollup__c>( 
     			[SELECT Id, Case_Type__c FROM acct_case_custom_rollup__c WHERE Case__r.Id IN :listTestCases]); 
     			
     	System.assertEquals(3, listTestAcctCaseResults.size());                         	   
    }
    
    // ----------------------------------------------------------
	// Test3 - Update Processing, 1 Update, no impact
	// ----------------------------------------------------------
    static testMethod void Test3() 
    {
    	// Setup the Account
     	Account acctTest = new Account (Name = 'ACCRS Test Account 1');
     	insert acctTest;
     	
     	// Set up the Case
     	Case caseTest = new Case (AccountId = acctTest.Id,
     	                          Origin = 'Web',
     	                          Type = 'Document Support',
     	                          Subject = 'Test');
     	
     	insert caseTest;
     	
     	caseTest.Subject = 'Test Change';
     	
     	update caseTest;
     	
     	acct_case_custom_rollup__c resultAcctCase =  
     			[SELECT Id, Case_Type__c FROM acct_case_custom_rollup__c WHERE Case__r.Id = :caseTest.Id]; 
     			
     	System.assertEquals('Document Support', resultAcctCase.Case_Type__c);                         	   
    }
    
    // ----------------------------------------------------------
	// Test4 - Update Processing, Multiple Updates, someo impact
	// ----------------------------------------------------------
    static testMethod void Test4() 
    {
    	// Setup the Account
     	Account acctTest = new Account (Name = 'ACCRS Test Account 1');
     	insert acctTest;
     	
     	// Set up the Cases
     	List<Case> listTestCases = new List<Case>();
     	Case caseTest1 = new Case (AccountId = acctTest.Id,
     	                           Origin = 'Web',
     	                           Type = 'Document Support',
     	                           Subject = 'A');
     	listTestCases.add(caseTest1);  
     	                         
     	Case caseTest2 = new Case (AccountId = acctTest.Id,
     	                           Origin = 'Web',
     	                           Type = 'Admin / Billing',
     	                           Subject = 'B');
     	listTestCases.add(caseTest2);  
     	                         
     	Case caseTest3 = new Case (AccountId = acctTest.Id,
     	                           Origin = 'Web',
     	                           Type = 'Sales Support',
     	                           Subject = 'C');
     	listTestCases.add(caseTest3);  
     	                                                    
     	
     	insert listTestCases;
     	
     	listTestCases[0].Type = 'Product Support';
     	listTestCases[1].Origin = 'Phone';
     	listTestCases[2].Type = 'Knowledge Base';
     	
     	update listTestCases;
     	
     	
     	List<acct_case_custom_rollup__c> listTestAcctCaseResults = new List<acct_case_custom_rollup__c>( 
     			[SELECT Id, Case_Type__c FROM acct_case_custom_rollup__c WHERE Case__r.Id IN :listTestCases ORDER BY Case_Type__c]); 
     			
     	System.assertEquals(3, listTestAcctCaseResults.size());
     	System.assertEquals('Admin / Billing', listTestAcctCaseResults[0].Case_Type__c);
     	System.assertEquals('Knowledge Base', listTestAcctCaseResults[1].Case_Type__c); 
     	System.assertEquals('Product Support', listTestAcctCaseResults[2].Case_Type__c);                        	   
    }
    
    // ----------------------------------------------------------
	// Test5 - Case initially added with no Account
	// ----------------------------------------------------------
    static testMethod void Test5() 
    {
    	// Setup the Account
     	Account acctTest = new Account (Name = 'ACCRS Test Account 1');
     	insert acctTest;
     	
     	// Set up the Cases
     	List<Case> listTestCases = new List<Case>();
     	Case caseTest1 = new Case (Origin = 'Web',
     	                           Type = 'Document Support',
     	                           Subject = 'A');                                                  
     	
     	listTestCases.add(caseTest1);  
     	insert listTestCases;
     	     	
     	// Should not have been any record added.  
     	List<acct_case_custom_rollup__c> listTestAcctCaseResults1 = new List<acct_case_custom_rollup__c>( 
     			[SELECT Id, Case_Type__c FROM acct_case_custom_rollup__c WHERE Case__r.Id IN :listTestCases]); 
     			
        System.assertEquals (true, listTestAcctCaseResults1.isEmpty());
     	
     	listTestCases[0].Type = 'Product Support';     	
     	update listTestCases;
     	
     	// Should not have attempted to update the record because the Account ID is still null.
     	// No need to test as an exception would be thrown if we did try.
     	
     	// Now add an account
     	listTestCases[0].AccountId = acctTest.Id;     	
     	update listTestCases;
     	
     	List<acct_case_custom_rollup__c> listTestAcctCaseResults2 = new List<acct_case_custom_rollup__c>( 
     			[SELECT Id, Case_Type__c FROM acct_case_custom_rollup__c WHERE Case__r.Id IN :listTestCases ORDER BY Case_Type__c]); 
     			
     	System.assertEquals(1, listTestAcctCaseResults2.size());
     	                 	   
    }
    
    // ----------------------------------------------------------
	// Test6 - Case initially added with no Type
	// ----------------------------------------------------------
    static testMethod void Test6() 
    {
    	// Setup the Account
     	Account acctTest = new Account (Name = 'ACCRS Test Account 1');
     	insert acctTest;
     	
     	// Set up the Cases
     	List<Case> listTestCases = new List<Case>();
     	Case caseTest1 = new Case (AccountId = acctTest.Id,
     							   Origin = 'Web',
     	                           Subject = 'A');                                                  
     	
     	listTestCases.add(caseTest1);  
     	insert listTestCases;
     	     	
     	// Should still create the CRU record
     	List<acct_case_custom_rollup__c> listTestAcctCaseResults1 = new List<acct_case_custom_rollup__c>( 
     			[SELECT Id, Case_Type__c FROM acct_case_custom_rollup__c WHERE Case__r.Id IN :listTestCases]); 
     			
        System.assertEquals(1, listTestAcctCaseResults1.size());
     	
     	listTestCases[0].Type = 'Product Support';     	
     	update listTestCases;
     	
     	// Type should have been updated.
     	List<acct_case_custom_rollup__c> listTestAcctCaseResults2 = new List<acct_case_custom_rollup__c>( 
     			[SELECT Id, Case_Type__c FROM acct_case_custom_rollup__c WHERE Case__r.Id IN :listTestCases ORDER BY Case_Type__c]); 
     			
     	System.assertEquals('Product Support', listTestAcctCaseResults2[0].Case_Type__c);
     	                 	   
    }
    
   
}