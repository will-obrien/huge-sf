/**
 * Schedules BatchCalculateTotalHoursOfTimeCard job for calculating Services Spend value.
 */
global without sharing class BatchCalculateTotalHoursScheduler implements Schedulable {

    public BatchCalculateTotalHoursScheduler () {}

    global void execute(SchedulableContext sc) {
       Database.executeBatch(new BatchCalculateTotalHoursOfTimeCard(), 200);
    }
}