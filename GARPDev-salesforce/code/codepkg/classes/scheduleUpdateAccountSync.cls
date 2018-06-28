global class scheduleUpdateAccountSync implements Schedulable {
   global void execute(SchedulableContext sc) {
      UpdateAccountSync batch = new UpdateAccountSync('date'); 
      database.executebatch(batch);
   }
}