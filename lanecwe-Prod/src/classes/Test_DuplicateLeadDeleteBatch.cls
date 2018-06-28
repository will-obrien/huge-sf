/*********************************************************************
Name : Test_DuplicateLeadDeleteBatch 
Created On : dec 20 , 2011  
Created By : Lalit Bohra
Description : test class for providing test coverage to DuplicateLeadDeleteBatch Batch
**********************************************************************/
@isTest
private class Test_DuplicateLeadDeleteBatch {

    static testMethod void myUnitTest() {
    	 test.startTest();
        // TO DO: implement unit test
        list<Lead> LeadList = new list<Lead>();
        //for(Integer iCount=0;iCount<10;iCount++){
	        Lead objLead= new Lead();
	        objLead.Company='Test Company1';
	        objLead.LastName='Test Lead1';
	        objLead.Status='Open';
	        objLead.CurrencyIsoCode='USD';
	        objLead.IM_USER_ID__c='TestUser Id';
	        objLead.Phone='25678955';
	        //ObjLead.Email='Test121@testsite.com';    
	        ObjLead.To_be_Deleted__c=true;
	        LeadList.add(ObjLead);
        //}
      
         insert LeadList;         	
          
         
         DuplicateLeadDeleteBatch objDuplicateLeadDeleteBatch= new DuplicateLeadDeleteBatch();
         objDuplicateLeadDeleteBatch.LeadId=ObjLead.Id;
         database.executeBatch(objDuplicateLeadDeleteBatch,1);      
         test.stopTest();
    }
}