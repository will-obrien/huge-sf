trigger EventTrigger on Event (after insert, after update) {
	EventTriggerHandler handler = new EventTriggerHandler(Trigger.isExecuting, Trigger.size);
	
	if(Trigger.isInsert && Trigger.isAfter){
		handler.OnAfterInsert(Trigger.new);
		//EventTriggerHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
	}
	else if(Trigger.isUpdate && Trigger.isAfter){
		handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
		//EventTriggerHandler.OnAfterUpdateAsync(Trigger.newMap.keySet());
	}
	/*
	if(Trigger.isInsert && Trigger.isBefore){
		handler.OnBeforeInsert(Trigger.new);
	}
	
	
	else if(Trigger.isUpdate && Trigger.isBefore){
		handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
	}
	
	else if(Trigger.isDelete && Trigger.isBefore){
		handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
	}
	else if(Trigger.isDelete && Trigger.isAfter){
		handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
		//EventTriggerHandler.OnAfterDeleteAsync(Trigger.oldMap.keySet());
	}
	
	else if(Trigger.isUnDelete){
		handler.OnUndelete(Trigger.new);	
	}
	*/
}