//*********************************************************************************************************
//Name              : ContactTrigger
//Created By        : Kapil Choudhary(Appirio JDC)
//Created Date      : March 18, 2014
//Description       : ContactTrigger will call the handler class.
//Last Updated      : 
//                    
//	7/2017 Maslow - Add call to MoveZDMFromAccountsToContacts.moveInfo

trigger ContactTrigger on Contact (before insert) {
 ContactTriggerHandler conTrHandle = new ContactTriggerHandler();
  conTrHandle.OnBeforeInsert(Trigger.new);
  
  MoveZDMFromAccountsToContacts.moveInfo(Trigger.new);
}