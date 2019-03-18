global class ScheduleSynchronize3CLogic implements schedulable{

    global void execute(SchedulableContext SC) {
      	Batch_Synchronize3CLogic sync3CLogic = new Batch_Synchronize3CLogic();
    	Database.executeBatch(sync3CLogic,1);
   	}
    
}