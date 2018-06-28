global class createBillingBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public String query;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> objLogs){
        
        //Database.DMLOptions dmo = new Database.DMLOptions();
        //dmo.assignmentRuleHeader.useDefaultRule = true;
       
        System.debug('****Start Log Process****');
        for(sObject sobj:objLogs){
            opportunity logRec = (opportunity)sobj;
            
            billing.createBillings(logRec.id);
       
        }
    
        System.debug('****End Log Process****');
    }
    
    global void finish(Database.BatchableContext BC){}
}