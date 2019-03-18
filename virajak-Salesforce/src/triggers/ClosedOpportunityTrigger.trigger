trigger ClosedOpportunityTrigger on Opportunity (after insert,after update) {
    ClosedOpportunityTriggerHandler.doClosedOpp(Trigger.New);
}