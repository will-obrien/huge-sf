global class schedulecreateaffiliatecontract implements Schedulable {
   global void execute(SchedulableContext sc) {
      createaffiliatecontract batch = new createaffiliatecontract(); 
      database.executebatch(batch);
   }
}