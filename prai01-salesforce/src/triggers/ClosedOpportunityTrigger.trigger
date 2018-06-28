trigger ClosedOpportunityTrigger on Opportunity (before insert, before update) {
	
	List<Task> taskToInsertList = new List<Task>();
	for (Opportunity opp : Trigger.new)
	{
		//System.LimitException: Too many DML statements: 151
		//List<Task> taskToInsertList = new List<Task>();
		//Cases c = new Cases();
		//Task c = new Task();
			if (opp.StageName == 'Closed Won')
			{
				Task t = new Task();
				t.whatId = opp.Id;
				t.subject = 'Follow Up Test Task';
				taskToInsertList.add(t);
			}
	}
			if (!taskToInsertList.isEmpty()) insert taskToInsertList;
			//insert taskToInsertList;
	
}