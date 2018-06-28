trigger hqInt_Accounting_SubscriptionAdjTrigger on Accounting_SubscriptionAdjustment__c (after insert, after update) {

    String serverName = trigger.new[0].Server_Name__c;
    Map <String,String> mapSubcriptionIdToCreatedBy = new Map <String,String>();

    for(Accounting_SubscriptionAdjustment__c triggRec : trigger.new) {
        if(triggRec.subscription__c != null) {
            mapSubcriptionIdToCreatedBy.put(triggRec.subscription__c,'Unknown');
        }
    }

    for(Accounting_Subscription__c subscription : [SELECT id,(SELECT id,method__c FROM Accounting_SubscriptionAdjustment__r
                                                  WHERE reason__c = 'CREATE' order by date_created__c limit 1)
                                                  FROM Accounting_Subscription__c WHERE id in :mapSubcriptionIdToCreatedBy.keySet()
                                                  AND Server_Name__c =: serverName]) {
        if(subscription.Accounting_SubscriptionAdjustment__r != null && subscription.Accounting_SubscriptionAdjustment__r.size() > 0) {
            mapSubcriptionIdToCreatedBy.put(subscription.id,subscription.Accounting_SubscriptionAdjustment__r[0].method__c);
        }
}

    List <Accounting_Subscription__c> listSubscRecs = new List <Accounting_Subscription__c>();
    for(String subscriptionId : mapSubcriptionIdToCreatedBy.keySet()) {
        Accounting_Subscription__c subscription = new Accounting_Subscription__c(id = subscriptionid);
        subscription.Created_By__c = mapSubcriptionIdToCreatedBy.get(subscriptionId);
        listSubscRecs.add(subscription);
    }

    update listSubscRecs;
}