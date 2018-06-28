global class ScheduleReminders implements Schedulable {
    global void execute(SchedulableContext sc) {
        RemindersBatch rb = new RemindersBatch(); 
        Database.executebatch(rb);
   }
}