trigger UpdateEmploye on Contact (after update) {
    
    ContactTriggerHelper.UpdateEmployee(Trigger.oldMap,Trigger.new);
}