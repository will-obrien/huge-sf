/*
 * Class responsible for scheduling LogsDeletingBatch.
 */
global class LogsDeletingBatchSchedule implements Schedulable {

    global void execute(SchedulableContext sc) {
        LogsDeletingBatch logsDeleting = new LogsDeletingBatch();
        Database.executeBatch(logsDeleting);
    }
}