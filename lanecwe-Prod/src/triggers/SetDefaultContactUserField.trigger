/*********************************************************************
Name : SetDefaultContactUserField 
Created On : Feb 29, 2012  
Created By : Jayanth Palakshiah
Description : Created a trigger do set (default) the user Related fields on the Contact object from User object
**********************************************************************/

trigger SetDefaultContactUserField on Contact (before insert, before update) {
       //map<Id,list<Contact>> ConatctswithOwnerId = new map<Id,list<Contact>>();
       map<Id,list<Contact>> ContactswithOwnerId = new map<Id,list<Contact>>();
        
        for(Contact Con: Trigger.new){
                  if((trigger.isInsert || (trigger.isUpdate && Con.OwnerId != trigger.oldMap.get(Con.Id).OwnerId))){
               //   system.debug('----------- we are here in loop');
                  if(ContactswithOwnerId.Containskey(Con.OwnerId)){
                      // put into maP
                      ContactswithOwnerId.get(Con.OwnerId).add(Con);
                  }
                  else{
                      // put into maP
                      ContactswithOwnerId.put(Con.OwnerId,new list <Contact>());
                      ContactswithOwnerId.get(Con.OwnerId).add(Con);
                  }
                }
           }
        if(ContactswithOwnerId.Size() > 0){
          Boolean isInActiveTrigger = false;
        // query form Custom setting
        for(Trigger_Settings__c ts : [Select InactivateSetDefaultContactUsersField__c From Trigger_Settings__c]){
            // Set settting into veriable
            isInActiveTrigger = ts.InactivateSetDefaultContactUsersField__c;
        }
        if(isInActiveTrigger == false){
            // query user region field
              map<Id,User> UserInfo  = new map<Id,User>([Select Id, Region__c,Channel__c,Manager.Name,Location__c From User 
              where Id in: ContactswithOwnerId.keySet() and (not Profile.Name like:'System Administrator%')]);
              if(UserInfo != null && UserInfo.size()>0){
                
                  for(String Uid : ContactswithOwnerId.keyset()){
                      if(UserInfo.containsKey(Uid)){
                          for(Contact Con : ContactswithOwnerId.get(Uid)){
                        //      system.debug('------------------ UserInfo.get(Uid).Region__c'+UserInfo.get(Uid).Region__c);                        
                              Con.Owner_Region__c = UserInfo.get(Uid).Region__c;                         
                              Con.Channel__c = UserInfo.get(Uid).Channel__c;
                              Con.Location__c =UserInfo.get(Uid).Location__c;
                              Con.Supervisor__c =UserInfo.get(Uid).Manager.Name; 
                          //    system.debug('------------------ Ld'+Con);
                          }
                      }
                  }
        }
            }           
        }
}