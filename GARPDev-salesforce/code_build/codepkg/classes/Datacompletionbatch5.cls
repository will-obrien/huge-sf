global class Datacompletionbatch5 implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,LEGACY_PurchasesRefNo__c,PriceBook2id,Display_Invoice_Number__c from Opportunity where LEGACY_PurchasesRefNo__c != null');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        List<Opportunity> lstOpp = new List<Opportunity>();
        for(Opportunity opp : scope)
        {
            if(opp.PriceBook2id == null)
                opp.PriceBook2id = Default_Settings__c.getValues('Default').Record_id__c;
            opp.Display_Invoice_Number__c = opp.LEGACY_PurchasesRefNo__c;
            
            lstOpp.add(opp);
        }
        
        if(lstOpp.size() > 0)
            update lstOpp;
        
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}