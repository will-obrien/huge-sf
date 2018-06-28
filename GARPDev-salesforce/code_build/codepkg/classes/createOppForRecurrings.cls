global class createOppForRecurrings implements Schedulable {
   global void execute(SchedulableContext sc) {
      CreateOppRecurringsBatch oppBatch = new CreateOppRecurringsBatch(); 
      database.executebatch(oppBatch);
   }
}