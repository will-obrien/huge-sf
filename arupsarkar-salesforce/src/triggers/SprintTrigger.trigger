trigger SprintTrigger on Sprint__c (after update, after insert) {
    TriggerFactory.createHandler(Sprint__c.sObjectType);
}