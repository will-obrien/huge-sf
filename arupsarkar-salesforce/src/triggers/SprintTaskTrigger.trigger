trigger SprintTaskTrigger on Sprint_Task__c (after update, after insert) {
    TriggerFactory.createHandler(Sprint_Task__c.sObjectType);
}