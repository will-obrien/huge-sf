global class Datecompleteionmodification implements Database.Batchable<SObject>
{
  
    global Database.QueryLocator start(Database.BatchableContext BC){
       
        return Database.getQueryLocator('select id from Exam_Attempt__c ');
        
     }
    
    
    global void execute(Database.BatchableContext BC, List< Exam_Attempt__c > scope){
    
       update scope;
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}