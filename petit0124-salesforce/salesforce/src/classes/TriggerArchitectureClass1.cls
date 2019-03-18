public class TriggerArchitectureClass1 implements TriggerArchitectureMain1.ITriggerEntry {
	
	public static void Entry1(List<Opportunity> newlist, Map<ID, Opportunity> newmap, List<Opportunity> oldlist, Map<ID,Opportunity> oldmap, Map<ID, Opportunity> objectstoupdate)
	{
		// Do some processing here
		// Add entries to the objectstoupdate map if they need to be updated
	}

	public static void Entry2(List<Opportunity> newlist, Map<ID, Opportunity> newmap, List<Opportunity> oldlist, Map<ID,Opportunity> oldmap)
	{
		// Do some processing here
		// Add entries to the dispatcher static variable if they need to be updated
	}

	public static void Entry3(List<Opportunity> newlist, Map<ID, Opportunity> newmap, List<Opportunity> oldlist, Map<ID,Opportunity> oldmap)
	{
		// Do some processing here
		// Add entries to the dispatcher static variable if they need to be updated
	}


	public void MainEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap)
	{
		List<Opportunity> opnewlist = (List<Opportunity>)newlist;
		List<Opportunity> opoldlist = (List<Opportunity>)oldlist;
		Map<ID, Opportunity> opnewmap = (Map<ID,Opportunity>)newmap;
		Map<ID, Opportunity> opoldmap = (Map<ID,Opportunity>)oldmap;

		// Do some processing here
		// Add entries to the dispatcher static variable if they need to be updated or do direct DML

	}

	public void InProgressEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap)
	{
		// Be sure to detect for the objects you actually want to handle.
		// Can dispatch to other classes is necessary
	}

	

}