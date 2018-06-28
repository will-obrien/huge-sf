// *********************************************************************************** 
//  MS_updateAccountLastUpdateOnChangeTest
//  
//  Test class for the MS_UpdateAccountLastUpdateField trigger.
//   
//  History:
//  1/14/09 Robb Allen - Created
// ***********************************************************************************
@isTest
private class MS_UpdateAccountLastUpdateField_TEST 
{

	static testMethod void myUnitTest() 
	{
		string currentUser = UserInfo.getUserId();
	test.starttest();

		//Create Account to test with, set required fields
		account a = new account();
		a.name = 'Test Company';
		a.Industry = 'Other';
		insert a;
		
		//Assert that the at a glance last updated and udpated by are both null
		account a2 = [select id, at_a_glance_last_updated__c, MS_AtAGlanceLastUpdatedByUser__c from account where id = :a.id]; 
		system.assertEquals(null,a2.at_a_glance_last_updated__c);
		system.assertEquals(null,a2.MS_AtAGlanceLastUpdatedByUser__c);

		//clear field for next test
		a.at_a_glance_last_updated__c = null;
		update a;

		//Set customer since date to value - last updated should be set to today
		Date testdate = date.newInstance(2009,11,20);
		a.Customer_Since_Date__c = testdate;
		update a;

		//Assert that the last updated field is set to today and the last updated user is set
		//to the current user
		account a3 = [select id, at_a_glance_last_updated__c, MS_AtAGlanceLastUpdatedByUser__c from account where id = :a.id];
		system.debug('a3.accountid=' + a3.At_a_Glance_Last_Updated__c);
		system.assertEquals(a3.at_a_glance_last_updated__c, date.today());
		system.assertEquals(a3.MS_AtAGlanceLastUpdatedByUser__c, currentUser);

		//Clear last udpated field for next test
		a.at_a_glance_last_updated__c = null;
		a.MS_AtAGlanceLastUpdatedByUser__c = null;
		update a;

		//Set one of the account environment fields to a value - last updated should be set to today
		a.Primary_Operating_Systems__c = 'Windows XP';
		update a;
		
		//Assert that the last updated field is set to today and the last updated user is set
		//to the current user
		account a8 = [select id,MSAccountEnvironmentLast_Updated_By__c, last_updated__c from account where id = :a.id];
		system.assertEquals(a8.last_updated__c, date.today());
		system.assertEquals(a8.MSAccountEnvironmentLast_Updated_By__c, currentUser);

		//Clear last udpated field for next test
		a.at_a_glance_last_updated__c = null;
		a.MS_AtAGlanceLastUpdatedByUser__c = null;
		a.last_updated__c = null;
		a.MS_AtAGlanceLastUpdatedByUser__c = null;
		update a;


		//set a field that is not watched, and verify the last date is still null
		a.Website = 'http://test/com';
		update a;

		//Assert that the last updated date and by fields are still null
		account a4 = [select id, at_a_glance_last_updated__c,MS_AtAGlanceLastUpdatedByUser__c from account where id = :a.id];
		system.assertEquals(a4.at_a_glance_last_updated__c, null);	
		system.assertEquals(null,a4.MS_AtAGlanceLastUpdatedByUser__c);

		//Create another account and modify all fields the trigger looks for on insert, to ensure coverage.
		account a5 = new account();
		a5.name = 'Test Company';
		a5.industry = 'other';
		a5.Customer_Since_Date__c = testdate;
    	
    	
    	a5.DocXtools_Version__c = 'test';
    
	    a5.DocXtools_Deployment_Status__c  = 'test';
    	a5.DocXtools_Included_on_Desktop_Image__c = 'test';
	    a5.DocXtools_Deployed_Groups_NEW__c = 'test';
    	a5.DocXtools_Groups_Getting_High_Value__c  = 'test';
    	a5.Traffic_Signal_Deployed__c  = 'test';
    	a5.Skills_Assessment_Deployed_NEW__c  = 'test';
    	a5.Role_based_ribbon_s_deployed__c  = 'test';
	   
    	
    	a5.Primary_Operating_Systems__c= 'test';
    	a5.PrimaryWordProc__c = 'test';
    	a5.Email_System__c = 'test';
    	a5.DMS__c = 'test';
    	a5.Templates__c = 'test';
    	a5.Numbering_Tool__c = 'test';
    	a5.MetaData_Tool__c = 'test';
    	a5.Compare_Tool__c = 'test';
    	a5.TOA_Tool__c = 'test';
    	a5.X02007_Migration_Plan__c = 'test';
    	a5.Next_Office_Version__c = 'test';
    	
    	a5.Date_for_Word_2007__c =testdate;
    	a5.Date_for_2010__c =testdate;
    	
    	    
  		insert a5;
    	
		account a6 = [select id, at_a_glance_last_updated__c, last_updated__c from account where id = :a5.id];

		//Ensure the last modified field was updated 
		system.assertEquals(a6.at_a_glance_last_updated__c, date.today());
		system.assertEquals(a6.last_updated__c, date.today());

test.stoptest();         
 
	}
}