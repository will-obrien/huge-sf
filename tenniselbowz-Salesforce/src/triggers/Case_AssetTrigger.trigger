trigger Case_AssetTrigger on Case_Asset__c (after insert, after update) {
	
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
		   Case_AssetTriggerHandler.onAfterInsert(trigger.oldMap, trigger.newMap);
		   
		if(trigger.isUpdate)
		   Case_AssetTriggerHandler.onAfterUpdate(trigger.oldMap, trigger.newMap);
	}

}