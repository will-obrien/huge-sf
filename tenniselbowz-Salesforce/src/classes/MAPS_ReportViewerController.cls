public without sharing class MAPS_ReportViewerController {
	
	public class mapContext
	{
		public string Id{get;set;}
		public string Name{get;set;}
		
		public mapContext(string i, string n)
		{
			Id = i;
			Name = n;
		}
	}
	
	public mapContext currentLevel{get;set;}
	public mapContext previousLevel{get;set;}
	public list<mapContext> childLevels{get;set;}
	public string reportDate{get;set;}
	map<String, Excluded_MAPS_Roles__c> exclusions;
	list<String> sortMap; 
	set<id> userRoleHierarchy = new set<id>();
	set<id> mapsRoleHierarchy = new set<id>();
	Profile currentProfile;
	
	public MAPS_ReportViewerController()
	{
		reportDate = System.today().addDays(-1).format();
		exclusions = Excluded_MAPS_Roles__c.getAll();
		sortMap = new list<string>();
		
		
		
		for(MAPS_LOB_Sort_Order__c ord : [Select Name, Sort_Order__c from MAPS_LOB_Sort_Order__c order by Sort_Order__c])
			sortMap.add(ord.Name);
			
		currentProfile = [Select Id, Name from Profile where Id = :UserInfo.getProfileId()];
		
		//=====================================================
		//determine the starting point for accessing the report
		currentLevel = new mapContext(null, null);
		previousLevel = new mapContext(null, null);
		childLevels = new list<mapContext>();
		for(UserRole r : [Select Id, Name 
		                    from UserRole 
		                   where Id = :UserInfo.getUserRoleId() 
		                     and name not in :exclusions.keySet()])
		   currentLevel = new mapContext(r.Id, r.Name);
		   
		//get the role hierarchy for the current user
		userRoleHierarchy = Batch_Maps_Helper.getAllSubRoleIds(new set<Id>{UserInfo.getUserRoleId()});
		userRoleHierarchy.add(UserInfo.getUserRoleId());
		
		//get the role hierarchy for the MAPS record context
		UserRole serviceRole = [Select Id, Name from UserRole where Name = 'Service'];
		mapsRoleHierarchy = Batch_Maps_Helper.getAllSubRoleIds(new set<Id>{serviceRole.Id});
		mapsRoleHierarchy.add(serviceRole.Id);
		
		if(!mapsRoleHierarchy.contains(currentLevel.Id) && !userRoleHierarchy.contains(serviceRole.Id))
		{
			//limit this report to the user level
			for(User u : [select Id, Name from User where Id = :UserInfo.getUserId()])
			   currentLevel = new mapContext(u.Id, u.Name);
		}
		
		if(userRoleHierarchy.contains(serviceRole.Id) || currentProfile.Name == 'System Administrator')
		{
			//start at the top if the current user is an admin or exists above the service role
		   	currentLevel = new mapContext(serviceRole.Id, serviceRole.Name);
		}
		
			
	    for(UserRole r : [Select Id, Name 
	                        from UserRole 
	                       where ParentRoleId = :currentLevel.Id 
	                         and name not in :exclusions.keySet()
	                        order by name])
	    {
	    	childLevels.add(new mapContext(r.Id, r.Name));
	    }
	    	
	    if(childLevels.size() == 0)
	    {
	    	apexPages.currentPage().getParameters().put('selectedlevel', currentLevel.Id);
	    	refreshMenu();
	    }
	    	
	    
	    
	}
	
	//===============================
	//Report Detail
	public list<MAPS_Reporting__c> getReport()
	{
		list<MAPS_Reporting__c> reportList = new list<MAPS_Reporting__c>();
		list<MAPS_Reporting__c> sortedReportList = new list<MAPS_Reporting__c>();
		
		for(MAPS_Reporting__c r : [Select m.Summary_Type__c
										, m.Summary_Type_Id__c
										, m.Summary_Parent_Name__c
										, m.Summary_Parent_Id__c
										, m.Summary_Name__c
										, m.Summary_Level__c
										, m.Strategic_Accounts_Current_Number__c
										, m.Quota_Current_FY__c
										, m.Quarter_Ending__c
										, m.Pipeline_v_Quota_Rolling_12_Months__c
										, m.Pipeline_Rolling_90_Days__c
										, m.Pipeline_Rolling_12_Months__c
										, m.Month_Ending__c
										, m.Major_Projects_Rolling_90_Days__c
										, m.Major_Projects_Rolling_12_Months__c
										, m.Factored_Pipeline_v_Quota_Rolling_12M__c
										, m.Factored_Pipeline_Rolling_90_Days__c
										, m.Factored_Pipeline_Rolling_12_Months__c
										, m.Date_Ending__c
										, m.Closed_Won_v_Quota_YTD__c
										, m.Closed_Won_v_Quota_MTD__c
										, m.Closed_Won_YTD__c
										, m.Closed_Won_MTD__c 
										, m.Pipeline_v_Quota_Rolling_90_Days__c
										, m.Factored_Pipeline_v_Quota_Rolling_90D__c
		          					 From MAPS_Reporting__c m
		          					where Summary_Type_Id__c = :currentLevel.Id
		          					  and Date_Ending__c = :System.today().addDays(-1)
		          					order by Summary_Level__c])
		{
			reportList.add(r);
		}
		
		for(String s : sortMap)
		{
			for(MAPS_Reporting__c r: reportList)
				if(s == r.Summary_Level__c)
					sortedReportList.add(r);
		}
			
		return sortedReportList;
		
	}
	
	public PageReference refreshMenu()
	{
		
		string newRoleId = apexPages.currentPage().getParameters().get('selectedlevel');
		
		if(newRoleid.startsWith('005'))//this is a user
		{
			for(User r : [Select Id, Name, UserRole.Name, UserRoleId, UserRole.ParentRoleId 
			                from User 
			               where Id = :newRoleId])
			{
		   		currentLevel = new mapContext(r.Id, r.Name);
		   		
		   		previousLevel = new mapContext(r.UserRoleId, r.UserRole.Name);
		   		
		   		if(exclusions.containsKey(previousLevel.Name))
		   		{
		   		 	for(UserRole ur : [Select Id, Name from UserRole where Id = :r.UserRole.ParentRoleId])
						previousLevel = new mapContext(ur.Id, ur.Name);
		   		}	
		   		
			}
		   		
		   	
		}
		else
		{
			String parentRoleId = '';
			for(UserRole r : [Select Id, Name, ParentRoleId from UserRole where Id = :newRoleId])
			{
			   currentLevel = new mapContext(r.Id, r.Name);
			   parentRoleId = r.parentRoleId;
			}
			if(currentLevel.name == 'Service')  
				previousLevel = new mapContext(null, null); 
			else
				for(UserRole r : [Select Id, Name, ParentRoleId from UserRole where Id = :parentRoleId])
				   previousLevel = new mapContext(r.Id, r.Name);
		}
		   
		childLevels.clear();
		for(UserRole r : [Select Id, Name 
		                    from UserRole 
		                   where ParentRoleId = :newRoleId  
		                     and name not in :exclusions.keySet()
		                   order by name])
	    	childLevels.add(new mapContext(r.Id, r.Name));
		
		
		
		if(childLevels.size() == 0 )
		{
			set<Id> roleIds = Batch_Maps_Helper.getAllSubRoleIds(new set<Id>{newRoleId});
			
			if(roleIds.size() >0)
        		roleIds.add(newRoleId);
        		
			for(User r : [Select Id, Name 
		                    from User 
		                   where UserRoleId in :roleIds 
		                     and Exclude_User_for_Quota_Planning__c = false 
		                   order by name])
	    	childLevels.add(new mapContext(r.Id, r.Name));
		}
		
		if(!isRoleReachable(previousLevel.Id))
		{
		  previousLevel.Id = null; 
		  previousLevel.name = null;
		}
		
		return null;
	}
	
	public boolean isRoleReachable(Id RoleId)
	{
		if(userRoleHierarchy.contains(roleId) && userRoleHierarchy.size() > 1 )
		   return true;
		
		if(currentProfile.Name == 'System Administrator')
			return true;
			
	    return false;
	
	}
	
	static testMethod void testThisClass()
	{
		MAPS_ReportViewerController ctl = new MAPS_ReportViewerController();
		ApexPages.currentPage().getParameters().put('selectedlevel', UserInfo.getUserId());
		ctl.getReport();
		ctl.refreshMenu();
		ctl.isRoleReachable(UserInfo.getUserRoleId());
		
	}
	
	
}