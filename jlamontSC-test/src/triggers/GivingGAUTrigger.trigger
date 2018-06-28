//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Trigger on rC_Giving__GAU__c Object
//	8 March 2014   Virendra (Appirio)     Original
//	T-257271
//	Task Name	
//	Oppty-Set Type1- Type 3 based on GAU
//**********************************************************************/
trigger GivingGAUTrigger on rC_Giving__GAU__c (after update) {
	
	if(Trigger.isAfter) {
    	// Only in case of after update only if any Product Type updates 
		// Child Giving should also be updated with productTypes
		GivingGAUTriggerHandler.updateChildOpportunities(Trigger.new,Trigger.oldMap);
	}
}