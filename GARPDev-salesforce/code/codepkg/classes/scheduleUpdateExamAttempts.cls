global class scheduleUpdateExamAttempts implements Schedulable {

        global void execute(SchedulableContext sc) {
      UpdateKPI batch = new UpdateKPI('examattempt'); 
      database.executebatch(batch);
     }
}