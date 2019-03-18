/*********************************************************************
Name : SetDefaultLeadRegionField 
Created On : dec 20, 2011  
Created By : Dileep Singhal
Description : Created a trigger do set (default) the Region on the Lead object
**********************************************************************/

trigger SetDefaultLeadRegionField on Lead (before insert, before update) {
  //  system.debug('--------------- fires SetDefaultLeadRegionField');
    //Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
     
   // system.debug('---------isInActiveTrigger----------------'+isInActiveTrigger);
    //  is trigger execute?
   // if(isInActiveTrigger == false){
        //declare map with Owners Lead which has to be updated the region field of User
        map<Id,list<Lead>> LeadswithOwnerId = new map<Id,list<Lead>>(); 
        // Here we preparing map of All Users whose profile is "System Administrator***"
	  //  map<ID, User> adminUserMap = new map<ID, User>([Select ID, Name from User where Profile.Name like :'System Administrator%' ]); 
        for(Lead Ld: Trigger.new){
            // check Owner Region Field is blank
            //if(Ld.Owner_Region__c == Null || Ld.Owner_Region__c == ''){
                if(Ld.IsConverted==false &&(trigger.isInsert || (trigger.isUpdate && Ld.OwnerId != trigger.oldMap.get(Ld.Id).OwnerId))){
               // 	system.debug('----------- we are here in loop');
               // 	system.debug('----------- Ld.OwnerId'+Ld.OwnerId);
	                if(LeadswithOwnerId.Containskey(Ld.OwnerId)){
	                    // put into maP
	                    LeadswithOwnerId.get(Ld.OwnerId).add(Ld);
	                }
	                else{
	                    // put into maP
	                    LeadswithOwnerId.put(Ld.OwnerId,new list <Lead>());
	                    LeadswithOwnerId.get(Ld.OwnerId).add(Ld);
	                }
                }
            //} 
        }
        if(LeadswithOwnerId.Size() > 0){
        	Boolean isInActiveTrigger = false;
		    // query form Custom setting
		    for(Trigger_Settings__c ts : [Select InactivateSetDefaultLeadRegionField__c From Trigger_Settings__c]){
		        // Set settting into veriable
		        isInActiveTrigger = ts.InactivateSetDefaultLeadRegionField__c;
		    }
		    if(isInActiveTrigger == false){
            // query user region field
	            map<Id,User> UserInfo  = new map<Id,User>([Select Id, Region__c,Channel__c,Manager.Name,Location__c From User 
	            where Id in: LeadswithOwnerId.keySet() and (not Profile.Name like:'System Administrator%')]);
	            set<Id> QueueSet=new set<Id>();
	            for(QueueSobject Queue:[Select SobjectType, QueueId From QueueSobject where 
	            QueueId in:LeadswithOwnerId.keySet() and SobjectType='Lead']) {
	            	QueueSet.add(Queue.QueueId);
	            }
	         //   system.debug('------------------ QueueSet'+QueueSet);
		        //    	system.debug('------------------ UserInfo'+UserInfo);
	            if((UserInfo != null && UserInfo.size()>0) || (QueueSet != null && QueueSet.size()>0)){
		            /*	system.debug('------------------ QueueSet'+QueueSet);
		            	system.debug('------------------ UserInfo'+UserInfo);
		            	system.debug('------------------ LeadswithOwnerId.keyset()'+LeadswithOwnerId.keyset());	   */         	
			            for(String Uid : LeadswithOwnerId.keyset()){
			                if(UserInfo.containsKey(Uid)){
			                    for(Lead Ld : LeadswithOwnerId.get(Uid)){
			                      //  system.debug('------------------ UserInfo.get(Uid).Region__c'+UserInfo.get(Uid).Region__c);                        
			                        Ld.Owner_Region__c = UserInfo.get(Uid).Region__c;                         
			                        Ld.Channel__c = UserInfo.get(Uid).Channel__c;
			                        Ld.Location__c =UserInfo.get(Uid).Location__c;
			                        Ld.Supervisor__c =UserInfo.get(Uid).Manager.Name; 
			                      //  system.debug('------------------ Ld'+Ld);
			                    }
			                }
			                if(QueueSet.contains(Uid)){
			                    for(Lead Ld : LeadswithOwnerId.get(Uid)){
			                        Ld.Owner_Region__c = 'Marketing Queue Lead';                        
			                        Ld.Channel__c = 'Marketing Queue Lead';
			                        Ld.Location__c = '';
			                        Ld.Supervisor__c ='' ;
			                     //   system.debug('------------------ Ld'+Ld);
			                    }
			                }
			            }
				}
            }           
        }
   // }
}