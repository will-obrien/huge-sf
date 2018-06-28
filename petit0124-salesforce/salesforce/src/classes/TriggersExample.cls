public class TriggersExample {
	
	public static void AfterUpdateOpportunityCreateTasks1(List<Opportunity> newlist, Map<ID, Opportunity> newmap, Map<ID, Opportunity> oldmap)
	{
		List<Task> newtasks = new List<Task>();
		
		for(Opportunity op: newlist)
		{
			system.debug('old probability ' + oldmap.get(op.id).Probability + ' new probability ' + op.Probability);
			if(oldmap.get(op.id).Probability == 10 && op.Probability > 10)
			{
				newtasks.add(new Task(ownerid = op.OwnerID, WhatID = op.id, ActivityDate = Date.Today().addDays(2), Subject='Opportunity stage update', Type='Other'));
			}
		}
		insert newtasks;
	}
	
	private static Map<ID, Double> ProbabilityOverrides = null;
	
	public static void AfterUpdateOpportunityCreateTasks2(List<Opportunity> newlist, Map<ID, Opportunity> newmap, Map<ID, Opportunity> oldmap)
	{
		List<Task> newtasks = new List<Task>();
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
	}	
	
}