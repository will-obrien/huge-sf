global class deleteRecords implements Database.Batchable<sObject>{    

    global Database.QueryLocator start(Database.BatchableContext BC){                            
        return Database.getQueryLocator([select id from Opportunity_Owner_History__c ORDER BY CreatedDate ASC LIMIT 5000000]);
    }

    global void execute(Database.BatchableContext BC,List<Opportunity_Owner_History__c> scope){
        
        delete scope;
            
   }
        
    global void finish(Database.BatchableContext BC){
       system.debug('All deleted');
    }
  
}