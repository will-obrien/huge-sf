/**
 * Schedules Commcare Domains synchronization from many servers.
 */
public class HqDomainsBatchScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        HqBatchJobHelper.startDomainJob();
    }
}