global class schedulecancelExamAttempt implements Schedulable {
   global void execute(SchedulableContext sc) {
      cancelExamAttempt batch = new cancelExamAttempt(); 
      database.executebatch(batch);
   }
}