public class DiagnosticsTriggers2  Implements DiagnosticsMain.ITriggerEntry {
	private static Map<ID, Double> ProbabilityOverrides = null;
	
	public void MainEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap)
	{
		DiagnosticsInstrumentation.Push('DiagnosticsTriggers2.MainEntry');
		AfterUpdateOpportunityCreateTasks2((List<Opportunity>)newlist, (Map<ID,Opportunity>) newmap, (Map<ID,Opportunity>) oldmap);
		DiagnosticsInstrumentation.Pop();

	}
	public void InProgressEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap)
	{
		// Ignore triggers within triggers
	}
	
	
	private static void AfterUpdateOpportunityCreateTasks2(List<Opportunity> newlist, Map<ID, Opportunity> newmap, Map<ID, Opportunity> oldmap)
	{
		DiagnosticsInstrumentation.Push('DiagnosticsTriggers2.AfterUpdateOpportunityCreateTasks2');

		List<Task> newtasks;
		// Comment out the following line to fake a runtime error
		//newtasks = new List<Task>();
		if(ProbabilityOverrides==null) ProbabilityOverrides = new Map<ID, Double>();
		
		for(Opportunity op: newlist)
		{
			Double oldprobability = (ProbabilityOverrides.containskey(op.id))? ProbabilityOverrides.get(op.id) : oldmap.get(op.id).Probability;
			system.debug('old probability ' + oldmap.get(op.id).Probability + ' new probability ' + op.Probability);
			if(oldprobability == 10 && op.Probability > 10)
			{
				newtasks.add(new Task(ownerid = op.OwnerID, WhatID = op.id, ActivityDate = Date.Today().addDays(2), Subject='Opportunity stage update', Type='Other'));
			}
			if(oldprobability != op.Probability) ProbabilityOverrides.put(op.id, op.Probability);
			
		}
		insert newtasks;
		DiagnosticsInstrumentation.Pop();
		
	}	
}