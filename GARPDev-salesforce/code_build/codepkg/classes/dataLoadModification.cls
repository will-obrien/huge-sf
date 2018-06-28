global class dataLoadModification implements Database.Batchable<SObject>
{
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        Set<Id> setRecordTypes = new Set<Id>();
        setRecordTypes.add(RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Exam'));
        setRecordTypes.add(RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Job Experience'));
        setRecordTypes.add(RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','FRM Program'));
        setRecordTypes.add(RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','ERP Program'));
        return Database.getQueryLocator('select id, Status__c, RecordTypeId, Candidate_Commitment__c, Date_of_Completion__c, Name from Candidate_Requirement__c where recordTypeId in: setRecordTypes');
        
     }
    
    
    global void execute(Database.BatchableContext BC, List<Candidate_Requirement__c> scope){
    
       update scope;
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}