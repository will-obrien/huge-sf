public with sharing class KVApexScheduleExecute implements KVApexSchedule.IApexSchedule
{

    public void execute(SchedulableContext sc)
    {
        KVProcessApexJobQueue();
    }
    
    public static void KVProcessApexJobQueue()
    {
    
        //If Goal_Achiever__c has a record which is not "Complete", it has to be put in Apex Job queue
        if([SELECT count() FROM Goal_Achiever__c WHERE Status__c != 'Complete' LIMIT 1] == 1)
        {
            KVApexJobSchedule__c KVApexScheduler = KVApexUtilityEngine.GetorCreateApexSchedule();
            
            //KVApexJobSchedule__c custom setting will record all current jobs, 
            //this if condition will eliminate duplicate processing
            if(KVApexScheduler.BatchId__c == null || (KVApexScheduler.BatchId__c != null && [
                SELECT count() 
                FROM AsyncApexJob 
                WHERE (Status = 'Queued' OR Status = 'Processing' OR Status = 'Preparing') 
                AND Id = :KVApexScheduler.BatchId__c] == 0))
            {
                //Identify the Asynchronous Apex jobs in Queued/Processing/Preparing status and put it in batch
                if(([SELECT count() FROM AsyncApexJob WHERE Status = 'Queued' OR Status = 'Processing' OR Status = 'Preparing'] < 5))
                {
                    KVApexBatch KVapexBatch = new KVApexBatch();
                    KVApexScheduler.BatchId__c = Database.executeBatch(KVapexBatch, 1); // One object per batch
                    update KVApexScheduler;
                }
            }
        }
        
    }

}