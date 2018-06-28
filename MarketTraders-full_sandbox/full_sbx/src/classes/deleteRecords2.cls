global class deleteRecords2 implements Database.Batchable<sObject>{    

    global Database.QueryLocator start(Database.BatchableContext BC){                            
        return Database.getQueryLocator([select id from Task LIMIT 900000]);
    }

    global void execute(Database.BatchableContext BC,List<task> scope){
        
        delete scope;
            
   }
        
    global void finish(Database.BatchableContext BC){
       system.debug('All deleted');
    }
  
}