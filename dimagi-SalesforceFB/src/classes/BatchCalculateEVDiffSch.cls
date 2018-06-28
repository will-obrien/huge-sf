/**
 * Calculates NetDiff for Closed opps in last month (Pipeline Snapshot wasn't created).
 */
public class BatchCalculateEVDiffSch implements Schedulable {

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchCalculateEVDiff(Date.today().toStartOfMonth().addDays(-1)));
    }
}