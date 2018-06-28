global class Schedulable_LeadMerger implements Schedulable {
	
	map<Id,Lead> dupeMap {get;set;}
	
	public Schedulable_LeadMerger(map<Id,Lead> dupeMap){
		this.dupeMap = dupeMap;
	}
	
	global void execute(SchedulableContext SC) {
		LeadMerger mergeLeads = new LeadMerger(dupeMap);
		Database.executeBatch(mergeLeads,1);
   	}

}