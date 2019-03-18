/*********************************************************************
Name : TestCountOfRelatedObjectBatchClassEMEA
Created On : Feb 15, 2013  
Created By : JP
Description : Test Class for CountOfRelatedObjectBatchClassAPAC batch class
**********************************************************************/

@isTest

private class x_TestCountOfRelatedObjectBatchClassEMEA{

	//Improve code coverage
	public static void inactive(){
	}
	   
//Merge test class in TestCountOfRelatedObjectBatchClass
/*static testMethod void testBatchEMEA() {

   
   Test.StartTest();
   Account acc= new Account();
            acc.Name='TestAccountCountOfRelatedRecordsController ';
            acc.Last_modified_Date_by_non_admin__c=system.today();
            insert acc;
            
            
          
           Contact Con= new Contact();
            Con.LastName='John';         
            Con.Email='Test@testsite.com';
            Con.AccountId=acc.Id;
            insert Con;
            
              Opportunity opp1 = new Opportunity();
            opp1.Name = 'test1';
            opp1.AccountId = acc.Id;
            opp1.CloseDate = system.today();
            opp1.StageName = 'Qualification';
            opp1.CurrencyIsoCode = 'USD';
         
            insert opp1;
            
          Task objTask = new Task();
          objTask.Subject='Call';
        objTask.ActivityDate  =Date.today();
        objTask.Status='In Progress';
        objTask.Priority='High'; 
        objTask.whatid =acc.Id;
        insert objTask;
        
            Event objEvent = new Event();
     
        objEvent.Subject='Call';
        objEvent.ActivityDate  =Date.today();
        objEvent.StartDateTime=  Date.today();
        objEvent.EndDateTime=  Date.today().AddDays(5); 
         objEvent.whatid =acc.Id;
        insert objEvent;
        
        string body='hi this is a class';
        
      
           
            Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=acc.Id; 
        insert attach;
            
             Note nn= new Note();
           nn.ParentId = acc.Id;  
            nn.Title= 'Test Attachment for Parent';       
            insert nn; 
   
   
   CountOfRelatedObjectBatchClassEMEA   countforEMEA= new CountOfRelatedObjectBatchClassEMEA();

  countforEMEA.query='SELECT ID, Name, Ownerid ' + 'FROM Account ' + ' LIMIT 200';

   ID batchprocessid = Database.executeBatch(countforEMEA);
   Test.StopTest();


            

    }*/

}