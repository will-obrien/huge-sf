global class scheduleUpdateContracts implements Schedulable {
   global void execute(SchedulableContext sc) {
      updateContracts batch = new updateContracts(); 
      database.executebatch(batch);
   }
}