@isTest(SeeAllData=true)
public class TestEvalDeletePart2 {    
    static testmethod void testEvalDelete() {
       
       /* Tour Eval Leader Deletes */
       List <Tour_Evaluation_Leader__c> listTourEvaluationLeader = [Select Id from Tour_Evaluation_Leader__c where CEO_Overall_Average__c = NULL Limit 9000];
       Delete listTourEvaluationLeader;
    
       Test.startTest();
            EvalsDelete ed = new EvalsDelete(); 
            ed.DeleteEvalLeaders();   
        Test.stopTest(); 
        
       /*Assert for Tour Evaluation Leader Purge*/
       List <Tour_Evaluation_Leader__c> listTestAssert = [Select Id from Tour_Evaluation_Leader__c where CEO_Overall_Average__c = NULL Limit 9000];
       //Assert
       System.AssertEquals(listTestAssert.size(), 0);
       System.Debug(listTestAssert.size());
    }
}