trigger AccountTrigger on Account (before delete, before update, before insert, after insert) 
{
	if(TriggerUtility.limitAccountExecution == true){
				
				return;
		} 
	if(trigger.isDelete)
	{
		if(trigger.isBefore)
		{
			AccountTriggerHandler.onBeforeDelete(trigger.oldMap);
		}
	}
	
	if(trigger.isUpdate)
	{
		if(trigger.isBefore)
			AccountTriggerHandler.onBeforeUpdate(trigger.newMap, trigger.oldMap);
	}
	
	if(trigger.isInsert)
	{
		if(trigger.isBefore)
			AccountTriggerHandler.onBeforeInsert(trigger.new);
		if(trigger.isAfter)
			AccountTriggerHandler.onAfterInsert(trigger.newMap);
	}

}