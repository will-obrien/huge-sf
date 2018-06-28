// *********************************************************************************** 
//  UpdateERonCloseTest
//  
//  Test class for the updateERonClose trigger.
//   
//  History:
//  1/04/10 Robb Allen - Created
//  1/19/10 Robb Allen - Added more asserts to validate operation
// ***********************************************************************************
@isTest
private class updateERonCloseTest {

    static testMethod void myUnitTest() {
    test.starttest();

	//Create ER to test with, set required short description.
		Enhancement_Request__c myEr = new Enhancement_Request__c();
	
		myer.name = 'This is the ER name';
		myEr.Long_Description__c = 'This is the long description';
		insert myEr;

	//Set resolution to fixed and supply a fixed in version and save.
	//Status should be set to "Closed", closed by user should be current user.
		myEr.ER_Resolution__c = 'Fixed';
		myEr.ER_Fixed_In_Version__c = 'V1';
		update myEr;
	
	//Collect status of ER and current user.	
		string erStatus = myEr.ER_Status__c;
		string currentUser = UserInfo.getUserId();
		
	//Assert that the ER is now closed, and the closed by user is correct	
		enhancement_request__c myEr2 = [select id, ER_status__c, er_closed_by__c from enhancement_request__c where id = :myEr.id];
		system.assertEquals('Closed',myEr2.ER_Status__c);
		system.assertEquals(myEr2.ER_Closed_By__c,currentUser);

	
	//Clear out resolution - this should also clear the closed by and closed date fields.
	//and set the status to Reopened.
		myEr.ER_Resolution__c = null;
		update myEr;
		
	//Assert that the closed by and closed dates have been cleared.
		enhancement_request__c myEr3 = [select id, ER_Status__c, er_closed_by__c,ER_Close_Date__c from enhancement_request__c where id = :myEr.id];
		system.assertEquals(myER3.ER_Closed_By__c,null);
		system.assertEquals(myER3.ER_Close_Date__c, null);
		system.assertEquals(myEr3.ER_Status__c, 'Reopened');

test.stoptest();         
 
}

static testMethod void testBulkInsert()
	{
   
     	   
   	test.starttest();

		//Create new list to hold 200 test ERs
  		list <Enhancement_Request__c> ERs = new list <Enhancement_Request__c>();
   		for (Integer i=0;i<200;i++) 
 			ERs.add( new Enhancement_Request__c(name='xxxTest Short Descxxx', Long_Description__c = 'xxxTest Long Descxxx',Er_resolution__c = 'Closed'));
  
  		// Add the list of enhancements
   		insert ers;
   
   test.stoptest();

   }

}