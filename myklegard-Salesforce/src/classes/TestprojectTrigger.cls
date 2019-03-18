/*
  This class provided test coverage for the Project Trigger
  **********************************************************
  Author: Charu Latha
  Audit History
  **********************************************************
  03/10/2015        Charu Latha       Created
  **********************************************************  
*/ 
@isTest
private with sharing class TestprojectTrigger { 
    @IsTest(OnInstall=false)
    public static void  insertProject(){
        User stdUser  = TestHelper.getStandardUser(true);
        
        Project__c newProj = new Project__c();        
        Test.startTest();
        newProj = TestHelper.getProject(true, 1);
        Test.stopTest();
        Project__c project = [SELECT Innovation_Coordinator__c, OwnerId FROM Project__c WHERE Id = :newProj.Id];
        System.assertEquals(project.Innovation_Coordinator__c,project.OwnerId);
        
        List<MileStone__c> lsMiles = [SELECT name from Milestone__c where project__c = :newProj.Id];
        system.assertnotequals(lsMiles.size(),0);
    }
}