trigger ProjectLocationTrigger on Project_Location__c (after insert, before delete) {


	if (Trigger.isInsert) {
		ProjectTriggerSync.onInsert(Trigger.new);
	}
	else if (Trigger.isDelete) {
		ProjectTriggerSync.onDelete(Trigger.old);
	}

}