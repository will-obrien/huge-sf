trigger EventLeaderTrigger on Event_Leader__c (before delete, before insert, before update) {
	if(Trigger.isInsert) {
		EventLeaderTriggerHandler.beforeInsertUpdate(Trigger.New, null);
	}
	else if(Trigger.isUpdate) {
		EventLeaderTriggerHandler.beforeInsertUpdate(Trigger.New, Trigger.oldMap);
	}
	else if(Trigger.isDelete) {
		EventLeaderTriggerHandler.beforeDelete(Trigger.Old);
	}
}