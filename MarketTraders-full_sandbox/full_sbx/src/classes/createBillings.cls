global without sharing class createBillings implements Schedulable {
    
    // to run.. createBillings  s=new createBillings (5);
    //s.execute(null);
    //
    
    Integer intervalMinutes;
    public createBillings(Integer intervalMinutes) {
        this.intervalMinutes = intervalMinutes;
    }
    global void execute(SchedulableContext sc) {
        // Re-schedule ourself to run again in "intervalMinutes" time
        DateTime now  = DateTime.now();
        DateTime nextRunTime = now.addMinutes(intervalMinutes);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
            nextRunTime.month() + ' ? ' + nextRunTime.year(); 
        System.schedule(createBillings.class.getName() + '-' + now.format(), cronString, new createBillings(intervalMinutes));
        // Abort the current job
        if(sc != null){
            Id jobId = sc.getTriggerId();
            System.abortJob(jobId);    
        } 
        // Launch a batch job or call a future method to do the actual work
       // Database.executeBatch(new SomeBatchJob());
        createBillingBatch  logObj = new createBillingBatch  ();
        logObj.query = 'SELECT id  FROM opportunity where StageName = \'Closed Won\' and Create_billing__c = true and billing_created__c = false and Error_Creating_Billing__c = false' ;
        Database.executeBatch(logObj ,1);
       
       //checkEvents.execute();
    }
}