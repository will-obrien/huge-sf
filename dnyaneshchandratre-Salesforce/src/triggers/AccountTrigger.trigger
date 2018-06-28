trigger AccountTrigger on Account (before insert, before update) {
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            AccountTriggerHandler.triggerNew(Trigger.new);
        }
        if(Trigger.isUpdate)
        {
            AccountTriggerHandler.triggerNew(Trigger.new);
        }
    }
}