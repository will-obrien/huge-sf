global class Datacompletionbatch2 implements Database.Batchable<SObject>
{
   global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Exam_Date__c,Candidate_Commitment__c,Result__c,Section__c,Cancelled__c,Candidate_Requirement__c from Exam_Attempt__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        Map<Id,Exam_Attempt__c> mapEA = new Map<Id,Exam_Attempt__c>();
        List<Exam_Attempt__c> lstExamAttempts = new List<Exam_Attempt__c>();
        for(Exam_Attempt__c obj : scope)
        {
             if(obj.Result__c == 'Pass')
                mapEA.put(obj.Candidate_Requirement__c,obj);
            
        }
        
        if(!mapEA.isEmpty())
        {
        
            List<Candidate_Requirement__c>  lstCR = new List<Candidate_Requirement__c>();
            for(Candidate_Requirement__c objCR : [select id,Name,Date_of_Completion__c,Status__c from Candidate_Requirement__c where id in: mapEA.keySet()])
            {
                Exam_Attempt__c objEA = mapEA.get(objCR.Id);
                if(objEA.Result__c == 'Pass')
                {
                    objCR.Date_of_Completion__c = mapEA.get(objCR.Id).Exam_Date__c;
                    objCR.Status__c = 'Completed';
                }
               lstCR.add(objCR);
            }
            if(!lstCR.isEmpty())
                update lstCR;
        }
        
        
        
        if(lstExamAttempts.size() > 0)
            update lstExamAttempts;
        
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}