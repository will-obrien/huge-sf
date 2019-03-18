trigger SetOwnerCopy on Lead (before insert,before update) { 
    
  if(!(Test.isRunningTest())){
  Bypassrules__c profileCustomSetting = Bypassrules__c.getInstance(UserInfo.getUserId());
      System.debug('profileCustomSetting: ' + profileCustomSetting);
      System.debug('profileCustomSetting.Trigger_Objects__c: ' + profileCustomSetting.Trigger_Objects__c);
      System.debug('profileCustomSetting.Disable_Triggers__c: ' + profileCustomSetting.Disable_Triggers__c);
      if(profileCustomSetting.Trigger_Objects__c != null) {
  	  	if(!(profileCustomSetting.Trigger_Objects__c.contains('Lead') && profileCustomSetting.Disable_Triggers__c)){
  			String TempID= ''; 
				for(Lead ld:trigger.new) {
       				TempID=ld.OwnerId;   
       				system.debug('#---- TempID'+TempID);
  					if(TempID != null) {  
                        system.debug('I am 1');
             			if(TempID.startsWith('005')) {  
                            system.debug('I am 2');
                          	ld.Owner_Copy__c=ld.OwnerID;
                  		}
             			else { 
                            system.debug('I am 3');
	                        ld.Owner_Copy__c=null;
                  		}
        			}  
    			}
  			}
      	}
  	}
}