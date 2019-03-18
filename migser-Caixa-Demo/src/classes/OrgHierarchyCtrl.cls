public with sharing class OrgHierarchyCtrl 
{
	public String currentFocusUserId {get;set;}
	public Integer masterCount {get;set;}
	public Integer slaveCount {get;set;}
	public UserNode me {get;set;} //current focus user
	public OrgHierarchyCtrl() 
	{
		currentFocusUserId = ApexPages.currentPage().getParameters().get('sfdc.userId');
		if(currentFocusUserId == null || currentFocusUserId == '')
			currentFocusUserId = UserInfo.getUserId();
		setFocusUser();

	}
	public void setFocusUser()
	{
		User u = [SELECT Id, Name, FirstName, LastName, UserRoleId, UserRole.Name, ProfileId, ManagerId, Manager.Name, FullPhotoUrl, SmallPhotoUrl
				  FROM User 
				  WHERE Id = :currentFocusUserId Limit 1];
		me = new UserNode(u);

		setMasters();
		setOtherSlavesUnderMaster();
		setSlaves();

	}
	public void setMasters()
	{
		if(me.user.ManagerId != null)
		{
			List<User> uMasters = [SELECT Id, Name, FirstName, LastName, UserRoleId, UserRole.Name, ProfileId, ManagerId, Manager.Name, FullPhotoUrl, SmallPhotoUrl
							FROM User 
							WHERE Id = :me.user.ManagerId
							ORDER BY Name ASC];
			System.debug(uMasters);
			for(User m : uMasters)
				me.addMaster(m);
		}
		//get the count of masters so we know if we should render empty div or not
		masterCount = me.masters.size();
	}
	public void setOtherSlavesUnderMaster()
	{
		if(me.user.ManagerId != null)
		{
			List<User> urFellowSlaves = [SELECT Id, Name, FirstName, LastName, UserRoleId, UserRole.Name, ProfileId, ManagerId, Manager.Name, FullPhotoUrl, SmallPhotoUrl
							FROM User 
							WHERE ManagerId = :me.user.ManagerId
							AND id != :me.User.Id
							ORDER BY Name ASC];
			for(User s : urFellowSlaves)
				me.addOtherSlavesUnderMaster(s);
		}
	}
	public void setSlaves()
	{
		List<User> uSlaves = [SELECT Id, Name, FirstName, LastName, UserRoleId, UserRole.Name, ProfileId, ManagerId, Manager.Name, FullPhotoUrl, SmallPhotoUrl
						FROM User 
						WHERE ManagerId = :me.user.Id
						ORDER BY Name ASC];
		for(User s : uSlaves)
			me.addSlave(s);
		slaveCount = me.slaves.size();
	}
}