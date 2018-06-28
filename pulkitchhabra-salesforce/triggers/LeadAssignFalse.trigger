trigger LeadAssignFalse on Lead (before update) {
    for(Lead newLd : trigger.new){
        Lead oldLd = Trigger.oldMap.get(newLd.Id);
        if (newLd.Pulkit__Python_Api_Flag__c != oldLd.Pulkit__Python_Api_Flag__c && newLd.Pulkit__Python_Api_Counter__c == 0) {
            newLd.Pulkit__ActualOwner__c = newLd.OwnerId;
        } 
        if (newLd.Pulkit__Python_Api_Counter__c != NULL && newLd.Pulkit__Python_Api_Counter__c == 1){
            newLd.OwnerId = newLd.Pulkit__ActualOwner__c;
            newLd.Pulkit__Python_Api_Flag__c = false;
        }
    }
}