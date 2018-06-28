/*********************************************************************
Name : SetAccountDefaultRegion 
Created On : dec 20, 2011  
Created By : Dileep Singhal
Description : Created a trigger do set (default) the Region on the Account object
**********************************************************************/
 
trigger SetAccountDefaultRegion on Account (before insert, before update) {
            
    //declare map with Owners Account which has to be updated the region field of User
    map<Id,list<Account>> AccountswithOwner = new map<Id,list<Account>>(); 
    for(Account Acc: Trigger.new){	            	            
        	//system.debug('-------- Acc.OwnerId'+Acc.OwnerId);
        	//We will not execute this trigger whose Owner's Profile is "System Administrator****"
        	if(trigger.isInsert || (trigger.isUpdate && Acc.OwnerId != trigger.oldMap.get(Acc.Id).OwnerId)){
                //system.debug('-------------- Testing');
                if(AccountswithOwner.Containskey(Acc.OwnerId)){
                    // put into Map
                    AccountswithOwner.get(Acc.OwnerId).add(Acc);
                }
                else{
                    // put into Map
                    AccountswithOwner.put(Acc.OwnerId,new list <Account>());
                    AccountswithOwner.get(Acc.OwnerId).add(Acc);
                }
               // system.debug('-------- Acc.ChannelType__c'+Acc.ChannelType__c);   
        	}                
    }
    if(AccountswithOwner.Size() > 0){
		    //Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'		  
		    Boolean isInActiveTrigger = false;
		    // query form Custom setting
		    for(Trigger_Settings__c ts : [Select Inactivate_SetAccountDefaultRegion__c From Trigger_Settings__c]){
		        // Set settting into veriable
		        isInActiveTrigger = ts.Inactivate_SetAccountDefaultRegion__c;
		    }
		   // system.debug('---------isInActiveTrigger----------------'+isInActiveTrigger);
		    //  is trigger execute?
			if(isInActiveTrigger == false){	 
		        // query user region field
		        map<Id,User> UserInfo  = new map<Id,User>([Select Id, Region__c,Manager.Name,Location__c,Channel__c From User where Id in: AccountswithOwner.keySet() and (not Profile.Name like:'System Administrator%')]);
		        if(UserInfo != null && UserInfo.size()>0){
		            for(String Uid : AccountswithOwner.keyset()){
		                if(UserInfo.containsKey(Uid)){
		                    for(Account Acc : AccountswithOwner.get(Uid)){      
		                    	//system.debug('---- updating records');                
		                            Acc.Owner_Region__c = UserInfo.get(Uid).Region__c;
		                            if(UserInfo.get(Uid).Channel__c != null && UserInfo.get(Uid).Channel__c !=''){	                            
		                            	Acc.Channel__c =UserInfo.get(Uid).Channel__c; 
		                            }
		                            Acc.Location__c =UserInfo.get(Uid).Location__c;
		                            Acc.Supervisor__c =UserInfo.get(Uid).Manager.Name;                      
		                    }
		                }
		            }
		        }
			}
     }
}