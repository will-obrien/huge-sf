/*
  This trigger will update the Contract Amount and Internal Allocation Amount on the Project_Funding_Sources__c object 
  **********************************************************
  Author: Shrawan Raina
  Audit History
  **********************************************************
  07/23/2014        Shrawan Raina       Created
  **********************************************************  
*/
trigger Contracts_Trigger on Contracts__c (after insert, after update, after delete) {
    Set<ID> pfsIds = new Set<ID>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Contracts__c cObj : Trigger.new){
            pfsIds.add(cObj.Project_Funding__c);
        }   
    }
    if(Trigger.isUpdate || Trigger.isDelete){
        for(Contracts__c cObj : Trigger.old){
            pfsIds.add(cObj.Project_Funding__c);
        }   
    }
    Map<ID, Project_Funding_Sources__c> projFundMap = new Map<ID, Project_Funding_Sources__c>([SELECT Id,Amount__c, Contract_Amount__c, Internal_Allocation_Amount__c FROM 
                                                                                                Project_Funding_Sources__c WHERE Id IN :pfsIds]);
    List<RecordType> contractRT = new List<RecordType>([SELECT Id FROM RecordType WHERE Name ='Contract' AND SobjectType ='Contracts__c' limit 1]);
    List<RecordType> internalAllocRT = new List<RecordType>([SELECT Id FROM RecordType WHERE Name ='Internal Allocation' AND SobjectType ='Contracts__c' limit 1]);
    for(AggregateResult internalAllocAmt : [SELECT Project_Funding__c, RecordTypeId, SUM(Amount__c)TotalAmount FROM Contracts__c WHERE Project_Funding__c IN :projFundMap.keySet() 
                                                                                                GROUP BY Project_Funding__c, RecordTypeId]){
        Project_Funding_Sources__c pfsObj = projFundMap.get(String.valueOf(internalAllocAmt.get('Project_Funding__c')));
        if(internalAllocAmt.get('RecordTypeId') == contractRT[0].Id){
            if(internalAllocAmt.get('TotalAmount') != null){
                pfsObj.Contract_Amount__c = Decimal.valueOf(String.valueOf(internalAllocAmt.get('TotalAmount')));  
            }
        }
        else if(internalAllocAmt.get('RecordTypeId') == internalAllocRT[0].Id){
            if(internalAllocAmt.get('TotalAmount') != null){
                pfsObj.Internal_Allocation_Amount__c = Decimal.valueOf(String.valueOf(internalAllocAmt.get('TotalAmount')));     
            }
        }
    }
    try{
        update projFundMap.values();    
    }
    catch(System.DMLException e) {
        System.debug('The following exception has occurred: ' + e.getMessage());
    }     
    
    /*Create new modify contracts for every contract creation*/
	 List<Modify_Contract__c> modContracts = new List<Modify_Contract__c>();
	if(Trigger.isInsert)
	{
        for(Contracts__c cObj : Trigger.new)
        {
			Modify_Contract__c newModContract = new Modify_Contract__c();
	        newModContract.Amount__c = cobj.Amount__c;
			newModContract.Use_of_Funds__c = cObj.Id;
	        newModContract.Contractor__c = cObj.Vendor__c;
	        newModContract.Project_Completion_Date__c = cObj.Project_Completion_Date__c; 
	        newModContract.Project_Funding__c = cObj.Project_Funding__c; 
	        newModContract.Status__c = cObj.Contract_status__c;
	        newModContract.Terms_conditions__c = cObj.Terms_Conditions__c;
			modContracts.add(newModContract);
	}		
      Insert modContracts;
    
	}                                          
}