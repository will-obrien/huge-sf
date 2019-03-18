trigger ClosedOpportunityTrigger on Opportunity (before insert,before update) {
    list<Task>tasks=new list<Task>();   
    for(Opportunity op:trigger.new)
{
   if(op.StageName=='Closed Won'){
       Task t=new Task();
     t.OwnerId=op.OwnerId;
     t.subject='Follow Up Test Task';
     t.WhatId=op.ID;   
        tasks.add(t);     
   }
    
}
    insert tasks;
    update tasks;
}