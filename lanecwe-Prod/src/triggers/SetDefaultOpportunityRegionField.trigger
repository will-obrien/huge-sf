/*********************************************************************
Name : SetDefaultOpportunityRegionField 
Created On : dec 20, 2011  
Created By : Dileep Singhal
Description : Created a trigger do set (default) the Region on the Opportunity object
**********************************************************************/

trigger SetDefaultOpportunityRegionField on Opportunity (before insert, before update) {
        
    //declare map with Owners Oportunities which has to be updated the region field of User
    map<Id,list<Opportunity>> OptyswithOwnerId = new map<Id,list<Opportunity>>(); 
    for(Opportunity Op: Trigger.new){            
        // check Owner Region Field is blank
        if(trigger.isInsert || (trigger.isUpdate && Op.OwnerId != trigger.oldMap.get(Op.Id).OwnerId)){
            if(OptyswithOwnerId.Containskey(Op.OwnerId)){
                // put into maP
                OptyswithOwnerId.get(Op.OwnerId).add(Op);
            }
            else{
                // put into maP
                OptyswithOwnerId.put(Op.OwnerId,new list <Opportunity>());
                OptyswithOwnerId.get(Op.OwnerId).add(Op);
            }
        }
         
    }
    if(OptyswithOwnerId.Size() > 0){
    	 //Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
	    Boolean isInActiveTrigger = false;
	    // query form Custom setting
	    for(Trigger_Settings__c ts : [Select InactivateSetDefaultOpportunityRegionFie__c From Trigger_Settings__c]){
	        // Set settting into veriable
	        isInActiveTrigger = ts.InactivateSetDefaultOpportunityRegionFie__c;
	    }
	  //  system.debug('---------isInActiveTrigger----------------'+isInActiveTrigger);
	    //  is trigger execute?
	    
	    if(isInActiveTrigger == false){
        // query user region field
            map<Id,User> UserInfo  = new map<Id,User>([Select Id, Region__c,Manager.Name,Location__c,Channel__c From User where 
            Id in: OptyswithOwnerId.keySet() and (not Profile.Name like:'System Administrator%')]);
            if(UserInfo != null && UserInfo.size()>0){
	            for(String Uid : OptyswithOwnerId.keyset()){
	                if(UserInfo.containsKey(Uid)){
	                    for(Opportunity Op : OptyswithOwnerId.get(Uid)){
	                        Op.Owner_Region__c = UserInfo.get(Uid).Region__c; 
	                        Op.Channel__c =UserInfo.get(Uid).Channel__c; 
	                        Op.Location__c =UserInfo.get(Uid).Location__c;
	                        Op.Supervisor__c =UserInfo.get(Uid).Manager.Name; 
	                       
	                    }
	                }
	            }
            }
            // T-35434 Populate Owner Manage email address in Super visor email address field.
             map<Id,User> UserManagerInfo  = new map<Id,User>([Select u.Manager.Email,Id  From User u where 
            Id in: OptyswithOwnerId.keySet()]);
            if(UserManagerInfo != null && UserManagerInfo.size()>0){
	            for(String Uid : OptyswithOwnerId.keyset()){
	                if(UserManagerInfo.containsKey(Uid)){
	                    for(Opportunity Op : OptyswithOwnerId.get(Uid)){
	                        Op.Supervisors_Email__c=UserManagerInfo.get(Uid).Manager.Email; 
	                    }
	                }
	            }
            }             
	    }           
    }    
}