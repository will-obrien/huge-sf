/*
  Test Class for createContractCtrl
  **********************************************************
  Author: Shrawan Raina
  Audit History
  **********************************************************
  07/25/2014        Shrawan Raina       Created
  **********************************************************  
*/ 

@isTest
private with sharing class TestcreatePFCtrl {
    Static Integer i = 0;
    @IsTest(OnInstall=false)
    public static void testPFSRecordCreation(){
        Estimate_Planned__c estimate = TestHelper.getEstimate(true, i); 
        PageReference page = new PageReference('/apex/createPF');
        page.getParameters().put('id',estimate.id);
        Test.setCurrentPageReference(page);  
        createPFCtrl controller = new createPFCtrl();
        User u = TestHelper.getStandardUser(true);         
            Test.startTest();
            controller.insertProjectFunding();          
            Test.stopTest(); 
        
        List<Project_Funding_Sources__c> pfsList = [Select Id,Name from Project_Funding_Sources__c WHERE Project__c = :estimate.Project__c AND 
                                                Funding_Stream__c = :estimate.Funding_Stream__c]; 
        System.assert(pfsList.size()==1);
    }
    @IsTest(OnInstall=false)
    public static void testPFSRecordCreation1(){
        Estimate_Planned__c estimate = TestHelper.getEstimate1(true, i); 
        PageReference page = new PageReference('/apex/createPF');
        page.getParameters().put('id',estimate.id);
        Test.setCurrentPageReference(page);  
        createPFCtrl controller = new createPFCtrl();
        User u = TestHelper.getStandardUser(true);        
            Test.startTest();
            controller.insertProjectFunding();          
            Test.stopTest(); 
        
        List<Project_Funding_Sources__c> pfsList = [Select Id,Name from Project_Funding_Sources__c WHERE Project__c = :estimate.Project__c AND 
                                                Funding_Stream__c = :estimate.Funding_Stream__c]; 
    }
}