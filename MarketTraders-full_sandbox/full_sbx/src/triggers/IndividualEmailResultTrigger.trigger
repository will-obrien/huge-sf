trigger IndividualEmailResultTrigger on et4ae5__IndividualEmailResult__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
        
    TriggerDispatcher.callHandler('Individual Email Result', 
        trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate, 
        trigger.isDelete, trigger.isUndelete, trigger.isExecuting, trigger.new, 
        trigger.newMap, trigger.old, trigger.oldMap);

}