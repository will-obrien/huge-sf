/**
 * Schedules LeadQualifyProcessBatch job for calculating Domains Lifetime MRR.
 */
public class LeadQualifyProcessScheduler implements Schedulable {

    public LeadQualifyProcessScheduler  () {}

    public void execute(SchedulableContext sc) {
       Database.executeBatch(new LeadQualifyProcessBatch(), 200);
    }
}