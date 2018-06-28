global class TokenModification implements Database.Batchable<SObject>
{   
     
    global Database.QueryLocator start(Database.BatchableContext BC){
        String strStatus = 'Recurring';
            return Database.getQueryLocator('select id,ChargentSFA__Payment_Status__c,ChargentSFA__Tokenization__c from opportunity where ChargentSFA__Payment_Status__c =: strStatus');
     }
    
    
    global void execute(Database.BatchableContext BC, List<opportunity> scope){
       
        Map<Id,ChargentSFA__Transaction__c> mapTransaction = new Map<Id,ChargentSFA__Transaction__c>();
        for(ChargentSFA__Transaction__c trans : [select id,ChargentSFA__Response_Status__c,ChargentSFA__Type__c,ChargentSFA__Payment_Method__c,ChargentSFA__Tokenization__c from ChargentSFA__Transaction__c where ChargentSFA__Response_Status__c =: 'Approved' and ChargentSFA__Type__c =: 'Charge' and ChargentSFA__Payment_Method__c =: 'Credit Card' and ChargentSFA__Opportunity__c in: scope order by LastModifiedDate DESC])
        {
            if(!mapTransaction.containsKey(trans.ChargentSFA__Opportunity__c))
                mapTransaction.put(trans.ChargentSFA__Opportunity__c,trans);

        }
        List<Opportunity> lstOpps = new List<Opportunity>();
        for(Opportunity opp : Scope)
        {
            ChargentSFA__Transaction__c tran = mapTransaction.get(opp.Id);
            if(opp.ChargentSFA__Tokenization__c != tran.ChargentSFA__Tokenization__c)
            {
                    opp.ChargentSFA__Tokenization__c = tran.ChargentSFA__Tokenization__c;
                    lstOpps.add(opp);

            }
        }

        if(!lstOpps.isEmpty())
            update lstOpps;

    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}