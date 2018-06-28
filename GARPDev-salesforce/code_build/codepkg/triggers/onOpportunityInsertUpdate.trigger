trigger onOpportunityInsertUpdate on Opportunity (before update, before insert) {
   
    
   
    if(!OppTriggerUtil.bIsRecusrive)
        OppTriggerUtil.OppTriggerLogic(Trigger.new);
    
    
    
}