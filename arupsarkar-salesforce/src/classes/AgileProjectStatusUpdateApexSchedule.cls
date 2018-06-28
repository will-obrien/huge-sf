global class AgileProjectStatusUpdateApexSchedule implements Schedulable{

    global void execute(SchedulableContext SC) {
        AgileProjectStatusUpdateApexBatch agileProjectApex = new AgileProjectStatusUpdateApexBatch();
        ID batchprocessid = Database.executeBatch(agileProjectApex);        
    }

}