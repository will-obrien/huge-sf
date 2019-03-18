trigger TotalWorkingLogHours on Working_Hours__c (after insert, after update,after delete) {
    set<id> ids = new set<id>();   
   if(trigger.isInsert || Trigger.isUpdate){
        for(Working_Hours__c  obj : Trigger.new){
            ids.add(obj.lightingprefix__Name__c);
        }
    }
    if(Trigger.isDelete){
        for(Working_Hours__c  obj : Trigger.old){
            ids.add(obj.lightingprefix__Name__c);
        }
    }
    
    
    AggregateResult[]  Total  = [SELECT sum(lightingprefix__Hours__c) FROM lightingprefix__Working_Hours__c where lightingprefix__Name__c =: ids];
      system.debug('#######'+total);
    list<Employee__c> emp = [select id,count__c from Employee__c where id IN : ids];
    for(Employee__c obj : emp){
        obj.count__c = Integer.valueOf(Total[0].get('expr0'));
    }
    update emp ;
}