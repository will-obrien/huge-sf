global class scheduleDeclinedRecurringTrans implements Schedulable {
   global void execute(SchedulableContext sc) {
      processRecurringTransactions b = new processRecurringTransactions(); 
      database.executebatch(b,1);
   }
}