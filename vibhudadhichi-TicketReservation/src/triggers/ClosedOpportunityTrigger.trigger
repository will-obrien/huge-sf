trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

    List<Task> taskList = new List<Task>();
    
    for(Opportunity opp : Trigger.new) {
        
        //Only create Follow Up Task only once when Opp StageName is to 'Closed Won' on Create
        if(Trigger.isInsert) {
            if(Opp.StageName == 'Closed Won') {
                taskList.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id));
            }
        }
        
        //Only create Follow Up Task only once when Opp StageName changed to 'Closed Won' on Update
        if(Trigger.isUpdate) {
            if(Opp.StageName == 'Closed Won' 
            && Opp.StageName != Trigger.oldMap.get(opp.Id).StageName) {
                taskList.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id));
            }
        }       
    }

    if(taskList.size()>0) {        
        insert taskList;        
    }    
}