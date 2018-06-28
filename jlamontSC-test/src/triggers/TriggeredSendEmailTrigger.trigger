trigger TriggeredSendEmailTrigger on TriggeredSendEmail__c (after insert) {
	TriggeredSendEmailTriggerHandler.afterInsert(Trigger.new);
}