global class Cls_BatchCreateOpportHistryWeekly implements Database.Batchable<sObject>{
    

    global Database.QueryLocator start(Database.BatchableContext BC){                            
        return Database.getQueryLocator([select id,name,stagename,OwnerId,Product__c from opportunity where isclosed = false]);
    }
    
    

    global void execute(Database.BatchableContext BC,List<opportunity> scope){
    
        system.debug('*****scope****'+scope);
        system.debug('*****scope.size()****'+scope.size());
        List<Opportunity_Owner_History__c> OpportunityHistoryList = new List<Opportunity_Owner_History__c>();
        

        
        for(Opportunity opp : scope){
            Opportunity_Owner_History__c OppHistory = new Opportunity_Owner_History__c();
            OppHistory.Opportunity__c = opp.id;
            OppHistory.Stage__c = opp.StageName;            
            OppHistory.Type__c = 'Weekly';
            OppHistory.Product_List__c = opp.Product__c ;
            OppHistory.Date_Acquired__c = system.now();            

            OppHistory.User2__c = opp.OwnerId;
            
            OpportunityHistoryList.add(OppHistory);            
        }
        
        if(OpportunityHistoryList.size()>0){
            insert OpportunityHistoryList;
        }
        
        system.debug('*****OpportunityHistoryList.size()2222222****'+OpportunityHistoryList.size());
    }
    

    global void finish(Database.BatchableContext BC){

    }
 
   
}