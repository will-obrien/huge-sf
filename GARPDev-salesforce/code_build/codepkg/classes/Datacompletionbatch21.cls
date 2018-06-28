global class Datacompletionbatch21 implements Database.Batchable<SObject>
{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator('select id,ChargentSFA__Amount__c from ChargentSFA__Transaction__c where Credit_Notes_Unique__c != null');
     }
    
    
    global void execute(Database.BatchableContext BC, List<ChargentSFA__Transaction__c> scope){

        Map<Id,Decimal> mapChargentAmounts = new Map<Id,Decimal>();
        for(AggregateResult ar : [select sum(Refund_amount__c),Payment_Transaction__c from Product_Refunds__c where Payment_Transaction__c in: scope group by Payment_Transaction__c])
        {
            decimal dAmt = (decimal)ar.get('expr0');
            Id paymentTransactionId = (id)ar.get('Payment_Transaction__c');
            mapChargentAmounts.put(paymentTransactionId,dAmt);

        }
        List<ChargentSFA__Transaction__c> lstTRansactions = new List<ChargentSFA__Transaction__c>();
        for(ChargentSFA__Transaction__c objTransaction : scope)
        {
            if(mapChargentAmounts != null)
            {
                objTransaction.ChargentSFA__Amount__c = mapChargentAmounts.get(objTransaction.Id);
                lstTRansactions.add(objTransaction);
            }

        }
        if(! lstTRansactions.isEmpty())
            update lstTRansactions;
    
    }
        
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}