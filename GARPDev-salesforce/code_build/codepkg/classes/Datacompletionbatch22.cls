global class Datacompletionbatch22 implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Display_Invoice_Number__c,LEGACY_PurchasesRefNo__c,GARP_Invoice_Number__c from opportunity');
     }
    
    
    global void execute(Database.BatchableContext BC, List<opportunity> scope){
        
        List<Opportunity> lstOpp = new List<Opportunity>();
        for(opportunity obj : Scope)
        {
            if(obj.LEGACY_PurchasesRefNo__c != '' && (obj.Display_Invoice_Number__c != obj.LEGACY_PurchasesRefNo__c))
            {
                obj.Display_Invoice_Number__c = obj.LEGACY_PurchasesRefNo__c;
                lstOpp.add(obj);      
            }     
        }

        update lstOpp;

    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}