public with sharing class UnfollowButtonController{

    public Boolean schedulerRendered { get; set; }
    public Boolean notSchedulerRendered { get; set; }
    
    public static String unfollowSchedule='13 57 22 * * ?';
    public static String unfollowDelaySchedule='13 57 23 * * ?';
    public static String unfollowTryAgainSchedule='13 57 * * * ?';
    
    // Constructor - this only really matters if the autoRun function doesn't work right
    public UnfollowButtonController() {
        renderScheduler();
    }
    
    public void activateScheduler(){
        try{
            List<CronTrigger> ct=[SELECT Id, NextFireTime FROM CronTrigger WHERE CronExpression = :unfollowSchedule OR CronExpression = :unfollowTryAgainSchedule OR CronExpression =:unfollowDelaySchedule];
            if (ct.size()==0){
                unfollowScheduler.start();
                unfollowSchedulerDelay.start();
                unfollowSchedulerTryBatchJobsAgain.start();
            }//if 1
        }catch (Exception e){
//            system.debug('Scheduler could not be started, likely because it is already running.  Error: '+e);
        }//try
    }//activateScheduler
    
    public void deactivateScheduler(){
        try{
            List<CronTrigger> cts=[SELECT Id, NextFireTime FROM CronTrigger WHERE CronExpression = :unfollowSchedule OR CronExpression = :unfollowTryAgainSchedule OR CronExpression = :unfollowDelaySchedule];
            if (cts.size()>0){
                for(CronTrigger ct:cts){
                    system.abortJob(ct.Id );
                }//for 1
            }//if 1
        }catch (Exception e){
//            system.debug('Scheduler could not be started, likely because it is already running.  Error: '+e);
        }//try
    }//deactivateScheduler
    
    
    public void renderScheduler(){
        List<CronTrigger> ct=[SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE CronExpression =:unfollowSchedule OR CronExpression = :unfollowTryAgainSchedule OR CronExpression = :unfollowDelaySchedule];
        //If there isn't a result here, that means the scheduler hasn't been started
        if (ct.size()==0){
            schedulerRendered = TRUE;
        } else {
//            system.debug('ct.CronExpression= '+ct[0].CronExpression);
            schedulerRendered = FALSE;
        }//if 1
        notSchedulerRendered=!(schedulerRendered);
    }//renderScheduler
   
    
}//UnfollowButtonController