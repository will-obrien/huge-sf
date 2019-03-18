/*********************************************************************
Name : SetDefaultTaskValuesFromOwner 
Created On : feb 14, 2012 
Created By : Lalit Bohra
Description : Created a trigger do set (default) values from Owner fied to the Task object
**********************************************************************/
trigger SetDefaultTaskValuesFromOwner on Task (before insert, before update) {
//	system.debug('--------------- fires SetDefaultLeadRegionFietask');
    //Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
    Boolean isInActiveTrigger = false;
    // query form Custom setting
    for(Trigger_Settings__c ts : [Select InactivateSetDefaultTaskValuesFromOwner__c From Trigger_Settings__c]){
        // Set settting into veriable
        isInActiveTrigger = ts.InactivateSetDefaultTaskValuesFromOwner__c;
    }
  //  system.debug('---------isInActiveTrigger----------------'+isInActiveTrigger);
    //  is trigger execute?
    if(isInActiveTrigger == false){
        //declare map with Owners Lead which has to be updated the region fietask of User
        map<Id,list<Task>> TaskswithOwnerId = new map<Id,list<Task>>(); 
        // Here we preparing map of All Users whose profile is "System Administrator***"
	    //map<ID, User> adminUserMap = new map<ID, User>([Select ID, Name from User where Profile.Name like :'System Administrator%' ]); 
        for(Task task: Trigger.new){            
        	 if(trigger.isInsert || (trigger.isUpdate && task.OwnerId != trigger.oldMap.get(task.Id).OwnerId)){
           // 	system.debug('----------- we are here in loop');
                if(TaskswithOwnerId.Containskey(task.OwnerId)){
                    // put into maP
                    TaskswithOwnerId.get(task.OwnerId).add(task);
                }
                else{
                    // put into maP
                    TaskswithOwnerId.put(task.OwnerId,new list <Task>());
                    TaskswithOwnerId.get(task.OwnerId).add(task);
                }      
        	 }          
        }
        if(TaskswithOwnerId.Size() > 0){
           // query user fields
            map<Id,User> UserInfo  = new map<Id,User>([Select Id, Region__c,Channel__c,Manager.Name,Location__c From User where Id in: TaskswithOwnerId.keySet()]);
            if(UserInfo != null && UserInfo.size()>0){
	            for(String Uid : TaskswithOwnerId.keyset()){
	                if(UserInfo.containsKey(Uid)){
	                    for(Task task : TaskswithOwnerId.get(Uid)){
	              //          system.debug('------------------ UserInfo.get(Uid).Region__c'+UserInfo.get(Uid).Region__c);                        
	                        task.Owner_Region__c = UserInfo.get(Uid).Region__c;                         
	                        task.Channel__c = UserInfo.get(Uid).Channel__c;
	                        task.Location__c =UserInfo.get(Uid).Location__c;
	                        task.Supervisor__c =UserInfo.get(Uid).Manager.Name; 
	                 //       system.debug('------------------ task'+task);
	                    }
	                }
	            }
            }           
        }
    }
}