trigger Account_Address_Trigger on Account_Address__c (before update, before insert, after update, after insert) {
	
	
	if(TriggerUtility.limitIntegrationBatch == true
		|| TriggerUtility.limitAccountAddressExecution == true){
				
			return;
	}
	
	if(trigger.isBefore)
	{ 
		if(trigger.isInsert)
			Account_Address_Trigger_Handler.onBeforeInsert(trigger.new);
		if(trigger.isUpdate)
			Account_Address_Trigger_Handler.onBeforeUpdate(trigger.newMap, trigger.oldMap);
	}
	
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
			Account_Address_Trigger_Handler.onAfterInsert(trigger.newMap);
		if(trigger.isUpdate)
			Account_Address_Trigger_Handler.onAfterUpdate(trigger.newMap, trigger.oldMap);
	}
	

}