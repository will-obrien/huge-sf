/*
  This trigger will update the Amount on Contracts__c objects
  as the sum total of all the Amount on the Contract Funding Source Object under the contract.
  **********************************************************
  Author: Shrawan Raina
  Audit History
  **********************************************************
  06/13/2014    Shrawan Raina    Created
  07/23/2014    Shrawan Raina    Modified
  **********************************************************  
*/ 
trigger ContractFundingSources_Trigger on Contract_Funding_Sources__c (after insert, after update, after delete) {
    Set<ID> contractIds = new Set<Id>();
    Set<ID> pfsIds = new Set<Id>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Contract_Funding_Sources__c cfsObj: Trigger.new){
            contractIds.add(cfsObj.Contract__c);
            pfsIds.add(cfsObj.Project_Funding_Source__c);
        }
    }
    if(Trigger.isDelete || Trigger.isUpdate){
        for(Contract_Funding_Sources__c cfsObj: Trigger.old){
            contractIds.add(cfsObj.Contract__c);
            pfsIds.add(cfsObj.Project_Funding_Source__c);
        }
    } 
    //Storing parent contract detail in a Map for quick lookup.
    Map<ID, Contracts__c> contractMap = new Map<ID,Contracts__c>([SELECT Id,Amount__c FROM Contracts__c WHERE Id IN :contractIds]);
    //Storing Project Funding Source detail in a Map for quick lookup.
    Map<ID, Project_Funding_Sources__c> pfsMap = new Map<ID,Project_Funding_Sources__c>([SELECT Id,Contract_Funding_Source_Total_Amount__c 
                                                                                                        FROM Project_Funding_Sources__c WHERE Id IN :pfsIds]);
    for(AggregateResult contractAmt : [SELECT Contract__c,SUM(Amount__c)TotalAmount FROM Contract_Funding_Sources__c WHERE Contract__c IN :contractMap.keySet() 
                                        GROUP BY Contract__c]){
        Contracts__c contract = contractMap.get(String.valueOf(contractAmt.get('Contract__c')));
        if(contractAmt.get('TotalAmount') != null){
            contract.Amount__c = Decimal.valueOf(String.valueOf(contractAmt.get('TotalAmount')));   
        }
    }
    for (AggregateResult pfsAmt : [SELECT Project_Funding_Source__c, SUM(Amount__c)TotalAmount FROM Contract_Funding_Sources__c WHERE 
                                        Project_Funding_Source__c IN :pfsMap.keySet() GROUP BY Project_Funding_Source__c]){
        Project_Funding_Sources__c pfsObj = pfsMap.get(String.valueOf(pfsAmt.get('Project_Funding_Source__c')));
        if(pfsAmt.get('TotalAmount') != null){
            pfsObj.Contract_Funding_Source_Total_Amount__c = Decimal.valueOf(String.valueOf(pfsAmt.get('TotalAmount')));    
        }
    }
    try{
        update contractMap.values();
        update pfsMap.values(); 
    }
    catch(System.DMLException e) {
        System.debug('The following exception has occurred: ' + e.getMessage());
    }
}