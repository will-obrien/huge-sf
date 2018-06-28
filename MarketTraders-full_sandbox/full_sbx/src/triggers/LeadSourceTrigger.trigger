trigger LeadSourceTrigger on Lead_Sources__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
        
    TriggerDispatcher.callHandler('Lead Source', 
        trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate, 
        trigger.isDelete, trigger.isUndelete, trigger.isExecuting, trigger.new, 
        trigger.newMap, trigger.old, trigger.oldMap);

}