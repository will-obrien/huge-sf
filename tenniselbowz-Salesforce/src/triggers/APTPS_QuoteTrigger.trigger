trigger APTPS_QuoteTrigger on Apttus_Proposal__Proposal__c (after insert, before insert, before update, after update) {
    
    if(trigger.isBefore) {
        if(trigger.isinsert) {
            APTPS_QuoteTriggerHandler.setQuoteDefaults(trigger.new);
            //APTPS_QuoteTriggerHandler.primaryQuoteUtility(trigger.new);
            //APTPS_QuoteTriggerHandler.primaryQuoteUtilityForLatinAmerica(trigger.new);
            APTPS_QuoteTriggerHandler.primaryQuoteUtility(trigger.new);
            APTPS_QuoteTriggerHandler.insertAtleastOnePrimaryProposal(Trigger.New);
        }
        if(trigger.isUpdate) {
            APTPS_QuoteTriggerHandler.concatenateTKClauses(Trigger.newMap, Trigger.oldMap);
            APTPS_QuoteTriggerHandler.primaryQuoteUtility(trigger.new);
            APTPS_QuoteTriggerHandler.updateAtleastOnePrimaryProposal(Trigger.New, Trigger.oldMap);
        }
        
    }
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            APTPS_QuoteTriggerHandler.createQuoteLineItems(Trigger.New);
        } 
        if(trigger.isUpdate) {
            APTPS_QuoteTriggerHandler.syncOldQuotesIfOpportunitiesChanged(Trigger.New, Trigger.oldMap);
            APTPS_QuoteTriggerHandler.updateQuotesToNotPrimary(Trigger.New, Trigger.oldMap);
            APTPS_QuoteTriggerHandler.synchronizeOpportunityLineItems(Trigger.New, Trigger.oldMap);
            APTPS_QuoteTriggerHandler.deleteDocLineItemsOfAcceptedQuotes(Trigger.New);
        }
        APTPS_QuoteTriggerHandler.syncQuotetoOpportunity(Trigger.newmap, Trigger.oldmap);
        //APTPS_QuoteTriggerHandler.primaryQuoteUtility(trigger.new);
        //APTPS_QuoteTriggerHandler.primaryQuoteUtilityForLatinAmerica(trigger.new);
    }
    
}