global class PROEmailRemindarClearDataBatch_Scheduled implements Schedulable {
   global void execute(SchedulableContext sc) {
      PROEmailRemindarClearDataBatch b = new PROEmailRemindarClearDataBatch(); 
      database.executeBatch(b,50);
   }
}