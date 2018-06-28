//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Trigger on Opportunity Object
//	8 March 2014   Virendra (Appirio)     Original
//
//  15 August 2014	Maslow
//					Remove call to OpportunityTriggerHandler.onAfterDelete
//					Add call to OpportunitySummaryCreator
//
//	September 2014  Maslow
//					Add call to RecalculateParentOpportunity
//**********************************************************************/
trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update, before delete, after delete) {
	//T-257271
	//Task Name	
	//Oppty-Set Type1- Type 3 based on GAU
	if(Trigger.isBefore) {
		if(Trigger.isInsert || Trigger.isUpdate) {
			OpportunityTriggerHandler.onBeforeInsertUpdate(Trigger.new, Trigger.oldMap, Trigger.isInsert);
		}
	}
	
	if(Trigger.isAfter) {
		List<Opportunity> oppList;
		Set<Id> accountIds = new Set<Id>();
		if(Trigger.isDelete) {
			oppList = Trigger.old;
		}
		else {
			oppList = Trigger.new;
		}
		for(Opportunity opp : oppList){
			accountIds.add(opp.AccountId);			
		}
		new OpportunitySummaryCreator().summarizeOpportunities(new List<Id>(accountIds));
		
		if(Trigger.isDelete) {
			RecalculateParentOpportunity.recalculate(Trigger.old);
		}
	}
}