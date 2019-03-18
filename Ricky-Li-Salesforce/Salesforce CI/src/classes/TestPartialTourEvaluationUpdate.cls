@isTest(SeeAllData=true)
Public class TestPartialTourEvaluationUpdate{
   static testmethod void EvalsUpdate(){
    //Partially Complete   
       Account acc = [Select Id from Account Limit 1];
       Service__c ser = [Select Id from Service__c Limit 1];
       
       //Create Tour Evaluation
       Tour_Evaluation__c te = new TOur_Evaluation__c(Account__c = acc.id, Service__c = ser.Id);
       te.Transportation_Rating__c = NULL;
       te.NPS_Rating__c = 8;
       te.Date_Completed__c = date.parse('12/12/2012');
       insert te;
       //Create Tour EValuation Historical Summary
       Tour_Evaluation_Historical_Summary__c tehs = new Tour_Evaluation_Historical_SUmmary__c(Tour_Evaluation__c = te.Id);
       insert tehs;
       
       tehs.Status__c = 'partially complete';

       
    //Incomplete
        Account acc1 = [Select Id from Account Limit 1];
        Service__c ser1 = [Select Id from Service__c Limit 1];
       
       //Create Tour Evaluation
       Tour_Evaluation__c te1 = new TOur_Evaluation__c(Account__c = acc.id, Service__c = ser.Id);
       te1.NPS_Rating__c = NULL;
       te1.Date_Completed__c = date.parse('12/12/2012');
       
       insert te1;
       
       //Create Tour EValuation Historical Summary
       Tour_Evaluation_Historical_Summary__c tehs1 = new Tour_Evaluation_Historical_SUmmary__c(Tour_Evaluation__c = te.Id);
       insert tehs1;
       
       tehs1.Status__c = 'Incomplete';
       
              
       //DML
       Test.startTest();
           update tehs;
           update tehs1;
       Test.StopTest();
       
       //Assert
       System.assertEquals(tehs1.Status__c, 'Incomplete');
       System.assertEquals(tehs.Status__c, 'partially complete');
       
       
   }  
}