/*********************************************************************
Name : Test_DuplicateLeadDeleteBatch 
Created On : dec 20 , 2011  
Created By : Lalit Bohra
Description : Scheduler class for scheduling the DuplicateLeadDeleteBatch batch
**********************************************************************/
global class DuplicateLeadDeleteScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        DuplicateLeadDeleteBatch b = new DuplicateLeadDeleteBatch();
        database.executebatch(b,50);
    }
}