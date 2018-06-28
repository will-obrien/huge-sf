global class batchUpdateCpeclaimns implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id from CPE_Claim__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<CPE_Claim__c> scope){
        
       
        
       if(!scope.isEmpty())
            update scope;
       
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}