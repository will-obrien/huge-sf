global class ReAssignLead implements Database.batchable<sObject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id, TF__c, LastActivityDate from Lead where IsConverted= False AND TF__c<26]);
        
    }
    global void execute(Database.BatchableContext BC, List<Lead> Ld){
        for(Lead L: Ld){
            if(L.TF__c==25 && L.LastActivityDate==Null){
                (L.OwnerId='00528000000EPws');   
            }
        }
        update Ld;      
    }
    global void finish(Database.BatchableContext BC){
        
    }
}