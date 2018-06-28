trigger OnLeadForGoingAsync2 on Lead (after insert, after update) {
	GoingAsync2.HandleLeadTrigger(trigger.isUpdate, trigger.new, trigger.oldmap);
}