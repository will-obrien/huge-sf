global class scheduleUpdateCpeClaims implements Schedulable {
	 global void execute(SchedulableContext sc) {
      UpdateKPI batch = new UpdateKPI('claim'); 
      database.executebatch(batch);
     }
}