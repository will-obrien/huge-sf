/*
  This trigger will update the Project Portfolio Manager on Estimate_Planned__c Object objects with the Portfolio Manager detail on Project__c Object 
  **********************************************************
  Author: Shrawan Raina
  Audit History
  **********************************************************
  07/18/2014        Shrawan Raina       Created
  **********************************************************  
*/ 
trigger Estimate_Trigger on Estimate_Planned__c (before insert, before update) {
    Set<ID> projIds = new Set<ID>();
    for(Estimate_Planned__c estObj: Trigger.new){
        projIds.add(estObj.Project__c);
    }
    Map<ID, Project__c> projMap = new Map<ID, Project__c>([SELECT Portfolio_Manager__c FROM Project__c WHERE Id IN :projIds]);
    for(Estimate_Planned__c estObj: Trigger.new){
        Project__c projId = projMap.get(estObj.Project__c);
        if(projId.Portfolio_Manager__c != null){
            estObj.Project_Portfolio_Manager__c = projId.Portfolio_Manager__c;  
        }
    }
}