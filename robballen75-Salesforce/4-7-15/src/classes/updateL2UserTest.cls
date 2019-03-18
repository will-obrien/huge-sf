// *********************************************************************************** 
//
//  UpdateL2UserTest
//  
//  Test class for the UpdateL2UserSelect trigger.
//  
//  History:
//  1/04/2010 Robb Allen - Updated to support UI validation rule - if case status is set to escalated,
//  a user must be selected in the Assigned L2 field.
//  1/18/2010 Bob Nagy (InSitu Software) - Added support to set Case attributes which are
//  required in the UI (Account, Type, Subject) when creating the test Case.  Two of these
//  attributes are now required by the Account-Case Custom Rollup object and the custom
//  objects data management trigger will fail if they are not set at creation.
//	1/19/2010 Robb Allen - reworked test class to more accurately represent valid test case.
//	added asserts to validate expected behavior.  
//	1/19/2010 Robb Allen - Added bulk insert test
// ***********************************************************************************
@isTest
private class updateL2UserTest {

    static testMethod void myUnitTest()
    {
    	
    //Set up a list of users to use later in the test
    list<user> userList = [select id, name from user limit 2];
    string testUserName = userList.get(0).name;
    user testUserId = [select id from user where name  = :testUserName];

    test.starttest();
	
	// Setup a test Account
    Account acctTest = new Account (Name = 'updateL2UserTest Test Account 1');
    insert acctTest;
     	
    // Set up the Case
    // Added by Bob Nagy on 1/18/2010
    Case myCase = new Case (AccountId = acctTest.Id,
     	                    Origin = 'Web',
     	                    Type = 'Document Support',
     	                    Subject = 'Test',
     	                    Status = 'Open');
	 insert myCase;
	 	 
     //Now, change the status to Escalated, and set the assigned to user to be the test user.
     myCase.Status = 'Escalated to Tier2'; 
     myCase.Assigned_L2__c = testUserName;
     update myCase;
     
     //Validate that the assigned_l2_a__c field has been udpated to the SFDC user
     //associated to the testUserName
     case myCase2 = [select id, assigned_l2_a__c from case where id = :mycase.id]; 
     system.assertEquals(mycase2.assigned_l2_a__c, testUserId.id);
     
     //Set the assigned user picklist to one that will not exist as a valid SFDC user.
     myCase.Assigned_L2__c = 'Invalid User';
     update myCase;
     //Validate that the assigned_l2_a__c field has been cleared
     case myCase3 = [select id, assigned_l2_a__c from case where id = :mycase.id];
     system.assertEquals(myCase3.assigned_l2_a__c, null);
     
             test.stoptest();              
    }
    
    static testMethod void testBulkInsert() 
    {
    
    //Set up account and user to use in test cases below
    Account acctTest = new Account (Name = 'updateL2UserTest Test Account 1');
    insert acctTest;
    list<user> userList = [select id, name from user limit 2];
    string testUserName = userList.get(0).name;
   	

	//Create new list to hold 200 test cases
  
   	list <case> testCases = new list <case>();
   	for (Integer i=0;i<200;i++) 
   		{ 
 		case testCase = new case(AccountId = acctTest.Id,
     	                    Origin = 'Web',
     	                    Type = 'Document Support',
     	                    Subject = 'Test',
     	                    Status = 'Open', 
     	                    assigned_l2__c = testUserName);
     	                    
        testCases.add(testCase);
   	
   		}
   								
   test.starttest();
   		insert testCases;
   test.stoptest();

  
   }
    
    
}