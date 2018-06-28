trigger PiggybackTrigger on Opportunity (after delete, after insert, after update,before insert, before update) {
    if (trigger.isBefore) {
    	PiggybackRefactor pbr = new PiggybackRefactor();
    	pbr.beforeContext(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert, trigger.isUpdate);
    }
    else {
    	PiggybackRefactor pbr = new PiggybackRefactor();
    	pbr.afterContext(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert, trigger.isUpdate);
    }
}