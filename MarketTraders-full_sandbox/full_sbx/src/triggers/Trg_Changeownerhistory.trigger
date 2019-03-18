trigger Trg_Changeownerhistory on Opportunity (after Insert, after update) {
	// NEW
	if (trigger.isBefore) {
    }
    else {
    	OppChangeOwnerHistoryHelper ohh = new OppChangeOwnerHistoryHelper();
    	ohh.executeRefactoredCode(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert, trigger.isUpdate, trigger.isAfter);
    }
}