global class LogsBatchDeleteSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      LogsBatchDelete b = new LogsBatchDelete(); 
      database.executebatch(b);
   }
}