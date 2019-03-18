trigger ProductTrigger on Product2 (before update) {

	if(trigger.isUpdate){
    	if(trigger.isBefore)
      		ProductTriggerHandler.onBeforeUpdate(trigger.newMap, trigger.oldMap);		//Passing old map values and new map values to the method onBeforeUpdate in the ProductTriggerHandler class
  	}
}