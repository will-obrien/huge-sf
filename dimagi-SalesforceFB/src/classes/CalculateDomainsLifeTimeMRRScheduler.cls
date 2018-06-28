/**
 * Schedules CalculateDomainsLifeTimeMRRBatch job for calculating Domains Lifetime MRR.
 */
public class CalculateDomainsLifeTimeMRRScheduler implements Schedulable {

    public CalculateDomainsLifeTimeMRRScheduler  () {}

    public void execute(SchedulableContext sc) {
       Database.executeBatch(new CalculateDomainsLifeTimeMRRBatch(), 100);
    }
}