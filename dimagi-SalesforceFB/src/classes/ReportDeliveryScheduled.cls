/**
 * This class is a Schedulable to execute the delivery of reports
 *
 * @author Diego Febles <diego.febles@roundfusion.com>
 * @since 2014-08
 */
global with sharing class ReportDeliveryScheduled implements Schedulable,Database.AllowsCallouts  {

    public static String CRON_EXP = '0 0 0 3 9 ? 2022'; // for testing purposes 

    global void execute(SchedulableContext sc) {
        
        System.debug('Trigger Id: '+sc.getTriggerId());
        // Run the following code if I am in a test
        /*if (Test.isRunningTest()) {
            // Start of code for testing purposes
            CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :sc.getTriggerId()];
    
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
            // End of code for testing purposes
        }*/
        
        // Code to execute at scheduled time
        ReportDeliveryUtility.deliverReport(sc.getTriggerId());     
    }
}