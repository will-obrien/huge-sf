public with sharing global class UnfollowRecordsDelayed{
     public static void unfollowQueueDelayBatchJob(){
        String sObjectQuery='Select chttrunfollow__recordId__c FROM chttrunfollow__UnfollowQueue__c WHERE chttrunfollow__scheduledUnfollowDate__c<= TODAY AND IsDeleted=FALSE';
        Integer numBatchApexJobsLimit=5;//at time of coding, there are at most 5 concurrent batch apex jobs in any org
        
        //This is the number of jobs that can be queued up by this method
        Integer numJobsAvailable=numBatchApexJobsLimit - unfollowExecute.numBatchJobsQueued();

        //This will store the job definition for the jobs over the numBatchApexJobsLimit to be run later
        List<UnfollowBatchJobsQueue__c> batchJobsQueued=new List<UnfollowBatchJobsQueue__c>();

        UnfollowProcessUnfollowQueueBatch unfollowRecords= new UnfollowProcessUnfollowQueueBatch();
        if(numJobsAvailable>0){
            unfollowRecords.sObjectQuery=sObjectQuery;
            Id unfollowRulesProcessId = Database.executeBatch(unfollowRecords, 200); 
        }else{
//            system.debug('There are 5 batch jobs already running, so this delay job is not scheduled.  Query: '+unfollowRecords.sObjectQuery );
            //if(([SELECT Id FROM UnfollowBatchJobsQueue__c WHERE delayJob__c=TRUE].size()>0)==FALSE){
                UnfollowBatchJobsQueue__c job=new UnfollowBatchJobsQueue__c(delayJob__c=TRUE, sObjectQuery__c=sObjectQuery);
                batchJobsQueued.add(job);
            //}//if 2
        }//if 1

        try{
            if(batchJobsQueued.size()>0){
                insert batchJobsQueued;
            }//if 1
        }catch (DMLException e){
//            system.debug('The batch jobs were not added to the queue successfully, likely due to dupe object name.  Error: '+e);
        }//try
    }//unfollowQueueBatchJobs
    
}//UnfollowDelayRecords