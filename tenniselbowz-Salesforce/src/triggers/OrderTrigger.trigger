trigger OrderTrigger on Order__c (after update) {
	if(trigger.isUpdate)
    {
    	if(trigger.isAfter)
        {
            OrderTriggerHandler.onAfterUpdate(trigger.newMap, trigger.oldMap);
        }
    }
}