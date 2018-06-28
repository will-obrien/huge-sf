//*********************************************************************************************************
//Name              : AccountTrigger
//Created By        : Kapil Choudhary(Appirio JDC)
//Created Date      : March 18, 2014
//Description       : AccountTrigger will call the handler class.
//Last Updated      : 2017/05/24 VB: Adding before update to handle setting of No Phone on related Contacts  
//*********************************************************************************************************
trigger AccountTrigger on Account (before insert, before update) {

  AccountTriggerHandler accTrHandle = new AccountTriggerHandler();

  if(Trigger.isInsert) {
    accTrHandle.OnBeforeInsert(Trigger.new);
    
  } else if(Trigger.isUpdate) {
    accTrHandle.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
  }
}