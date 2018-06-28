/**
   @Author - Anurag Ranjan
   
   @name - Test_updateReleaseLOE
   
   @CreateDate - 01/27/2014
   
   @Description - Test class to test the case scenarios for the trigger UpdateReleaseLOEonRequest
   				  It tests whether the estimates are recalculated for release record on 
   				  deletion/update/insertion of request records.
                  
   @Version - 1.0
   
   @reference - None
  */
@isTest
private class Test_updateReleaseLOE
{
    
    /**
    *  Description -  This a test method that test which test whether the estimates are recaculated 
    *				  for release record on insertion of request records.
    *
    *  @name - testInsertRequest
    *
    *  @param - None
    *
    *  @return - None
    *
    *  @throws exception- None
    */
    public static testMethod void testInsertRequest()
    {
		
		// this will store the request records which will be inserted
		List<Request__c> requestList = new List<Request__c>();
		
		// creating release record which will be the parent record for the requests record
		Release__c release = PMODataUnitHelper.insertReleaseForRequest('Test Release' + 1);
		
		// Inserting release record
		insert(release);
		
		// Creating request records
		for (Integer countRequest = 0; countRequest < 200; countRequest++)
		{
			Request__c currentRequest = PMODataUnitHelper.insertRequest('Test Request' + countRequest,release.Id);
			requestList.add(currentRequest);
		}	
		
		// Test scenario starts here
		Test.startTest();
		
		// Inserting list of requests
		insert(requestList);	
		
		// Test scenario ends here
		Test.stopTest();
		
		// Retreiving the inserted request records
		List<Request__c> insertedRequest = [SELECT TotEst__c
											FROM Request__c
											WHERE Id IN: requestList];
		
		// Checking if the size of reteived records is equal or not to size of inserted records
		System.assertEquals(requestList.size(),200,'Number of request record returned is incorrect.The result has '+ 
				requestList.size()+' records-Expected 200');
		
		// Retreiving the inserted release record		
		Release__c insertedRelease = [SELECT Total_Estimate__c
									  FROM Release__c
									  WHERE Id =: release.id];
											
		// Checking if the total estimate of the release records is equal to sum of total estimate of all request records
		System.assertEquals(insertedRelease.Total_Estimate__c,1400,'Estimate total returned is incorrect.The total estimate is '+ 
					insertedRelease.Total_Estimate__c +' Total Estimate-Expected 1400');
		
		
    }
    
    
    /**
    *  Description -  This a test method that test which test whether the estimates are recaculated 
    *				  for release record on update of request records.
    *
    *  @name - testUpdateRequest
    *
    *  @param - None
    *
    *  @return - None
    *
    *  @throws exception- None
    */    
    public static testMethod void testUpdateRequest()
    {
    	// this will store the request records which will be inserted
    	List<Request__c> requestList = new List<Request__c>();
    	
    	// this will store the request records which will be updated
    	List<Request__c> requestUpdateList = new List<Request__c>();
      	
		// creating release record which will be the parent record for the requests record      	
		Release__c release = PMODataUnitHelper.insertReleaseForRequest('Test Release' + 1);
		
		// Inserting release record
		insert(release);
		
		// Creating request records
		for (Integer countRequest = 0; countRequest < 200; countRequest++)
		{
			Request__c currentRequest = PMODataUnitHelper.insertRequest('Test Request' + countRequest,release.Id);
			requestList.add(currentRequest);
		}	
		
		// inserting request records
		insert(requestList);	
		
		// updating the requirement estimate for the inserted records
		for (Request__c currentRequest : requestList)
		{
			Request__c requestUpdate = new Request__c();
			requestUpdate = PMODataUnitHelper.updateRequest(currentRequest);
			requestUpdateList.add(requestUpdate);
		}
		
		// Test scenario starts here
		Test.startTest();
		
		// updating the request records
		update(requestUpdateList);
		
		// Test scenario ends here	
		Test.stopTest();
		
		// Retreiving the updated records		
		List<Request__c> updatedRequest = [SELECT TotEst__c
										   FROM Request__c
										   WHERE Id IN: requestUpdateList];
		
		// Checking if the size of updated records is equal or not to size of inserted records		
		System.assertEquals(requestList.size(),200,'Number of request record returned is incorrect.The result has '+ 
				requestList.size()+' records-Expected 200');
		
		// Retreiving the updated release record	
		Release__c updatedRelease = [SELECT Total_Estimate__c
									 FROM Release__c
									 WHERE Id =: release.id];

		// Checking if the total estimate of the release records is equal to sum of total estimate of all updated request records
		System.assertEquals(updatedRelease.Total_Estimate__c,1600,'Estimate total returned is incorrect.The total estimate is '+ 
					updatedRelease.Total_Estimate__c +' Total Estimate-Expected 1600');
		
		
    }
    
    
    /**
    *  Description -  This a test method that test which test whether the estimates are recaculated 
    *				  for release record on delete of request records.
    *
    *  @name - testDeleteRequest
    *
    *  @param - None
    *
    *  @return - None
    *
    *  @throws exception- None
    */      
    public static testMethod void testDeleteRequest()
    {
    	
    	// this will store the request records which will be inserted
    	List<Request__c> requestList = new List<Request__c>();
      	
		// creating release record which will be the parent record for the requests record      	
		Release__c release = PMODataUnitHelper.insertReleaseForRequest('Test Release' + 1);
		
		// Inserting release record
		insert(release);
		
		// Creating request records
		for (Integer countRequest = 0; countRequest < 200; countRequest++)
		{
			Request__c currentRequest = PMODataUnitHelper.insertRequest('Test Request' + countRequest,release.Id);
			requestList.add(currentRequest);
		}	
		
		// inserting request records
		insert(requestList);		
		
		// reteving request records for deleting
		List<Request__c> requestDeleteList = [SELECT TotEst__c
											  FROM Request__c
											  WHERE Id IN: requestList
											  LIMIT 100]	;	

		// Test scenario starts here
		Test.startTest();
		
		// deleting the request records
		delete(requestDeleteList);	
		
		// Test scenario ends here	
		Test.stopTest();
		
		// Retreiving the updated release record		
		Release__c updatedRelease = [SELECT Total_Estimate__c
									 FROM Release__c
									 WHERE Id =: release.id];
		
		// Checking if the total estimate of the release records is equal to sum of total estimate of all remaining request records
		System.assertEquals(updatedRelease.Total_Estimate__c,700,'Estimate total returned is incorrect.The total estimate is '+ 
					updatedRelease.Total_Estimate__c +' Total Estimate-Expected 700');
		
    }
    
}