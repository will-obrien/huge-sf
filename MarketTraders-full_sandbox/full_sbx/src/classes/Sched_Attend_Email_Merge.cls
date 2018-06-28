global class Sched_Attend_Email_Merge implements Schedulable{
    global void execute(SchedulableContext SC) {
        Batch_AttendanceEmailSync batch = new Batch_AttendanceEmailSync();
        Database.executeBatch(batch);
    } 
}