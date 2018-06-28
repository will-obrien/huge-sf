global with sharing class unfollowScheduler{
    public static void start(){
        //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        //does it once per day at midnight
        //13 seconds, 57 minutes, 22 hours, Day of month = All (*), Day of Week = All (*), Year = no value (?) as it is optional
        //Note the funky random time is to let me query to see if this schedule has been started as 
        //at the time of coding there's an unfixed bug where CronTrigger.Name does not exist, 
        //so I can't query on CronTrigger.Name='Unfollow Rules'
//system.schedule('Unfollow Rules', '13 06 11 * * ?', new unfollowScheduleExecute()); 
        system.schedule('Unfollow Rules', unfollowButtonController.unfollowSchedule, new unfollowScheduleExecute()); 
    }//start
 
}//unfollowScheduler