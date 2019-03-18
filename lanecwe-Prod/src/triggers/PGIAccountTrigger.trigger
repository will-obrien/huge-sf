/**
 * This generic trigger on account object which calls the respective methods of helper class based on trigger context.
 * Added after update context for the trigger.
 *
 * @author Amit M.
 * @version 2.0
 */
trigger PGIAccountTrigger on Account (before insert, before update, after update, after delete) {
    
    /* Stores helper class instance. */
    PGIAccountTriggerHelper triggerHelper = new PGIAccountTriggerHelper();
    
    if(Trigger.isBefore)
    {
        if(Trigger.isUpdate)
        {
            triggerHelper.onBeforeUpdate();
        }
        else if (Trigger.isInsert)
        {
            triggerHelper.onBeforeInsert();
        }
    }
    else if(Trigger.isAfter)
    {
        if(Trigger.isUpdate)
        {
            triggerHelper.onAfterUpdate();
        }
        else if(Trigger.isDelete)
        {
        	triggerHelper.onAfterDelete();
        }
    }
}