public class Milestone1_Task_Trigger_Utility {
    
    public static void handleTaskAfterTrigger(List<Milestone1_Task__c> recs, List<Milestone1_Task__c> oldRecs) {
        Milestone1_Task__c oldRec;
        //Place all the RecIds into a List for SOQL in Clause on Subscription Query
        List<String> recIds = new List<String>();
        for(Milestone1_Task__c rec : recs) { recIds.add(rec.Id); }
        
        //Retrieve existing list of Subscriptions for the Task(s) and store in Map by User. Salesforce does not allow user to subscribe to same object more than once so we can store in map.
        List<EntitySubscription> existingSubscriptions = [Select Id, ParentId, SubscriberId from EntitySubscription where ParentId in :recIds];
         
        //Create a Map of Users to Subscriptions
        Map<String,List<EntitySubscription>> userSubscriptionMap = Milestone1_Task_Trigger_Utility.buildUserSubscriptionMap(existingSubscriptions);

        List<EntitySubscription> subscriptionsAddList = new List<EntitySubscription>();
        List<EntitySubscription> subscriptionsDeleteList = new List<EntitySubscription>();
        
        //Iterate over the list of Tasks and evaluate the Chatter rules to follow/unfollow based on Custom Settings for Users/Profiles
        Integer i = 0;
        for(Milestone1_Task__c rec : recs)
        {
        	oldRec = null;
            //Retrieve the old record which matches current record
            if(oldRecs != null && oldRecs.size() > i){
            	oldRec = oldRecs.get(i);
            }
            //If the Task is Assigned to a User then we can proceed
            if(rec.Assigned_To__c != null)
            {
                List<EntitySubscription> existingSubscriptionList = userSubscriptionMap.get(rec.Assigned_To__c);
                EntitySubscription existingSubscription = getSubscriptionForUserAndRec(rec,existingSubscriptionList,userSubscriptionMap);
                
                AutoChatterSetting chatterSettings = new AutoChatterSetting(rec.Assigned_To__c, rec.Assigned_To__r.ProfileId);
                //If the custom setting for automatically following is true, lets perform auto chatter logic
                if(chatterSettings.autoFollow)
                {
                    //If the there is not an existing subscription for the user, go ahead and follow the object. This prevents DUPLICATE_VALUE exception on subscription insert.
                    if(existingSubscription == null)
                    {
                        EntitySubscription subscription = new EntitySubscription(parentId=rec.id, SubscriberId=rec.Assigned_To__c);
                        subscriptionsAddList.add(subscription);
                    }
                }
                //If the custom setting for automatically unfollowing is true, let perform auto chatter logic to unfollow for the user.
                if(chatterSettings.autoCompleteFollow && rec.Complete__c && existingSubscription != null)
                {
                    subscriptionsDeleteList.add(existingSubscription);
                }
            }
            //Lets remove the previous Assigned To Follower if oldRec exists, and if the Assignment changed to another user.
            if(oldRec != null && oldRec.Assigned_To__c != null && oldRec.Assigned_To__c != rec.Assigned_To__c)
            {
                system.debug('Unfollow..');
                AutoChatterSetting chatterSettings = new AutoChatterSetting(oldRec.Assigned_To__c, oldRec.Assigned_To__r.ProfileId);
                List<EntitySubscription> existingSubscriptionList = userSubscriptionMap.get(oldRec.Assigned_To__c);
                EntitySubscription existingSubscription = getSubscriptionForUserAndRec(oldRec,existingSubscriptionList,userSubscriptionMap);
                if(chatterSettings.autoUnassignFollow && existingSubscription != null)
                {
                    subscriptionsDeleteList.add(existingSubscription);
                }
            }
            i++;
        }
        //Perform Inserts and Deletes of Subscriptions
        insert subscriptionsAddList;
        delete subscriptionsDeleteList;
    }
    
    public static EntitySubscription getSubscriptionForUserAndRec(Milestone1_Task__c rec, List<EntitySubscription> existingSubscriptionList, Map<String,List<EntitySubscription>> userSubscriptionMap)
    {
        EntitySubscription existingSubscription = null;
        if(userSubscriptionMap.get(rec.Assigned_To__c) != null)
        {   
            for(EntitySubscription tempSubscription : existingSubscriptionList)
            {
                if(tempSubscription.SubscriberId == rec.Assigned_To__c && tempSubscription.ParentId == rec.Id)
                {
                    existingSubscription = tempSubscription;
                    break;
                }
            }
        }
        return existingSubscription;
    }
    
    public static Map<String,List<EntitySubscription>> buildUserSubscriptionMap(List<EntitySubscription> existingSubscriptions)
    {
        Map<String,List<EntitySubscription>> userSubscriptionMap = new Map<String,List<EntitySubscription>>();
        for(EntitySubscription aSubscription : existingSubscriptions)
        {
            if(userSubscriptionMap.get(aSubscription.SubscriberId) == null)
            {
                userSubscriptionMap.put(aSubscription.SubscriberId,new List<EntitySubscription>());
                
            }
            List<EntitySubscription> tempList = userSubscriptionMap.get(aSubscription.SubscriberId);
            tempList.add(aSubscription);
            userSubscriptionMap.put(aSubscription.SubscriberId,tempList);
        }
        return userSubscriptionMap;
    }

    public static void handleTaskBeforeTrigger(List<Milestone1_Task__c> recs){
        Map<String,Milestone1_Milestone__c> taskMilestoneMap = Milestone1_Task_Trigger_Utility.retrieveParentMilestones(recs);
        
        for( Milestone1_Task__c rec : recs ){
            if( rec.Index_Helper__c.length() > 255 ){ rec.Index__c = rec.Index_Helper__c.substring(0, 255); } 
            else { rec.Index__c = rec.Index_Helper__c; }
            
            if( rec.Due_Date__c == null ) {
                Milestone1_Milestone__c parentMilestone = taskMilestoneMap.get(rec.Project_Milestone__c);
                if(parentMilestone != null) { rec.Due_Date__c = parentMilestone.Deadline__c; }
            }
            if(rec.Start_Date__c == null)
            {
                Milestone1_Milestone__c parentMilestone = taskMilestoneMap.get(rec.Project_Milestone__c);
                if(parentMilestone != null)
                {
                    rec.Start_Date__c = parentMilestone.KickOff__c;
                    
                }
                if (rec.Start_Date__c == null || rec.Start_Date__c < Date.TODAY()) {
                	rec.Start_Date__c = Date.Today();
                }
                
            }


	      if(rec.Assigned_To__c == null)
	      {
	        rec.Assigned_To__c = UserInfo.getUserId();
	      }            
            if (rec.Complete__c == false && rec.Days_Late_Formula__c > 0) {
                rec.Days_Late__c = rec.Days_Late_Formula__c;
            } else {
                rec.Days_Late__c = 0; 
            }
            
        }
    }
    
    public static Map<String,Milestone1_Milestone__c> retrieveParentMilestones(List<Milestone1_Task__c> recs)
    {
        Set<String> ids = new Set<String>();
        for(Milestone1_Task__c rec : recs) { ids.add(rec.Project_Milestone__c); }
        List<Milestone1_Milestone__c> parentMilestones = [Select Id, Name, Deadline__c, KickOff__c from Milestone1_Milestone__c where Id in :ids];
        
        Map<String,Milestone1_Milestone__c> taskMilestoneMap = new Map<String,Milestone1_Milestone__c>();
        for( Milestone1_Milestone__c parentMilestone : parentMilestones ) {
            taskMilestoneMap.put(parentMilestone.ID,parentMilestone);
        }

        return taskMilestoneMap;
    }
    
    private class AutoChatterSetting
    {
        public Boolean autoFollow = false;
        public Boolean autoCompleteFollow = false;
        public Boolean autoUnassignFollow = false;
        
        public autoChatterSetting(String userid, String profileId)
        {   
            Milestone1_Settings__c orgChatterDefaults = Milestone1_Settings__c.getOrgDefaults();        
            Milestone1_Settings__c profileChatter = Milestone1_Settings__c.getInstance(userid);
            Milestone1_Settings__c userChatter = Milestone1_Settings__c.getInstance(profileid);
            
            //If the User has a custom Chatter setting, use this setting else use a profile setting if available
            if(userChatter != null)
            {
                autoFollow = userChatter.Auto_Follow_Task__c;
                autoCompleteFollow = userChatter.Auto_Follow_Complete_Task__c;
                autoUnassignFollow = userChatter.Auto_Unfollow_Reassignment__c;
            }else if(profileChatter != null)
            {
                autoFollow = profileChatter.Auto_Follow_Task__c;
                autoCompleteFollow = profileChatter.Auto_Follow_Complete_Task__c;
                autoUnassignFollow = profileChatter.Auto_Unfollow_Reassignment__c;
            }else if(orgChatterDefaults != null)
            {
                autoFollow = orgChatterDefaults.Auto_Follow_Task__c;
                autoCompleteFollow = orgChatterDefaults.Auto_Follow_Complete_Task__c;
                autoUnassignFollow = orgChatterDefaults.Auto_Unfollow_Reassignment__c;  
            }
        }
    }

}