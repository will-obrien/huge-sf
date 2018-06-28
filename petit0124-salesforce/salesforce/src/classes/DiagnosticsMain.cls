public class DiagnosticsMain {

	public interface ITriggerEntry
	{
		void MainEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap);
		void InProgressEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap);
	}

	public static ITriggerEntry activefunction = null;
	
	public static Boolean FakeException = false;

	public static void MainEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap)
	{	
		DiagnosticsInstrumentation.Push('MainEntry TriggerObject: ' + TriggerObject + ' IsBefore: ' + IsBefore + ' IsInsert: ' + IsInsert + ' IsUpdate: ' + IsUpdate);
		try
		{
			if(fakeexception && activefunction==null ) activefunction.InProgressEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting, newlist, newmap, oldlist, oldmap);
			 			
			if(activefunction != null) 
			{
				activefunction.InProgressEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting, newlist, newmap, oldlist, oldmap);
				return;
			}
			
			if(TriggerObject == 'Opportunity' && IsAfter && IsUpdate)
			{
				activefunction = new DiagnosticsTriggers1();
				activefunction.MainEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting,  newlist, newmap, oldlist, oldmap);
			}
			
			if(TriggerObject == 'Opportunity' && IsAfter && IsUpdate)
			{
				activefunction = new DiagnosticsTriggers2();
				activefunction.MainEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting,  newlist, newmap, oldlist, oldmap);
			}
			DiagnosticsInstrumentation.Pop();
		}
		catch(Exception ex)
		{
			DiagnosticsInstrumentation.DebugException(ex);
			DiagnosticsInstrumentation.PopAll();	
		}
	}
	

}