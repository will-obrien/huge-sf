trigger CaseTrigger on Case (before update) {

    if(trigger.isUpdate)
	{
		if(trigger.isBefore)
		{ 
			CsaseTriggerHandler.onBeforeUpdate(trigger.newMap, trigger.oldMap);
		}
	}

}