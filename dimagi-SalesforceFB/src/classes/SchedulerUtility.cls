/**
 * This utility handles Apex Scheduler methods
 *
 * @author Diego Febles <diego.febles@roundfusion.com>
 * @since 2014-08
 */
public with sharing class SchedulerUtility {
    
    private static String errorMsg = '';
    
    /*** PUBLIC STATIC METHODS ***/
        
    public static String getErrorMsg() {
        return errorMsg;
    }
    
    /*** PRIVATE STATIC METHODS ***/
    
    /*
     * Generates a cron trigger expression that is used to schedule a new job
     */
    private static String getCronTriggerExpression(String frequency, String preferredTime, List<String> weeklyFrequency, 
                                        String monthlyFrequency, String day, String week){
        //Initialize default values for a cron expression
        String cronExpression = '0 0';
        String hours = preferredTime;
        String dayOfMonth = '?';
        String month = '*';
        String dayOfWeek = '?';     
        
        //If job frequency is Weekly, we must set dayOfWeek 
        if (frequency == 'Weekly'){
            dayOfWeek = String.join(weeklyFrequency,',');
        }else{
            //If job frequency is Monthly, we set dayOfMonth or dayOfWeek depending on the monthly frequency selected  
            if (monthlyFrequency != null && monthlyFrequency != ''){
                dayOfMonth = monthlyFrequency ; 
            }else{
                if (day != null && day != '' && week != null && week != ''){
                	if(week.equals('L')){
                		dayOfWeek = day + week;	
                	}else{
                		dayOfWeek = day+'#'+week;
                	}
                       
                }
            }
        }
  
        //Create the string appending values as follow: seconds minutes hours dayOfMonth mont dayOfWeek
        cronExpression += ' ' + hours + ' ' + dayOfMonth + ' ' + month + ' ' + dayOfWeek;
        
        return cronExpression;
    }   
    
    /*** PUBLIC STATIC METHODS ***/
    
    /*
     * This method uses System.schedule to schedule a new job 
     */
    public static Id schedule(String jobName, String frequency, String preferredTime, List<String> weeklyFrequency, String monthlyFrequency, 
                        String day, String week) {
        
        Id jobId = null;
        
        // for testing 
        //datetime nextScheduleTime = system.now().addMinutes(1);
        //String minute = string.valueof(nextScheduleTime.minute());
        //String second = string.valueof(nextScheduleTime.second ());
        //String cronExpression = second+' '+minute+' * * * ?' ;

        String cronExpression = getCronTriggerExpression(frequency, preferredTime, weeklyFrequency, monthlyFrequency, day, week);
                                                    
        if (jobName != null && cronExpression != null){
            
            try {
                jobId = system.schedule(jobName, cronExpression, new ReportDeliveryScheduled());
            } catch (Exception e) {
                errorMsg = e.getMessage();
                System.debug('### SchedulerUtility:schedule - An error has ocurred while attempting to schedule a job: ' + e.getMessage());
            }       
        }
        
        return jobId;
    }   
}