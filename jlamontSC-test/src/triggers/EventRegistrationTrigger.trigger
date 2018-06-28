trigger EventRegistrationTrigger on Event_Registration__c (before insert, after delete, after insert, after update) {
    
	EventRegistrationTriggerHandler.handleChange();
    
    if (trigger.isAfter) {
        if (trigger.isInsert || trigger.isUpdate) {
        	EventRegistrationActions.createAttendeeActions(trigger.new);
            AddToListsCampaign.fromEventRegistration(trigger.new);
        }
        
        else if (trigger.IsDelete) {
            EventRegistrationTriggerHandler.deleteBatchUpload(trigger.old);
        }
    }
}