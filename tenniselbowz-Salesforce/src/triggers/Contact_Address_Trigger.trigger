trigger Contact_Address_Trigger on Contact_Address__c  (before update, before insert, after update, after insert) {
	
	if(TriggerUtility.limitIntegrationBatch == true
	  || TriggerUtility.limitContactAddressExecution == true){
				
			return;
	} 
		
	if(trigger.isBefore)
	{
		if(trigger.isInsert)
			Contact_Address_Trigger_Handler.onBeforeInsert(trigger.new);
		if(trigger.isUpdate)
			Contact_Address_Trigger_Handler.onBeforeUpdate(trigger.newMap, trigger.oldMap);
	}
	
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
			Contact_Address_Trigger_Handler.onAfterInsert(trigger.newMap);
		if(trigger.isUpdate)
			Contact_Address_Trigger_Handler.onAfterUpdate(trigger.newMap, trigger.oldMap);
	}
	

}