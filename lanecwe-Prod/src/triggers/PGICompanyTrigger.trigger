/**
 * This trigger updates the count of companies for the account whenever a company is created, updated or deleted.
 *
 * @author Amit M.
 * @version 1.0
 */
trigger PGICompanyTrigger on Company__c (before update, after delete, after insert, after update) {

	/* Stores instance of trigger helper class. */
	PGICompanyTriggerHelper triggerHelper = new PGICompanyTriggerHelper();
	
	if (Trigger.isAfter)
	{
		if (Trigger.isDelete)
		{
			triggerHelper.onAfterDelete();
		}
		else if (Trigger.isInsert)
		{
			triggerHelper.onAfterInsert();
		}
		else if (Trigger.isUpdate)
		{
			triggerHelper.onAfterUpdate();
		}
	}
	else if (Trigger.isBefore)
	{
		if (Trigger.isUpdate)
		{
			triggerHelper.onBeforeUpdate();
		}
	}
}