/*
This class queries for open opportunities that should have closed by the current date, and creates a task on each one to remind the owner
to update the opportunity.

-Error: Compile Error: RemindOpptyOwners: Class must implement the global interface method: void execute(SchedulableContext) 
from Schedulable at line 9 column 14    

*/

global class RemindOpptyOwners implements Schedulable {
        
    global void execute(SchedulableContext ctx){
        List<Opportunity> opptys = [SELECT Id, Name, OwnerId, CloseDate 
                                    FROM Opportunity
                                    WHERE isClosed = FALSE 
                                    AND CloseDate < TODAY];
        
        //Create a task for each opportunity in the list                                    
        //TaskUtils.remindOwner(opptys);
    }
}