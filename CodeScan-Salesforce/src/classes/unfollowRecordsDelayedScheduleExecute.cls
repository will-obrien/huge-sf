global with sharing class unfollowRecordsDelayedScheduleExecute implements Schedulable {

    global void execute(SchedulableContext ctx) {
       UnfollowRecordsDelayed.unfollowQueueDelayBatchJob();
    }//execute
    
}//unfollowScheduleExecute