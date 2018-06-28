public without sharing class BatchRecalculateTimeCardCostScheduler implements Schedulable {

    public BatchRecalculateTimeCardCostScheduler () {}

    public void execute(SchedulableContext sc) {
       Database.executeBatch(new BatchRecalculateTimeCardCost(null), 200);
    }
}