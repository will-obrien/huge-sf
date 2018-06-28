global class batchClosePendingOpportunities implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date dt = Date.today().addmonths(-6);
        
        String stageName = 'New Lead'; 
        return Database.getQueryLocator('select Id, StageName from Opportunity where StageName =: stageName  and  Purchase_Date__c <: dt');
    }
    
    
    global void execute(Database.BatchableContext bc, List<Opportunity> opps){
        list<opportunity> oppids = new list<opportunity>();
        for(Opportunity opp : opps)
        {
            opp.StageName = 'Closed Lost';
            oppids.add(opp);
            
        }
        
        update oppids;
            
    }

    global void finish(Database.BatchableContext bc){
           
    }

}