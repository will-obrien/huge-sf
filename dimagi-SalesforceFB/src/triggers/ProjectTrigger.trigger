trigger ProjectTrigger on Project__c (before insert, before update) {

	ProjectTriggerSync.onProjectTrigger(Trigger.new);
	ProjectTriggerArea.onUpdate(Trigger.new);

}