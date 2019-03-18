public class Concurrency1 {


    public static void Delay(Integer seconds)
    {
        List<Integer> largearray = new List<Integer>();
        for(Integer x =0; x<10000; x++) largearray.add(x);
        for(Integer counter = 0; counter<seconds * 4; counter++)
        {
            String s = json.serialize(largearray);
        }
    }

    // Create this opportunity by hand
	private static String OpportunityName = 'Concurrency1';
    
    @future
    public static void IncrementOptimistic(double amount, Integer DelayBefore, Integer DelayFromQuery, Integer DelayAfter)
    {
        if(DelayBefore>0) Delay(DelayBefore);
        List<Opportunity> ops = [Select ID, Amount From Opportunity where Name = :OpportunityName];
        for(Opportunity op: ops)
        	op.Amount = (op.Amount==null)? amount: op.Amount + Amount;
        if(DelayFromQuery>0) Delay(DelayFromQuery);
        update ops;
        if(DelayAfter>0) Delay(DelayAfter);
    }

    @future
    public static void IncrementPessimistic(double amount, Integer DelayBefore, Integer DelayFromQuery, Integer DelayAfter)
    {
        if(DelayBefore>0) Delay(DelayBefore);
        List<Opportunity> ops = [Select ID, Amount From Opportunity where Name = :OpportunityName For Update];
        for(Opportunity op: ops)
        	op.Amount = (op.Amount==null)? amount: op.Amount + Amount;
        if(DelayFromQuery>0) Delay(DelayFromQuery);
        update ops;
        if(DelayAfter>0) Delay(DelayAfter);
    }

    @future
    public static void IncrementPessimisticB(double amount, Integer DelayBefore, Integer DelayFromQuery, Integer DelayAfter)
    {
        if(DelayBefore>0) Delay(DelayBefore);
        List<Opportunity> ops = [Select ID, TestCounterAmount__c From Opportunity where Name = :OpportunityName For Update];
        ops[0].TestCounterAmount__c = (ops[0].TestCounterAmount__c==null)? amount: ops[0].TestCounterAmount__c + Amount;
        if(DelayFromQuery>0) Delay(DelayFromQuery);
        update ops;
        if(DelayAfter>0) Delay(DelayAfter);
    }

    @future
    public static void IncrementPessimistic2B(double amount, Integer DelayBefore, Integer DelayFromQuery, Integer DelayAfter)
    {
        if(DelayBefore>0) Delay(DelayBefore);
        List<Opportunity> ops = [Select ID, TestCounterAmount__c From Opportunity where Name = :OpportunityName For Update];
        ops = [Select ID, TestCounterAmount__c From Opportunity where Name = :OpportunityName];
        for(Opportunity op: ops)
        	op.TestCounterAmount__c = (op.TestCounterAmount__c==null)? amount: op.TestCounterAmount__c + Amount;
        if(DelayFromQuery>0) Delay(DelayFromQuery);
        update ops;
        if(DelayAfter>0) Delay(DelayAfter);
    }

    
    @future
    public static void IncrementOptimisticWithCapture(double amount, Integer DelayBefore, Integer DelayFromQuery, Integer DelayAfter)
    {
        if(DelayBefore>0) Delay(DelayBefore);
        List<Opportunity> ops = [Select ID, Amount From Opportunity where Name = :OpportunityName];
        for(Opportunity op: ops)
        	op.Amount = (op.Amount==null)? amount: op.Amount + Amount;
        if(DelayFromQuery>0) Delay(DelayFromQuery);
        List<Database.Saveresult> dmlresults = Database.Update(ops, false);
		List<Opportunity> FailedUpdates = new List<Opportunity>(); 
		for(Integer x = 0; x< ops.size(); x++)
		{
			Database.Saveresult sr = dmlresults[x];
			if(!sr.isSuccess())
			{
				for(Database.Error err: sr.getErrors())
				{
					if(err.getStatusCode() == StatusCode.UNABLE_TO_LOCK_ROW)
					{
						FailedUpdates.add(ops[x]);
						break;
					}
				}
			}
			
		}
		
		if(FailedUpdates.size()>0)
		{
			// Do a logging or recovery operation here
			RecordRecoveryInformation(FailedUpdates, amount);
		}
        
        if(DelayAfter>0) Delay(DelayAfter);
    }
    
    @testvisible private static void RecordRecoveryInformation(List<Opportunity> failedops, double amount)
    {
    	List<AsyncRequest__c> requests = new List<AsyncRequest__c>();
    	for(Opportunity op: failedops)
    	{
    		requests.add(new AsyncRequest__c(AsyncType__c = GoingAsync2.TYPE_AMOUNTUPDATEFAILURE, 
    			NewAmount__c = op.Amount, OriginalAmount__c = op.Amount - amount, TargetOpportunity__c = op.id ));
    	}
    	insert requests;
		GoingAsync2.StartScheduler();	// Request the async operation
    }
    
}