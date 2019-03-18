trigger updateTaskActivityDate on Task (after update){
    set<id> caseIds = new set<id>();
    list<case> caseToUpdateList = new list<case>();
    
    for(task ts : Trigger.new){    
      String whatId = String.valueOf(ts.WhatId);
      if(whatId.StartsWith('500')){
          if((Trigger.isInsert && ts.status == 'Completed') || (Trigger.isUpdate && ts.status == 'Completed' && Trigger.oldMap.get(ts.id).status != ts.status)){
              caseIds.add(ts.whatId);
          }
          
      }
    }
    if(caseIds.size()>0){
        caseToUpdateList =  [SELECT id, lightingprefix__Last_update_activity_date__c FROM case WHERE id IN :caseIds];
        for(case cs : caseToUpdateList) {
            cs.lightingprefix__Last_update_activity_date__c = System.now();
        }
        update caseToUpdateList;
    }
}