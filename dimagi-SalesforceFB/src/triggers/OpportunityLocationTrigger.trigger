trigger OpportunityLocationTrigger on Opportunity_Location__c (before delete, after insert) {
	
	if (Trigger.isInsert) {
		OpportunityTriggerSync.onInsert(Trigger.new);
	}
	else if (Trigger.isDelete) {
		OpportunityTriggerSync.onDelete(Trigger.old);
	}
}