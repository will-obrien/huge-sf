/*
  Test Class for createMCCtrl
  **********************************************************
  Author: Mounika Sattu
  Audit History
  **********************************************************
  10/29/2014        Mounika Sattu       Created
  **********************************************************  
*/ 

@isTest
private with sharing class TestcreateMCCtrl {
    Static Integer i = 0;
    @IsTest(OnInstall=false)
    public static void testMCRecordCreation(){
        Project_Funding_Sources__c pfs = TestHelper.getPFS(true, i); 
        PageReference page = new PageReference('/apex/createMC');
        page.getParameters().put('id',pfs.id);
        Test.setCurrentPageReference(page);  
        createMCCtrl controller = new createMCCtrl();
        User u = TestHelper.getStandardUser(true);       
            Test.startTest();
            controller.modifyContracts();          
            Test.stopTest(); 
        
        List<Modify_Contract__c> pfsList = [Select Id,Name from Modify_Contract__c ]; 
        //System.assert(pfsList.size()>=1);
    }
}