global with sharing class KVApexSchedule implements Schedulable
{
    //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year,
    // 1.   Seconds
    // 2.   Minutes
    // 3.   Hours
    // 4.   Days of month
    // 5.   Month
    // 6.   Day of week
    // 7.   Year (optional)
    //Example: This test runs a scheduled job at midnight Sept. 3rd. 2022
    //public static String CRON_EXP = '0 0 0 3 9 ? 2022';
    //Refer to : http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_scheduler.htm
    
    //This Apex job will run every hour
    public static final String CRON_EXP = '0 0 0-23 * * ?';
    
    public interface IApexSchedule
    {
        void execute(SchedulableContext sc);
    }
    
    global void execute(SchedulableContext sc) 
    {
        Type t = Type.forName('KVApexScheduleExecute');
        if(t != null)
        {
            IApexSchedule KVApexScheduler = (IApexSchedule) t.NewInstance();
            KVApexScheduler.execute(sc);
        }
    }

    /*
    static testMethod void testExecute()
    {
        Test.startTest();
        String tmpId = System.schedule('ApexScheduleTest', KVApexSchedule.CRON_EXP, new KVApexSchedule());
        system.assert(tmpId != null);
        Test.stopTest();
    } 
    */   
        
}