/*********************************************************************
Name : SetDefaultUserRelatedField 
Created On : March 2, 2012  
Created By : Appirio
Description : Created a trigger to set case user related fields defaulted from Owners User record.
**********************************************************************/

trigger SetDefaultCaseUserField on Case (before insert, before update) {
        //declare map with Owners Oportunities which has to be updated the region field of User
    map<String,list<Case>> CaseSubittedEmailset = new map<String,list<Case>>(); 
    for(Case Ca: Trigger.new){            
        // check Owner Region Field is blank
        if(trigger.isInsert || trigger.isUpdate){
            if(CaseSubittedEmailset.Containskey(Ca.Submitted_By_Contact_Email__c)){
                // put into maP
                CaseSubittedEmailset.get(Ca.Submitted_By_Contact_Email__c).add(Ca);
            }
            else{
                // put into maP
                CaseSubittedEmailset.put(Ca.Submitted_By_Contact_Email__c,new list <Case>());
                CaseSubittedEmailset.get(Ca.Submitted_By_Contact_Email__c).add(Ca);
            }
        }
         
    }
    if(CaseSubittedEmailset.Size() > 0){
       //Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
      Boolean isInActiveTrigger = false;
      // query form Custom setting
      for(Trigger_Settings__c ts : [Select InactivateSetDefaultCaseUsersField__C From Trigger_Settings__c]){
          // Set settting into veriable
          isInActiveTrigger = ts.InactivateSetDefaultCaseUsersField__C;
      }
    //  system.debug('---------isInActiveTrigger----------------'+isInActiveTrigger);
      //  is trigger execute?
      
      if(isInActiveTrigger == false){
        // query user region field
            map<String,User> UserInfo  = new map<String,User>();
            
            for(User user:[Select Id, Username,Region__c,Channel__c,Location__c,Manager.Name From User where 
            Username in: CaseSubittedEmailset.keySet() ]){
                if(!UserInfo.containsKey(user.Username)){
                    UserInfo.put(user.Username,user);
                }
            }
            //system.debug('---------UserInfo----------------'+UserInfo);
            //system.debug('---------CaseSubittedEmailset----------------'+CaseSubittedEmailset);
            if(UserInfo != null && UserInfo.size()>0){
              for(String Uid : CaseSubittedEmailset.keyset()){
                  //system.debug('---------Uid----------------'+Uid);
                  if(UserInfo.containsKey(Uid)){
                      for(Case Ca : CaseSubittedEmailset.get(Uid)){
                          Ca.Submitted_By_User__c =UserInfo.get(Uid).Id; 
                          Ca.Owner_Region__c = UserInfo.get(Uid).Region__c;                         
                          Ca.Channel__c = UserInfo.get(Uid).Channel__c;
                          Ca.Location__c =UserInfo.get(Uid).Location__c;
                         Ca.Supervisor__c =UserInfo.get(Uid).Manager.Name; 
                         
                      }
                  }
              }
            }

}
}
}