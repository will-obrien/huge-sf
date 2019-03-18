public class TriggerArchitectureMain1 {
	public static Map<ID, Opportunity> opstoupdate = new Map<ID, Opportunity>();
	
	public static void Entry2(List<Opportunity> newlist, Map<ID, Opportunity> newmap, List<Opportunity> oldlist, Map<ID,Opportunity> oldmap)
	{	
		TriggerArchitectureClass1.Entry2(newlist, newmap, oldlist, oldmap);
		TriggerArchitectureClass2.Entry2(newlist, newmap, oldlist, oldmap);
		if(opstoupdate.size()>0) update opstoupdate.values();
	}
	
	public static Boolean InClass1 = false;
	public static Boolean InClass2 = false;
	public static void Entry3(List<Opportunity> newlist, Map<ID, Opportunity> newmap, List<Opportunity> oldlist, Map<ID,Opportunity> oldmap)
	{	
		if(!InClass1)
		{
			InClass1= true;
			TriggerArchitectureClass1.Entry3(newlist, newmap, oldlist, oldmap);
			InClass1 = false;
		}
		InClass2 = true;
		TriggerArchitectureClass2.Entry3(newlist, newmap, oldlist, oldmap);
		InClass2 = false;
		if(opstoupdate.size()>0) update opstoupdate.values();
	}

	public interface ITriggerEntry
	{
		void MainEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap);
		void InProgressEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap);
	}

	public static ITriggerEntry activefunction = null;

	public static void Entry4(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap)
	{	
		if(activefunction != null) 
		{
			activefunction.InProgressEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting, newlist, newmap, oldlist, oldmap);
			return;
		}
		
		if(TriggerObject == 'Opportunity' && IsAfter && IsUpdate)
		{
			activefunction = new TriggerArchitectureClass1();
			activefunction.MainEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting,  newlist, newmap, oldlist, oldmap);

			activefunction = new TriggerArchitectureClass2();
			activefunction.MainEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting,  newlist, newmap, oldlist, oldmap);

			if(opstoupdate.size()>0) update opstoupdate.values();
			activefunction = null;
		}
	}



}