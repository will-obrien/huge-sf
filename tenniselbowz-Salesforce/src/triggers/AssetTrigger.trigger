trigger AssetTrigger on Asset (after update, before update, after insert, before insert, before delete) {
    
    if(trigger.isUpdate)
    {
        if(trigger.isBefore)
           AssetTriggerHandler.onBeforeUpdate(trigger.new, trigger.oldMap);
        
        if(trigger.isAfter)
        {
            AssetTriggerHandler.onAfterUpdate(trigger.newMap, trigger.oldMap);
        }
    }
    
    if(trigger.isInsert)
    {
        if(trigger.isBefore)
        {
            AssetTriggerHandler.onBeforeInsert(trigger.new);
        }
        
        if(trigger.isAfter)
        {
            AssetTriggerHandler.onAfterInsert(trigger.newMap);
        }
    }
    
    if(trigger.isDelete)
    {
        if(trigger.isBefore)
        {
            AssetTriggerHandler.onBeforeDelete( trigger.oldMap);
        }
    }

}