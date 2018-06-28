global class closelostopps implements Schedulable {
   global void execute(SchedulableContext sc) {
      batchClosePendingOpportunities batch = new batchClosePendingOpportunities(); 
      database.executebatch(batch);
   }
}