global class TRC_Dashboard_Data_Retrieval implements Schedulable {

	global void execute(SchedulableContext SC) {
      TRC_Dashboard_Data t = new TRC_Dashboard_Data();
      t.getTRCResults();
   }
}