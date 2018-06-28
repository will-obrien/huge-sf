global class Batch_Sync_IE_Unit_Schedular implements Schedulable {
  
  
  global void execute(SchedulableContext SC) 
  {
    integer bsize = 1;
    
    Database.executeBatch(new Batch_Sync_IE_Unit('Pending'), bsize);

  }

}