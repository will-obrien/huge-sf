trigger ContactTrigger on Contact (before delete, before update, after update, before insert, after insert) {
	if(TriggerUtility.limitContactExecution == true){
				
				return;
	} 
	if(trigger.isDelete)
	{
		if(trigger.isBefore)
		{
			ContactTriggerHandler.onBeforeDelete(trigger.oldMap);
		}
	}
	
	if(trigger.isUpdate) 
	{
		if(trigger.isBefore)
			ContactTriggerHandler.onBeforeUpdate(trigger.newMap, trigger.oldMap);
			
		if(trigger.isAfter)
			ContactTriggerHandler.onAfterUpdate(trigger.newMap, trigger.oldMap);
	}
	
	if(trigger.isInsert)
	{
		if(trigger.isBefore)
			ContactTriggerHandler.onBeforeInsert(trigger.new);
			
		if(trigger.isAfter)
			ContactTriggerHandler.onAfterInsert(trigger.newMap);
	}

}