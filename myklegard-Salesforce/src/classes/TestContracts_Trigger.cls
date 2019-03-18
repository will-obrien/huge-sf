/*
  This class provided test coverage for the Contracts Trigger
  **********************************************************
  Author: Shrawan Raina
  Audit History
  **********************************************************
  07/24/2014        Shrawan Raina       Created
  **********************************************************  
*/ 
@isTest
private with sharing class TestContracts_Trigger {
    Static Integer i = 1;
    @IsTest(OnInstall=false)
    public static void  insertBulkContracts(){
        User stdUser  = TestHelper.getStandardUser(true);
        Project_Funding_Sources__c pfsObj = new Project_Funding_Sources__c();
        List<Contracts__c> contractList = new List<Contracts__c>();
        List<RecordType> contractRT = new List<RecordType>([SELECT Id FROM RecordType WHERE Name ='Contract' AND SobjectType ='Contracts__c' limit 1]);
        List<RecordType> internalAllocRT = new List<RecordType>([SELECT Id FROM RecordType WHERE Name ='Internal Allocation' AND SobjectType ='Contracts__c' limit 1]); 
        System.runAs(stdUser){
            pfsObj = TestHelper.getPFS(true, i);
            for(Integer j=0; j<1; j++){
                Contracts__c contract = new Contracts__c(Project__c = pfsObj.Project__c, Project_Funding__c = pfsObj.Id, RecordTypeId = contractRT[0].Id, 
                                            Amount__c = 10+j);
                Contracts__c internalAlloc = new Contracts__c(Project__c = pfsObj.Project__c, Project_Funding__c = pfsObj.Id, RecordTypeId = internalAllocRT[0].Id, 
                                            Amount__c = 20+j);  
                contractList.add(contract);
                contractList.add(internalAlloc);
            }
            Test.startTest();
            insert contractList;
            Test.stopTest();
            /*List<AggregateResult> contractAmt = new List<AggregateResult>([SELECT SUM(Amount__c)TotalAmount FROM Contracts__c WHERE RecordTypeId = :contractRT[0].Id 
                                                    AND Id IN :contractList]);
            List<AggregateResult> internalAllocAmt = new List<AggregateResult>([SELECT SUM(Amount__c)TotalAmount FROM Contracts__c WHERE 
                                                    RecordTypeId = :internalAllocRT[0].Id AND Id IN :contractList]);*/
            Project_Funding_Sources__c pfsAmount = [SELECT Contract_Amount__c,Internal_Allocation_Amount__c FROM Project_Funding_Sources__c WHERE Id = :pfsObj.Id LIMIT 1];
            /*System.assertEquals(contractAmt[0].get('TotalAmount'), pfsAmount.Contract_Amount__c);
            System.assertEquals(internalAllocAmt[0].get('TotalAmount'), pfsAmount.Internal_Allocation_Amount__c);*/
            System.assertEquals(10, pfsAmount.Contract_Amount__c);
            System.assertEquals(20, pfsAmount.Internal_Allocation_Amount__c);
        }
    }    
}