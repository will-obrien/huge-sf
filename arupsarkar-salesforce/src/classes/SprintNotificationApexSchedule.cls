global class SprintNotificationApexSchedule implements schedulable{
    global void execute(SchedulableContext SC) {
    
        SprintNotificationApexBatch sprintApex = new SprintNotificationApexBatch();
        ID batchprocessid = Database.executeBatch(sprintApex);
    }
}