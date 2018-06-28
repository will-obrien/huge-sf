global class CreateOppRecurringsBatch implements Database.Batchable<SObject>
{
   global Database.QueryLocator start(Database.BatchableContext BC){
        String strType = 'Charge';
        String strStatus = 'Approved';
        Boolean bRecurring = true; 
      return Database.getQueryLocator([select id,ChargentSFA__Opportunity__c,ChargentSFA__Response_Status__c,ChargentSFA__Type__c,ChargentSFA__Recurring__c,ChargentSFA__Gateway_Date__c from ChargentSFA__Transaction__c where ChargentSFA__Type__c =: strType and ChargentSFA__Response_Status__c =: strStatus and ChargentSFA__Recurring__c =: bRecurring and ChargentSFA__Gateway_Date__c != null and ChargentSFA__Gateway_Date__c = TODAY and ChargentSFA__Opportunity__c != null]);
     }
    
    
    global void execute(Database.BatchableContext BC, List<ChargentSFA__Transaction__c> scope){
        
        Set<Id> oppIds = new Set<Id>();
        List<ChargentSFA__Transaction__c> lstTrans = new List<ChargentSFA__Transaction__c>();
        for(ChargentSFA__Transaction__c trans : scope)
        {
                oppIds.add(trans.ChargentSFA__Opportunity__c);
                lstTrans.add(trans);

        }

        if(!oppIds.isEmpty())
        {
            CreateRecurringOpps.CreateOpps(oppIds,lstTrans);

        }
        
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}