public with sharing class BrochureRequestController {
 public static List<Opportunity> TimelineData{get;set;}
    
    @AuraEnabled
    public static String GetHomepageData()
    {
        		TimelineData=new List<Opportunity>();
       				user gurs = [Select UserRoleId,Email,ForecastEnabled 
                    			 from user where id = :UserInfo.getUserId() LIMIT 1];
 				System.debug('------Logged In User Id is :'+gurs.UserRoleId);
				Set<Id> userIdSet = new Set<Id>();
				userIdSet.add(gurs.UserRoleId);
				Set<ID> finalUserIdSet = Utility.getAllSubRoleIds(userIdSet);
				System.debug('------Sub Users  ID is :'+finalUserIdSet);

				List<UserRole> urList = [Select Id, Name from UserRole where Id IN: finalUserIdSet];
        		
				System.debug('------urList Count is'+urList.size());
        		userIdSet.clear();
        		userIdSet.add(UserInfo.getUserId());
				for(UserRole ur: urList) 
                {
                    userIdSet.add(ur.Id);
    				System.debug('------ Sub User Role Name:'+ur.Name);
				} 
        List<Task> Tasklst=[SELECT WhatId,Type__c,subject, Status, Description,Program__C FROM Task where Type__c='Price Quote' or Type__c='Brochure Request'];
            
		if(Tasklst!=null && Tasklst.size()>0)
        	{
                finalUserIdSet.clear();
                for(Task tsk: Tasklst) 
                {
                    finalUserIdSet.add(tsk.WhatId);
    				//System.debug('------ Sub User Role Name:'+ur.Name);
				} 
                TimelineData=[SELECT Id, Name, StageName, Amount, Probability,
                      Type, OwnerId, Program__c, Letter_Template__c, Billing_Country__c,Owner.Name
                      FROM Opportunity where OwnerId IN: userIdSet and Id in:finalUserIdSet];
                    
        	}        
		
        return JSON.serialize(TimelineData);
    }
}