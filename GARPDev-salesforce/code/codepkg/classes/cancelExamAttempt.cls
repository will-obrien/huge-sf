global class cancelExamAttempt implements Database.Batchable<SObject>
{
    global string stagename = 'Closed Lost';
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id, Opportunity_StageName__c,Cancelled__c from Exam_Attempt__c where Opportunity_StageName__c =:stagename and Cancelled__c=false');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        
        List<Exam_Attempt__c> lstea = new List<Exam_Attempt__c>();
        for(Exam_Attempt__c obj : Scope)
        {
            obj.Cancelled__c = true;
                lstea.add(obj);
        }

        update lstea;

    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}