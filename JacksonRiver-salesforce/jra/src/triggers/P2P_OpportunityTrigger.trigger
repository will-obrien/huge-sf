trigger P2P_OpportunityTrigger on Opportunity (after insert) {
	P2P_OpportunityTriggerHandler triggerHandler = new P2P_OpportunityTriggerHandler(TRUE);
	
	if (Trigger.isInsert && Trigger.isAfter) {
		triggerHandler.OnAfterInsert(Trigger.new);
	}
}