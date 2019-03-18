global class UnitBatchScheduled implements Schedulable
{
    global void execute (SchedulableContext sc)
    {
        Database.executeBatch(new UnitBatch());
    }
}