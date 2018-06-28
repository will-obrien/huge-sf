global class SprintStatusUpdateApexSchedule implements Schedulable{

    global void execute(SchedulableContext SC) {
        SprintStatusUpdateApexBatch sprintStatusUpdateBatch = new SprintStatusUpdateApexBatch();
        ID batchprocessid = Database.executeBatch(sprintStatusUpdateBatch);        
    }    
    
}