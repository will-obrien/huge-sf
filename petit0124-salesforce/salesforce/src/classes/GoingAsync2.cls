global class GoingAsync2 implements Database.Batchable<sObject> {
	
	Global static final string TYPE_ADDRESSVERIFICTION = 'AddressVerification';
	Global static final string TYPE_AMOUNTUPDATEFAILURE = 'Amount Update';
	
	global Database.Querylocator Start(Database.BatchableContext bc)
	{
		return Database.getQueryLocator('Select ID, AsyncType__c, Params__c, TargetOpportunity__c, NewAmount__c, OriginalAmount__c from AsyncRequest__c ');
	}
	
	/* This version is before chapter 8 */
	/*
	global void Execute(Database.BatchableContext BC, List<AsyncRequest__c> scope)
	{
		List<AsyncRequest__c> objectsToDelete = new List<AsyncRequest__c>();
		for(AsyncRequest__c ar: scope)
		{
			// Remember, this will really only happen once
			if(ar.AsyncType__c == TYPE_ADDRESSVERIFICTION)
			{
				List<ID> idsToProcess = ar.Params__c.split(',');
				// Now do a query here agains the IDs - bad ids are ok, they won't have an object
				// Do the callout, update here
				objectsToDelete.add(ar);
			}
		}
		if(objectsToDelete.size()>0)
		{
			delete objectsToDelete;
			Database.emptyRecycleBin(objectsToDelete);
		}
		
	}
	*/
	

	/* This version is after chapter 8 */
	global void Execute(Database.BatchableContext BC, List<AsyncRequest__c> scope)
	{
		List<AsyncRequest__c> objectsToDelete = new List<AsyncRequest__c>();
		for(AsyncRequest__c ar: scope)
		{
			// Remember, this will really only happen once
			if(ar.AsyncType__c == TYPE_ADDRESSVERIFICTION)
			{
				List<ID> idsToProcess = ar.Params__c.split(',');
				// Now do a query here agains the IDs - bad ids are ok, they won't have an object
				// Do the callout, update here
				objectsToDelete.add(ar);
			}
			
			if(ar.AsyncType__c == TYPE_AMOUNTUPDATEFAILURE)
			{
				Opportunity op = [Select ID, Amount from Opportunity where ID = :ar.TargetOpportunity__c for update];
				if(op==null) { 
					// The op may have been deleted
					objectsToDelete.add(ar); continue; 
				}
				
				// One approach
				op.Amount = ar.NewAmount__c;
				
				// Another approach
				/*
				op.Amount += (ar.NewAmount__c - ar.OriginalAmount__c);
				*/
				
				// Another approach
				/*	
				if(op.Amount!= ar.OriginalAmount__c)
				{
					// Concurrency error - log it here, don't update
					objectsToDelete.add(ar);
					continue;
				}
				*/
				try
				{
					update op;
				}
				catch(DmlException dex)
				{
					if(dex.getDmlType(0) == StatusCode.UNABLE_TO_LOCK_ROW)
					{
						continue;	// Try again later
					}
					// Otherwise log the error
				}
				catch(Exception ex)
				{
					// Log the error?
				}
				objectsToDelete.add(ar);
				
			}
		}
		if(objectsToDelete.size()>0)
		{
			delete objectsToDelete;
			Database.emptyRecycleBin(objectsToDelete);
		}
		
	}


	global void Finish(Database.BatchableContext BC)
	{
		List<AsyncRequest__c> ars = [Select ID from AsyncRequest__c Limit 1];
		if(ars.size()>0) StartBatch();
	}

	private static Boolean batchrequested = false;

	public static void StartBatch()
	{
		if(batchrequested) return;
		GoingAsync2 ga = new GoingAsync2();
		Database.executeBatch(ga, 1);
		batchrequested = true;
	}
	
	public static void HandleLeadTrigger(Boolean isUpdate, List<Lead>newlist, Map<ID,Lead> oldmap)
	{
		List<ID> idsToProcess = new List<ID>();
		for(Lead ld: newlist)
		{
			if(!isUpdate)
			{
				idsToProcess.add(ld.id);
			}
			else
			{
				Lead oldlead = oldmap.get(ld.id);
				if(ld.city!= oldlead.city || ld.street!=oldlead.street ||
					ld.state!=oldlead.state || ld.country!=oldlead.country ||
					ld.postalcode!=oldlead.postalcode) idsToProcess.add(ld.id);	
			}
		}
		if(idsToProcess.size()==0) return;
		List<AsyncRequest__c> newrequests = new List<AsyncRequest__c>();
		List<ID> idsForRequest = new List<ID>();
		for(ID currentid: idsToProcess)
		{
			idsForRequest.add(currentid);
			if(idsForRequest.size()==10)
			{
				newrequests.add(new AsyncRequest__c(AsyncType__c = TYPE_ADDRESSVERIFICTION, Params__c = String.Join(idsForRequest,',') ));
				idsForRequest.clear();
			}
		}
		if(idsForRequest.size()>0)
			newrequests.add(new AsyncRequest__c(AsyncType__c = TYPE_ADDRESSVERIFICTION, Params__c = String.Join(idsForRequest,',') ));
		insert newrequests;				
		StartBatch();
	}

	public class ScheduleHandler implements ScheduledDispatcher.IScheduleDispatched
	{
        public void execute(SchedulableContext sc)
        {
        	StartBatch();
            system.abortJob(sc.getTriggerID());	// Always abort the job on completion
        } 
    }

    public static String GetSchedulerExpression(Datetime dt) {
        return ('' + dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
    }
        
    public static void StartScheduler()
    {
        // Consider putting a static variable gate here so the method is only called
        // once per execution context (like StartBatch)
        
        // Is the job already running?
        List<CronTrigger> jobs = [SELECT Id, CronJobDetail.Name, State, NextFireTime
                                  FROM CronTrigger where CronJobDetail.Name='async2_example_job'];
    	if(jobs.size()>0 && jobs[0].state!='COMPLETED' && 
           jobs[0].state!='ERROR' && jobs[0].state!='DELETED')
    	{
            // It's already running - Is the batch running?
            Set<String> activejobstates = new Set<String>{'Queued','Processing','Preparing'};
            List<AsyncApexJob> apexjobs = [Select ID, ApexClass.Name from AsyncApexJob 
                                           where ApexClass.Name = 'GoingAsync2' And Status in :activejobstates];
          if(apexjobs.size()>0) return;  // The batch is running
            // If we're going to run soon, exit
            if(DateTime.Now().AddSeconds(60) > jobs[0].NextFireTime) return;
            
        }

        // If the job exists, it needs to be deleted
        if(jobs.size()>0) system.abortJob(jobs[0].id);


        // Instead of 10 seconds, you could query pending async requests to decide
        // a target time
        try
        {
	        System.schedule('async2_example_job', 
	                        GetSchedulerExpression(DateTime.Now().addSeconds(10)), 
	                        new ScheduledDispatcher());
        } catch(Exception ex){}
    }


}