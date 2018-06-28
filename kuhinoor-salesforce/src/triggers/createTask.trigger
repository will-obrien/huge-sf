trigger createTask on Opportunity (after insert,before update) {
    List<task> taskToInsertList = new List<task>();
    for(opportunity opp : trigger.new){
        if('Closed Won' == opp.StageName && Trigger.oldMap.get(opp.id).StageName != opp.StageName )
         taskToInsertList.add(new Task(Subject='opportunitestask',WhatId=opp.id));   
    }
    if(taskToInsertList.size()>0){
        insert taskToInsertList;
    }
    
}