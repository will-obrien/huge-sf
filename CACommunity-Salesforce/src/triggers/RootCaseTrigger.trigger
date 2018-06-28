trigger RootCaseTrigger on Root_Case__c (before insert, before update, after insert, after update) {
// Trigger for the case object which handles all the events and based on the event delegates the task 
// to the corresponding trigger handler method in the CaseTriggerHelper class

    if(trigger.isBefore){
        
       RootCaseTriggerHelper.SetBlankAuditFieldsToNONE(Trigger.New);
       RootCaseTriggerHelper.SetAllFieldsVerifiedField(Trigger.New);
       
       if(trigger.isInsert) {
        
           RootCaseTriggerHelper.SetAccountStatusField(Trigger.New);             
           RootCaseTriggerHelper.EnforceRequestStatusRulesForInserts(Trigger.New);
       }
        
       if(trigger.isUpdate) {
          
           RootCaseTriggerHelper.EnforceRequestStatusRulesForUpdates(Trigger.New, Trigger.OldMap);       
       }        
    }
}