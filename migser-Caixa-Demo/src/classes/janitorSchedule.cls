global class janitorSchedule implements Schedulable{
  global void execute(SchedulableContext SC){
    chatterJanitor.cleanHouse('cjimson@mailinator.com'); 
  }
}