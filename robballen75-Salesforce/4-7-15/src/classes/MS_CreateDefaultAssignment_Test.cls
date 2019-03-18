/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class MS_CreateDefaultAssignment_Test {

    static testMethod void myUnitTest() {
    	
    	 //Set up an acct to use later in the test
    account acct  = new account();
		acct.name = 'Test Company';
		acct.Industry = 'Law Firm - UK(House)';
		acct.BillingCountry='France';
		insert acct;	
        	
        test.starttest();
    
    
  /*
       ms_project__c p1 = new ms_project__c();
       p1.Name = 'Test Proj 1';
       p1.Account__c = acct.Id;
       p1.Project_Start_Date__c = date.today();
       p1.Project_Hours__c = 16;
       p1.MS_AutoGenAssignments__c = 'OPE';
       insert p1;
       
       ms_assignment__c assignment1 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p1.Id and Area_of_Effort__c = 'Plan'];
       system.assertEquals(0, assignment1.Hours_Assigned__c);
       
       ms_assignment__c assignment2 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p1.Id and Area_of_Effort__c = 'Design'];
       system.assertEquals(0, assignment2.Hours_Assigned__c);
       
       ms_assignment__c assignment3 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p1.Id and Area_of_Effort__c = 'Travel'];
       system.assertEquals(0, assignment3.Hours_Assigned__c);
  */     
       ms_project__c p2 = new ms_project__c();
       p2.Name = 'Test Proj 1';
       p2.Account__c = acct.Id;
       p2.Project_Start_Date__c = date.today();
       p2.Project_Hours__c = 16;
      // p2.MS_AutoGenAssignments__c = 'Standard';
       insert p2;
       
       ms_assignment__c assignment4 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p2.Id and Area_of_Effort__c = 'Project Management'];
       system.assertEquals(0, assignment4.Hours_Assigned__c);
       
       ms_assignment__c assignment5 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p2.Id and Area_of_Effort__c = 'Discovery/Analysis'];
       system.assertEquals(0, assignment5.Hours_Assigned__c);
       
       ms_assignment__c assignment6 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p2.Id and Area_of_Effort__c = 'Build'];
       system.assertEquals(0, assignment6.Hours_Assigned__c);
       
       ms_assignment__c assignment7 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p2.Id and Area_of_Effort__c = 'Troubleshoot/Support'];
       system.assertEquals(0, assignment7.Hours_Assigned__c);
       
       ms_assignment__c assignment8 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p2.Id and Area_of_Effort__c = 'Train'];
       system.assertEquals(0, assignment8.Hours_Assigned__c);
       
       ms_assignment__c assignment10 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p2.Id and Area_of_Effort__c = 'Design'];
       system.assertEquals(0, assignment10.Hours_Assigned__c);
       
       ms_assignment__c assignment11 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p2.Id and Area_of_Effort__c = 'Desktop Deployment'];
       system.assertEquals(0, assignment11.Hours_Assigned__c);
       
       ms_assignment__c assignment12 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p2.Id and Area_of_Effort__c = 'Document'];
       system.assertEquals(0, assignment12.Hours_Assigned__c);
       
       ms_assignment__c assignment13 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p2.Id and Area_of_Effort__c = 'Test'];
       system.assertEquals(0, assignment13.Hours_Assigned__c);
       
       ms_assignment__c assignment14 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p2.Id and Area_of_Effort__c = 'Validation & Feedback'];
       system.assertEquals(0, assignment14.Hours_Assigned__c);
     
       ms_assignment__c assignment15 = [select id, Hours_Assigned__c,Area_of_Effort__c from ms_assignment__c where project__c = :p2.Id and Area_of_Effort__c = 'Scope'];
       system.assertEquals(0, assignment15.Hours_Assigned__c);
       
       test.stoptest();
    }
}