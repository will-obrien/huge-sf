// Trigger for the case object which handles all the events and based on the event delegates the task 
// to the corresponding trigger handler method in the CaseTriggerHelper class

trigger CaseTrigger on Case (before insert, before update, after insert, after update) {

    if(trigger.isBefore){
       
       if(trigger.isInsert) {
        
           CaseTriggerHelper.SetAccountStatusField(Trigger.New);
           CaseTriggerHelper.SetAllFieldsVerifiedField(Trigger.New); 
           CaseTriggerHelper.EnforceRequestStatusRulesForInserts(Trigger.New);
       }
        
       if(trigger.isUpdate) {
           
           CaseTriggerHelper.EnforceAccountRules(Trigger.New, Trigger.OldMap);       
           CaseTriggerHelper.SetAllFieldsVerifiedField(Trigger.New);
           CaseTriggerHelper.EnforceRequestStatusRulesForUpdates(Trigger.New, Trigger.OldMap);       
       }        
    }
}