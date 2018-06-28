public with sharing class UserNode 
{
	public User user {get;set;}
	public List<User> masters {get;set;}
	public List<User> otherSlavesUnderMaster {get;set;}
	public List<User> slaves {get;set;}
	public UserNode(User u)
	{
		user = u;
		masters = new List<User>();
		otherSlavesUnderMaster = new List<User>();
		slaves = new List<User>();
	}
	public UserNode(User u, User m)
	{
		user = u;
		masters = new List<User>();
		masters.add(m);
		otherSlavesUnderMaster = new List<User>();
		slaves = new List<User>();
	}

	public boolean addMaster(User u)
	{
		if(u == null)
			return false;
		else
		{
			masters.add(u);
			return true;
		}
	}
	public boolean addSlave(User u)
	{
		if(u == null)
			return false;
		else
		{
			slaves.add(u);
			return true;
		}
	}
	public boolean addOtherSlavesUnderMaster(User u)
	{
		if(u == null)
			return false;
		else
		{
			otherSlavesUnderMaster.add(u);
			return true;
		}
	}
}