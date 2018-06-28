global class Datacompletionbatch19 implements Database.Batchable<SObject>
{
    global Id cpeRecType = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','CPE');
    global Id attestRecType = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Attest');
    global Database.QueryLocator start(Database.BatchableContext BC){
        String today = date.today().format();
        return Database.getQueryLocator('select id,Approved_Credits__c,Status__c,recordTypeId,Candidate_Commitment__c from Candidate_Requirement__c where Candidate_Commitment__r.EndDate <= today and (recordTypeId =: cpeRecType or recordTypeId =: attestRecType)');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Candidate_Requirement__c> scope){

        Set<Id> setIds = new Set<Id>();
        for(Candidate_Requirement__c obj : scope)
        {
            if(obj.recordTypeId == cpeRecType && obj.Approved_Credits__c >= 40)
            {
                setIds.add(obj.Candidate_Commitment__c);
            }
        }

        List<Candidate_Requirement__c> lstCR = new List<Candidate_Requirement__c>();
        for(Candidate_Requirement__c objCR : [select id,Status__c from Candidate_Requirement__c where recordTypeId =: attestRecType and Status__c =: 'Initial'])
        {
            objCR.Status__c = 'Completed';
            lstCR.add(objCR);
        }

        if(lstCR.size() > 0)
            update lstCR;
    
    
    
    }
        

        
    
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}