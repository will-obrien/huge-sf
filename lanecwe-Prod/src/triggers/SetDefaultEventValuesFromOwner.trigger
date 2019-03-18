/*********************************************************************
Name : SetDefaultEventValuesFromOwner 
Created On : feb 14, 2012 
Created By : Lalit Bohra
Description : Created a trigger do set (default) values from Owner field to the Event object
**********************************************************************/
trigger SetDefaultEventValuesFromOwner on Event (before insert, before update) {
//system.debug('--------------- fires SetDefaultLeadRegionFieEvent');
    //Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
    Boolean isInActiveTrigger = false;
    // query form Custom setting
    for(Trigger_Settings__c ts : [Select InactivateSetDefaultEventValuesFromOwner__c From Trigger_Settings__c]){
        // Set settting into veriable
        isInActiveTrigger = ts.InactivateSetDefaultEventValuesFromOwner__c;
    }
   // system.debug('---------isInActiveTrigger----------------'+isInActiveTrigger);
    //  is trigger execute?
    if(isInActiveTrigger == false){
        //declare map with Owners Lead which has to be updated the region fieEvent of User
        map<Id,list<Event>> EventswithOwnerId = new map<Id,list<Event>>();       
        for(Event event: Trigger.new){            
        	if(trigger.isInsert || (trigger.isUpdate && event.OwnerId != trigger.oldMap.get(event.Id).OwnerId)){
            //	system.debug('----------- we are here in loop');
                if(EventswithOwnerId.Containskey(event.OwnerId)){
                    // put into maP
                    EventswithOwnerId.get(event.OwnerId).add(event);
                }
                else{
                    // put into maP
                    EventswithOwnerId.put(event.OwnerId,new list <event>());
                    EventswithOwnerId.get(event.OwnerId).add(event);
                }                
        	}
        }
        if(EventswithOwnerId.Size() > 0){
            // query user fields
            map<Id,User> UserInfo  = new map<Id,User>([Select Id, Region__c,Channel__c,Manager.Name,Location__c From User where Id in: EventswithOwnerId.keySet()]);
           if(UserInfo != null && UserInfo.size()>0){
	           for(String Uid : EventswithOwnerId.keyset()){
	                if(UserInfo.containsKey(Uid)){
	                    for(Event event : EventswithOwnerId.get(Uid)){
	                    //    system.debug('------------------ UserInfo.get(Uid).Region__c'+UserInfo.get(Uid).Region__c);                        
	                        event.Owner_Region__c = UserInfo.get(Uid).Region__c;                         
	                        event.Channel__c = UserInfo.get(Uid).Channel__c;
	                        event.Location__c =UserInfo.get(Uid).Location__c;
	                        event.Supervisor__c =UserInfo.get(Uid).Manager.Name; 
	                   //     system.debug('------------------ Event'+event);
	                    }
	                }
	           }
           }           
        }
    }
}