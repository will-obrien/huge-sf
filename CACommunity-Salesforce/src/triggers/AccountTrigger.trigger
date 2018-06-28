// Trigger for the case object which handles all the events and based on the event delegates the task 
// to the corresponding trigger handler method in the accountTriggerHelper class

trigger AccountTrigger on Account (before insert, before update, after insert, after update, before delete) {

    if(trigger.isBefore){
       
       if(trigger.isInsert) {
        
           AccountTriggerHelper.SetAccountStatusFieldOnInsert(Trigger.New);
           AccountTriggerHelper.validateParentAccountForIntermediateCA(Trigger.new);
          
       }
        
       if(trigger.isUpdate){
            
            AccountTriggerHelper.validateParentAccountForIntermediateCA(Trigger.new);
       }        
    }
    
    //trigger will be called for After Insert & before insert and update, only for single record, bulk request is not supported.
    if(Trigger.size == 1 && !Trigger.isDelete && ((Trigger.isAfter && Trigger.isInsert) || Trigger.isBefore)){
        
        Account oldAccount = null;
        if(!Trigger.isInsert){
            oldAccount = Trigger.oldMap.get(Trigger.new[0].Id);
        }
        AccountTriggerHelper.updateCAOwnerFields(Trigger.new[0], oldAccount);
    }
    
    if(Trigger.size == 1 && Trigger.isDelete && Trigger.isBefore){
        //system.debug('Trigger.old: '+Trigger.old);
        String errorMessage = AccountTriggerHelper.checkDeleteValidation(Trigger.old[0]);
        
        if(errorMessage != null){
            Trigger.old[0].addError(errorMessage);    
        }
    }
    
   /* if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert) && !AccountTriggerHelper.isAccountTriggerRunning)
    {
      AccountTriggerHelper.isAccountTriggerRunning = true;
      AccountTriggerHelper.extract509CertificateAfterUpdate(trigger.old,trigger.new,trigger.oldMap,trigger.newMap);
    }*/
}