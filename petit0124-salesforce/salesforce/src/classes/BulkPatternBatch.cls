global class BulkPatternBatch implements Database.Batchable<sObject> {
	
	global final string query;
	global final Set<ID> opportunityids;

	
	public BulkPatternBatch(Set<ID> opportunityIDsToUpdate)
	{
		opportunityids = opportunityIDsToUpdate;
		query = 'SELECT ID, OwnerID from Opportunity where ID in :opportunityids ';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<Opportunity> ops = (List<Opportunity>)scope;
		Map<ID, Opportunity> newmap = new Map<ID, Opportunity>(ops);
		// Uncomment this line for testing this code. Commented here to enable deployment
		//ThinkingInApexBulkPatterns.AfterUpdateOpportunityBatchSupport(ops, newmap, null);
		return;
	}
	
	global void finish(Database.BatchableContext BC){
		
	}	


}