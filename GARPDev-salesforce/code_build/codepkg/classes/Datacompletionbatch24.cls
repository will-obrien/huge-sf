global class Datacompletionbatch24 implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
    global updateids__c graRecordID = updateids__c.getInstance('GRA');
    global updateids__c garpRecordID = updateids__c.getInstance('GARP');
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Display_Invoice_Number__c,LEGACY_PurchasesRefNo__c,GARP_Invoice_Number__c from opportunity where LEGACY_PurchasesRefNo__c != null ');
     }
    
    
    global void execute(Database.BatchableContext BC, List<opportunity> scope){
        
        List<Opportunity> lstOpp = new List<Opportunity>();
        for(opportunity obj : Scope)
        {
            if(obj.LEGACY_PurchasesRefNo__c != '' && obj.LEGACY_PurchasesRefNo__c.startsWith('GRA'))
            {
                obj.ChargentSFA__Gateway__c = graRecordID.Record_id__c;
                lstOpp.add(obj);      
            }
            else if (obj.LEGACY_PurchasesRefNo__c != '')  {
            
             obj.ChargentSFA__Gateway__c = garpRecordID.Record_id__c;
                lstOpp.add(obj);
            
            }
               
        }

        update lstOpp;

    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}