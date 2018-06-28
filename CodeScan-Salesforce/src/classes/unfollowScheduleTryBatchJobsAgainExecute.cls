global with sharing class unfollowScheduleTryBatchJobsAgainExecute implements Schedulable {

    global void execute(SchedulableContext ctx) {
        //When false, this boolean ensures rules with Days Delay > 0 are evaluated
        Boolean runFromButton=FALSE;
       unfollowTryBatchJobsAgain.unfollowTryBatchJobsAgain();
    }//execute
    
}//unfollowScheduleTryBatchJobsAgainExecute