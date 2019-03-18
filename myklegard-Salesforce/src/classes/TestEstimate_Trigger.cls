/*
  This class provided test coverage for the Estimate Trigger
  **********************************************************
  Author: Shrawan Raina
  Audit History
  **********************************************************
  07/21/2014        Shrawan Raina       Created
  07/24/2014        Shrawan Raina       Modified
  **********************************************************  
*/ 
@isTest
private class TestEstimate_Trigger {
    Static Integer i = 0;
    @IsTest(OnInstall=false)
    public static void  insertEstimate(){
        User stdUser  = TestHelper.getStandardUser(true);
        Estimate_Planned__c estObj = new Estimate_Planned__c();
            Test.startTest();
            estObj = TestHelper.getEstimate(true, i);
            Test.stopTest();
        Project__c project = [SELECT Portfolio_Manager__c FROM Project__c WHERE Id = :estObj.Project__c];
        Estimate_Planned__c estimate = [SELECT Project_Portfolio_Manager__c FROM Estimate_Planned__c WHERE Id = :estObj.Id];
        System.assertEquals(estimate.Project_Portfolio_Manager__c,project.Portfolio_Manager__c);
    }
   /*   @IsTest(OnInstall=false)
    public static void  insertEstimate1(){
        User stdUser  = TestHelper.getStandardUser(true);
        Estimate_Planned__c estObj = new Estimate_Planned__c();
        System.runAs(stdUser){
            Test.startTest();
            estObj = TestHelper.getEstimate1(true, i);
            Test.stopTest();
        }
        Project__c project = [SELECT Portfolio_Manager__c FROM Project__c WHERE Id = :estObj.Project__c];
        Estimate_Planned__c estimate = [SELECT Project_Portfolio_Manager__c FROM Estimate_Planned__c WHERE Id = :estObj.Id];
        System.assertEquals(estimate.Project_Portfolio_Manager__c,project.Portfolio_Manager__c);
    }  */

}