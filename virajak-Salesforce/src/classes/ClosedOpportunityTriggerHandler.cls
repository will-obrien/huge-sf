public class ClosedOpportunityTriggerHandler {
    public static void doClosedOpp(List<Opportunity> opportunity ){
        List<Task> myTasks = new List<Task>();
        for(Opportunity op :opportunity ){
            if(op.StageName =='Closed Won'){
              myTasks.add(new Task(subject='Follow Up Test Task', whatID = op.ID, Ownerid = op.OwnerId));
            }
        }
        insert myTasks;
    }

}