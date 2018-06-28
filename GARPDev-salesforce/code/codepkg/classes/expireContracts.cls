global class expireContracts implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        Set<String> setStatus = new Set<String>{'Initial'};
       Set<String> setExamName = new Set<String>{'FRM Full'};
       String strId = 'a1Je0000002M5R2';
        return Database.getQueryLocator('select id,Name,Candidate_Commitment__c,Candidate_Commitment__r.RecordTypeId,status__c,Exam__c from Candidate_Requirement__c where Status__c in: setStatus and Exam__c in: setExamName');

     }
    
    
    global void execute(Database.BatchableContext BC, List<Candidate_Requirement__c> scope){
    
        Set<Id> setContracts = new Set<Id>();
        for(Candidate_Requirement__c obj : scope)
            setContracts.add(obj.Candidate_Commitment__c);
        
        List<Contract> lstContract = new List<Contract>();
        for(Contract objContract : [select id,Status from Contract where id in: setContracts])
        {
            objContract.Status = 'Expired';
            lstContract.add(objContract);
            
        }
        
        update lstContract;
        
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}