/*
  Test Class for createIACtrl
  **********************************************************
  Author: Mounika Sattu
  Audit History
  **********************************************************
  10/29/2014        Mounika Sattu       Created
  **********************************************************  
*/ 

@isTest
private with sharing class TestcreateIACtrl {
    Static Integer i = 0;
    @IsTest(OnInstall=false)
    public static void testIARecordCreation(){
    
        Project_Funding_Sources__c pfsObj = TestHelper.getPFS(true, i);
        PageReference page = new PageReference('/apex/createContract');
        page.getParameters().put('id',pfsObj.id);
        Test.setCurrentPageReference(page);  
        createIACtrl controller = new createIACtrl();
        
            Test.startTest();
            controller.insertInternalAllocation();            
            Test.stopTest(); 
        
        List<Contracts__c> contractLst = [Select Id,Name from Contracts__c WHERE Project_Funding__c = :pfsObj.Id]; 
       // System.assert(contractLst.size()==1);
    }
    
}