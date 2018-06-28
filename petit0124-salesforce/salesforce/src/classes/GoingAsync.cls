public class GoingAsync {

	private static Boolean AlreadyProcessed = false;	// Simple protection from workflows and triggers

	/*
	public static void GoingAsync1(List<Solution> solutionlist, Map<ID, Solution> newmap, Map<ID, Solution> oldmap, Boolean isInsert)
	{
		if(AlreadyProcessed) return;
		AlreadyProcessed = true;
		if(isInsert) FirstAttempt(newmap.keyset());
		else
		{
			Set<ID> textchangedids = new Set<ID>();
			for(Solution sl: solutionlist)
			{
				if(sl.SolutionNote!= oldmap.get(sl.id).SolutionNote) textchangedids.add(sl.id); 
			}
			if(textchangedids.size()>0) FirstAttempt(textchangedids);
		}

	}

	public static void GoingAsync2(List<Solution> solutionlist, Map<ID, Solution> oldmap, Boolean isInsert)
	{
		if(AlreadyProcessed) return;
		AlreadyProcessed = true;
		for(Solution sl:solutionlist)
		{
			if(isInsert || sl.SolutionNote!= oldmap.get(sl.id).SolutionNote) sl.TranslationPending__c = true; 
		}
		SecondAttemptRequestAsync();
	}
	*/

	public static void GoingAsync3(List<Solution> solutionlist, Map<ID, Solution> oldmap, Boolean isInsert)
	{
		if(AlreadyProcessed) return;
		AlreadyProcessed = true;
		for(Solution sl:solutionlist)
		{
			if(isInsert || sl.SolutionNote!= oldmap.get(sl.id).SolutionNote) sl.TranslationPending__c = true; 
		}
		ThirdAttemptRequestAsync();
	}

/*	
	@future
	public static void FirstAttempt(Set<ID> solutionids)
	{
		List<Solution> solutionstoupdate = [SELECT ID, SolutionNote, SolutionSpanish__c from Solution where ID in :solutionids];
		for(Solution sl: solutionstoupdate) sl.SolutionSpanish__c = SimulateTranslationCallout(sl.SolutionNote);
		update solutionstoupdate;
	}

	public static void SecondAttemptRequestAsync()
	{
		SecondAttemptAsync();
	}

	@future
	private static void SecondAttemptAsync()
	{
		SecondAttemptSync();
	}
	
	public static void SecondAttemptSync()
	{
		List<Solution> solutionstoupdate = [SELECT ID, SolutionNote, SolutionSpanish__c from Solution where LastModifiedDate > :DateTime.Now().addHours(-24) And TranslationPending__c = true LIMIT :Limits.getLimitCallouts()];
		for(Solution sl: solutionstoupdate)
		{
			sl.SolutionSpanish__c = SimulateTranslationCallout(sl.SolutionNote);
			sl.TranslationPending__c = false;
		}
		update solutionstoupdate;
		
	}
*/
	
	private static Boolean ThirdAttemptAsyncRequested = false;
	
	// Safe to use from anywhere to request async operation
	public static void ThirdAttemptRequestAsync()
	{
		GoAsyncHelper__c asynchelper = GetAsyncHelper();
		if(ThirdAttemptAsyncRequested) return;	// Already fired a request in this context
		if(asynchelper.AsyncPending__c) return;	// Someone already requested async operation

		asynchelper.AsyncPending__c = true;
		Database.Update(asynchelper);

		if(!System.isFuture() && !System.isBatch() && !System.isScheduled())
		{
			ThirdAttemptAsyncRequested = true;
			ThirdAttemptAsync();
		}
	}
	
	// Called from trigger dispatch and VisualForce pages
	public static void ThirdAttemptAsyncSupport()
	{
		if(ThirdAttemptAsyncRequested) return;
		GoAsyncHelper__c asynchelper = GetAsyncHelper();
		if(!asynchelper.AsyncPending__c) return;
		if(System.isFuture() || System.isBatch() || System.isScheduled()) return;
		ThirdAttemptAsyncRequested = true;
		ThirdAttemptAsync();
	}

	@future
	private static void ThirdAttemptAsync()
	{
		GoAsyncHelper__c asynchelper = GetAsyncHelper();
		if(asynchelper.AsyncPending__c)
		{	// Clear any pending request
			asynchelper.AsyncPending__c = false;
			Database.Update(asynchelper);
		}

		ThirdAttemptSync();
	}
	
	public static void ThirdAttemptSync()
	{
		Integer availablecallouts = Limits.getLimitCallouts() - Limits.getCallouts();
		if(availablecallouts < 2)
		{
			ThirdAttemptRequestAsync();
			return;
		}
		List<Solution> solutionstoupdate = [SELECT ID, SolutionNote, SolutionSpanish__c from Solution where LastModifiedDate > :DateTime.Now().addHours(-24) And TranslationPending__c = true LIMIT :availablecallouts];
		for(Solution sl: solutionstoupdate)
		{
			sl.SolutionSpanish__c = SimulateTranslationCallout(sl.SolutionNote);
			sl.TranslationPending__c = false;
		}
		update solutionstoupdate;
		
		if(solutionstoupdate.size()== availablecallouts)
		{
			ThirdAttemptRequestAsync();
		}
	}
	
	public static GoAsyncHelper__c GetAsyncHelper()
	{
		GoAsyncHelper__c theobject = GoAsyncHelper__c.getInstance('default');
		if(theobject==null) 
		{
			theobject = new GoAsyncHelper__c();
			theobject.name = 'default';
			theobject.AsyncPending__c = false;
			Database.Insert(theobject);
		}
		return theobject;
	}
	

	
	public class SimulatedLimitException extends Exception
	{}
	
	// Code to simulate a translation callout
	private static Integer calloutcounter = 0;
	public static string SimulateTranslationCallout(String TextToTranslate)
	{
		if(!System.isFuture() && ! System.isBatch() && !System.isScheduled()) throw new SimulatedLimitException('Synchronous callouts are not allowed within a trigger context');
		if(calloutcounter>= Limits.getLimitCallouts()) throw new SimulatedLimitException('No more than ' + Limits.getLimitCallouts() + ' simulated callouts allowed');
		calloutcounter+=1;
		if(TextToTranslate==null) return null;
		return TextToTranslate + ' in Spanish';
	}	

}