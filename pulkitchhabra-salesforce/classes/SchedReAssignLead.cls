global class SchedReAssignLead implements Schedulable{
    global void execute(SchedulableContext sc){
        ReAssignLead RAL = new ReAssignLead();
        Database.executeBatch(RAL);	
    }
}