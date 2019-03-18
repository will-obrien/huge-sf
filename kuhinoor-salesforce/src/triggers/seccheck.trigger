trigger seccheck on checkOpp__c (before insert) {
  
    if(trigger.isInsert){
        for(checkOpp__c  c : trigger.old){
            checkopp__c  oldValue = trigger.oldMap.get(c.id);
            system.debug(oldvalue);
            if(c.check__c == oldValue.check__c){
                oldValue.check__c=false;
            }
     
   
        }
        
    }

}