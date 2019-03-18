trigger OnOpportunity2 on Opportunity (after update) {
	
	// Samples for use with ThinkingInApexBulkPatterns.cls
	//ThinkingInApexBulkPatterns.AfterUpdateOpportunityCommon(trigger.new, trigger.newmap, trigger.oldmap);
	//ThinkingInApexBulkPatterns.AfterUpdateOpportunitySets(trigger.new, trigger.newmap, trigger.oldmap);
	//ThinkingInApexBulkPatterns.AfterUpdateOpportunityBetterQueries(trigger.new, trigger.newmap, trigger.oldmap);
	//ThinkingInApexBulkPatterns.AfterUpdateOpportunityFutureSupport(trigger.new, trigger.newmap, trigger.oldmap);
	//ThinkingInApexBulkPatterns.AfterUpdateOpportunityBatchSupport(trigger.new, trigger.newmap, trigger.oldmap);
	//ThinkingInApexBulkPatterns.AfterUpdateOpportunityAwful(trigger.new, trigger.oldmap);

	// Samples for use with TriggerExample.cls
	//TriggersExample.AfterUpdateOpportunityCreateTasks1(trigger.new, trigger.newmap, trigger.oldmap);
	//TriggersExample.AfterUpdateOpportunityCreateTasks2(trigger.new, trigger.newmap, trigger.oldmap);
	
	// Trigger arhitecture examples
	// Example using parameters to track update objects
	/*Map<ID, Opportunity> objectstoupdate = new Map<ID, Opportunity>();
	TriggerArchitectureClass1.Entry1(trigger.new, trigger.newmap, trigger.old, trigger.oldmap, objectstoupdate);
	TriggerArchitectureClass2.Entry1(trigger.new, trigger.newmap, trigger.old, trigger.oldmap, objectstoupdate);
	if(objectstoupdate.size()>0) update objectstoupdate.values();
	*/
	
	// Examples using a dispatcher class
	TriggerArchitectureMain1.Entry2(trigger.new, trigger.newmap, trigger.old, trigger.oldmap);
	TriggerArchitectureMain1.Entry3(trigger.new, trigger.newmap, trigger.old, trigger.oldmap);

	// Compelte centralized dispatching
	TriggerArchitectureMain1.Entry4('Opportunity', trigger.IsBefore, trigger.IsDelete, trigger.isAfter,
									trigger.IsInsert, trigger.IsUpdate, trigger.IsExecuting, 
									trigger.new, trigger.newmap, trigger.old, trigger.oldmap);
	
}