global class AuditReminderBatchSchedulerClass implements Schedulable{

    public static String sched = '0 00 00 * * ?';  //Every Day at Midnight 

    global static String scheduleMe() {
        AuditReminderBatchSchedulerClass  SC = new AuditReminderBatchSchedulerClass(); 
        return System.schedule('Audit Reminder Batch', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        AuditReminderBatch b1 = new AuditReminderBatch();
        ID batchprocessid = Database.executeBatch(b1,10);           
    }
}