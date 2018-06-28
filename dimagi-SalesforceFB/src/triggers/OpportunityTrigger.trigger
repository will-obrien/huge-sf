trigger OpportunityTrigger on Opportunity (before insert, before update) {
	
	OpportunityTriggerSync.onOpportunityTrigger(Trigger.new);
}