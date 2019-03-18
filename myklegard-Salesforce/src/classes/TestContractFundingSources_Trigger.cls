/*
  This class provided test coverage for the Contract Funding Source Trigger
  **********************************************************
  Author: Shrawan Raina
  Audit History
  **********************************************************
  07/02/2014        Shrawan Raina       Created
  07/24/2014        Shrawan Raina       Modified
  **********************************************************  
*/ 
@isTest
private class TestContractFundingSources_Trigger {
    Static Integer i = 1;
    @IsTest(OnInstall=false)
    public static void  insertSingleContractFundingSource(){
        User stdUser  = TestHelper.getStandardUser(true);
        Contract_Funding_Sources__c cfsObj = new Contract_Funding_Sources__c();
            Test.startTest();
            cfsObj = TestHelper.getCFS(true,i);
            Test.stopTest();
        List<AggregateResult> ContractAmount = new List<Aggregateresult>([SELECT SUM(Amount__c)TotalAmount 
                                                                FROM Contract_Funding_Sources__c WHERE Contract__c = :cfsObj.Contract__c]);
        Contracts__c contract = [SELECT Amount__c FROM Contracts__c WHERE Id = :cfsObj.Contract__c];
        List<AggregateResult> PFSAmount = new List<Aggregateresult>([SELECT SUM(Amount__c)TotalAmount FROM Contract_Funding_Sources__c 
                                                            WHERE Project_Funding_Source__c = :cfsObj.Project_Funding_Source__c ]);
        Project_Funding_Sources__c pfsObj = [SELECT Contract_Funding_Source_Total_Amount__c FROM Project_Funding_Sources__c WHERE 
                                                            Id = :cfsObj.Project_Funding_Source__c];
        System.assertEquals(ContractAmount[0].get('TotalAmount'),contract.Amount__c);
        System.assertEquals(PFSAmount[0].get('TotalAmount'),pfsObj.Contract_Funding_Source_Total_Amount__c);
    }

}