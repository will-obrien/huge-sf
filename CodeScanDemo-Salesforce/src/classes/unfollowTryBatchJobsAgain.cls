global with sharing class unfollowTryBatchJobsAgain{

    public static void unfollowTryBatchJobsAgain(){
        Integer numBatchApexJobsLimit=5;//at time of coding, there are at most 5 concurrent batch apex jobs in any org
        List<AsyncApexJob> numBatchJobs = [SELECT Id, Status FROM AsyncApexJob WHERE Status = 'Queued' OR Status = 'Processing'];

        //This is the number of jobs that can be queued up by this method
        Integer numJobsAvailable=numBatchApexJobsLimit - numBatchJobs.size();
	
        if(numJobsAvailable>0){
            List<UnfollowBatchJobsQueue__c> batchJobsQueued=[SELECT Id, IsDeleted, delayJob__c, delayRulesIncluded__c, evalateEachRecordForDaysDelay__c, numRulesUsedInThisObject__c, objectName__c, sObjectQuery__c FROM UnfollowBatchJobsQueue__c WHERE IsDeleted=FALSE ORDER BY  CreatedDate ASC];
            //Goal here is to process the delay queue first as it's more important than the others. Rather than do 2 queries, it's handled with variables here:
            Integer delayJobNum=1000;//initialize to huge number as a backup
            for (Integer i=0;i<batchJobsQueued.size();i++){
                if (batchJobsQueued[i].delayJob__c==TRUE){
                    delayJobNum=i;
                    break;
                }//if 2
            }//for 1
    		List<UnfollowBatchJobsQueue__c> batchJobsToDelete=new List<UnfollowBatchJobsQueue__c>();        
            for(Integer i=0; i<numJobsAvailable && i<batchJobsQueued.size(); i++){
                //if this is the high priority "delayed records scheduled for unfollow today" job, do it first
                if (delayJobNum!=1000){
                    UnfollowProcessUnfollowQueueBatch unfollowDelayedRecords= new UnfollowProcessUnfollowQueueBatch();
                    unfollowDelayedRecords.sObjectQuery=batchJobsQueued[delayJobNum].sObjectQuery__c;
                    //is there any way to combine these 2 in a transaction?
                    try{
                        Id unfollowRulesProcessId = Database.executeBatch(unfollowDelayedRecords, 200); 
//                        system.debug('delayJobNum: ' +delayJobNum);
//                        system.debug('ID for UnfollowBatchJobsQueue__c to be deleted: '+batchJobsQueued[delayJobNum].Id);
//                        system.debug('Batch job deleted? '+batchJobsQueued[delayJobNum].IsDeleted);
                        batchJobsToDelete.add( batchJobsQueued[delayJobNum]);
                    } catch(exception e){
//                        system.debug('Either the batch failed or the job deletion from teh queue failed: '+e);
                    }//try
                } else if(batchJobsQueued[i].delayRulesIncluded__c==FALSE){
                 //is this the simple case with no "days delay" rules?
                    UnfollowRecordsBatch  unfollowRecords= new UnfollowRecordsBatch();
                    unfollowRecords.ObjectName=batchJobsQueued[i].objectName__c;
                    unfollowRecords.numRulesUsedInThisObject=batchJobsQueued[i].numRulesUsedInThisObject__c.intValue();
                    unfollowRecords.sObjectQuery =  batchJobsQueued[i].sObjectQuery__c;
                
                    try{
                        Id unfollowRulesProcessId = Database.executeBatch(unfollowRecords, 200); 
                        batchJobsToDelete.add(batchJobsQueued[i]);
                    } catch(exception e){
//                        system.debug('Either the batch failed or the job deletion from the queue failed: '+e);
                    }//try
                } else {
                //else it's the more complex case where we need to check for the unfollow date
                    UnfollowQueueDelayRecordsBatch queueDelayRecords= new UnfollowQueueDelayRecordsBatch();
                    queueDelayRecords.ObjectName=batchJobsQueued[i].objectName__c;
                    queueDelayRecords.sObjectQuery =  batchJobsQueued[i].sObjectQuery__c;
                    queueDelayRecords.evalateEachRecordForDaysDelay=batchJobsQueued[i].evalateEachRecordForDaysDelay__c;
                    
//let's cross our fingers that the rule criteria didn't change between when this job first ran and now :(  
//Will the code fail elegantly if the rules were changed?
//I'd rather not create a 3rd queue just to save the state of the rules due to stupid batch apex limits
                    queueDelayRecords.delayRules=[Select Id, ObjectName__c, Active__c, FieldName__c, FieldType__c, Operator__c, Value__c, DaysDelay__c FROM UnfollowRule__c WHERE DaysDelay__c>0 AND Active__c = TRUE AND objectName__c=:queueDelayRecords.ObjectName]; 

                    try{
                        Id unfollowRulesProcessId = Database.executeBatch(queueDelayRecords, 200); 
                        batchJobsToDelete.add( batchJobsQueued[i]);
                    } catch(exception e){
//                        system.debug('Either the batch failed or the job deletion from the queue failed: '+e);
                    }//try
                    
                }//if 2
            }//for 1
            try{
            	delete batchJobsToDelete;
            } catch(exception e){
//                        system.debug('job deletion from the queue failed: '+e);            
            }//try delete

        }//if 1


    }//unfollowTryBatchJobsAgain
}//unfollowTryBatchJobsAgain