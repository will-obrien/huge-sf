trigger TaskTrigger on Task (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
        
    TriggerDispatcher.callHandler('Task', 
        trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate, 
        trigger.isDelete, trigger.isUndelete, trigger.isExecuting, trigger.new, 
        trigger.newMap, trigger.old, trigger.oldMap);

}