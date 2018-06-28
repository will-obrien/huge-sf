trigger CreateOppForRecuring on ChargentSFA__Transaction__c(after insert) {

    Set<Id> setIds = new Set<Id>();
    Set<Id> oppIds = new Set<Id>();
    Set<Id> paymentid = new Set<Id>();
    List<Opportunity> lstOpps = new List<Opportunity>();
    for(ChargentSFA__Transaction__c obj : trigger.new)
    {
        if(obj.ChargentSFA__Type__c == 'Charge' && obj.ChargentSFA__Response_Status__c == 'Approved' && obj.ChargentSFA__Recurring__c == true)
            oppIds.add(obj.ChargentSFA__Opportunity__c);
        
    }

    if(!CreateRecurringOpps.bIsRecursive && oppIds.size() > 0)
        CreateRecurringOpps.CreateOpps(oppIds,trigger.new);
   

}