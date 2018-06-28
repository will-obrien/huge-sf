global class SchedulableContractHandler implements Schedulable{
   global void execute(SchedulableContext SC) { contractUtil.ProcessContractExpirations(); }
}