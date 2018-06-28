trigger TaskTrigger on Task (after insert) {
    TaskTriggerHelper.createTaskOnOpportunity(Trigger.new);
}