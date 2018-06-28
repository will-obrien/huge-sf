global class PROEmailRemindarBatch_Scheduled implements Schedulable {
   global void execute(SchedulableContext sc) {
      PROEmailRemindarBatch b = new PROEmailRemindarBatch(); 
      database.executebatch(b, 20);
   }
}