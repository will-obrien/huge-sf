trigger ContactTrigger on Contact (before insert, before update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            ContactTriggerHandler.updateAccountLookup(Trigger.new);
        }
        if(Trigger.isUpdate) {
            ContactTriggerHandler.updateAccountLookup(Trigger.new);
        }
    }
}