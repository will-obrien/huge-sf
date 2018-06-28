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
private with sharing class TestcreateContractCtrl {
    Static Integer i = 0;
    @IsTest(OnInstall=false)
    public static void testContractRecordCreation(){
    
        Project_Funding_Sources__c pfsObj = TestHelper.getPFS(true, i);
        PageReference page = new PageReference('/apex/createContract');
        page.getParameters().put('id',pfsObj.id);
        Test.setCurrentPageReference(page);  
        createContractCtrl controller = new createContractCtrl();
        User u = TestHelper.getStandardUser(true);       
            Test.startTest();
            controller.insertContract();            
            Test.stopTest(); 
        
        List<Contracts__c> contractLst = [Select Id,Name from Contracts__c WHERE Project_Funding__c = :pfsObj.Id]; 
       // System.assert(contractLst.size()==1);
    }
    
}