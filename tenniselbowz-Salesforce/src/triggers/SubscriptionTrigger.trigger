trigger SubscriptionTrigger on Subscription__c (before insert, before delete, before update) {
    
    
    if(trigger.isBefore)
    {
        if(trigger.isUpdate)
            SubscriptionTriggerHandler.onBeforeUpdate(trigger.newMap, trigger.oldMap);
        
        if(trigger.isDelete)
            SubscriptionTriggerHandler.onBeforedelete(trigger.oldMap);
        
        if(trigger.isInsert)
            SubscriptionTriggerHandler.onBeforeInsert(trigger.new);
                    
    }

}