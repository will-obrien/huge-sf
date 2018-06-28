trigger AddressTrigger on Address__c (before update, after update, before insert, before delete) {
	
	if(trigger.isUpdate)
	{
		if(trigger.isBefore)
			AddressTriggerHandler.onBeforeUpdate(trigger.newMap, trigger.oldMap);

		if(trigger.isAfter){
			AddressTriggerHandler.onAfterUpdate(trigger.newMap, trigger.oldMap);
		}
	}
	
	if(trigger.isDelete)
	{
		if(trigger.isBefore)
			AddressTriggerHandler.onBeforeDelete(trigger.oldMap);
	}
	
	if(trigger.isInsert)
	{
		if(trigger.isBefore)
			AddressTriggerHandler.onBeforeInsert(trigger.new);
	}

}