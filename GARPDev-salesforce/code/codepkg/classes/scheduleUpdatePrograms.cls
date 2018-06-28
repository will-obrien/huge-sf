global class scheduleUpdatePrograms implements Schedulable {

        global void execute(SchedulableContext sc) {
      UpdateKPI batch = new UpdateKPI('contract'); 
      database.executebatch(batch);
     }
}