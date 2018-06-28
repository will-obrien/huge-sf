trigger ClubEventTrigger on Club_Event__c (after insert, after update, after delete) {
	if(Trigger.isAfter) {
		if(Trigger.isInsert) {
			ClubEventTriggerHandler.afterInsert(Trigger.new);
		}
		else if(Trigger.isUpdate) {
			ClubEventTriggerHandler.afterUpdate(Trigger.new);
		}
		else if(Trigger.isDelete) {
			ClubEventTriggerHandler.afterDelete(Trigger.old);
		}
	}
}