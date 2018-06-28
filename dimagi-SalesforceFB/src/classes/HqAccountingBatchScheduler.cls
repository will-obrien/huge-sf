/**
 * Schedules Commcare Accounting synchronization from many servers.
 */
public class HqAccountingBatchScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        HqBatchJobHelper.startBatchJobs();
    }
}