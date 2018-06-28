/**
 * This class for executing GameScheduleBatch class by using System.schedule() method
 * System.schedule() method will create a job to execute this class every day in midnight:
 * System.schedule('Update unit stamina', '0 0 0 * * ?', new ScheduleGameUpdate()); 
*/
global class ScheduleGameUpdate implements Schedulable{
      global void execute(SchedulableContext sc) {
      GameScheduleBatch batch = new GameScheduleBatch(); 
      Database.executeBatch(batch);
   }
}
