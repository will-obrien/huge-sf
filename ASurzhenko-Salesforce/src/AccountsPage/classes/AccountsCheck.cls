public with sharing class AccountsCheck 
{
	public List<wrap> wrappList{get;set;}
	public List<wrap> toProcess{get;set;}
	public String result{get;set;}

	public void wrapping()
    {
    	/**
    	*This Integer will help to avoid comma after the last account in the result String
    	*/
    	Integer i = 0;
    	toProcess = new List<wrap>();
        result = 'Accounts in process: ';
        for(wrap item:wrappList)
        {
            if(item.isSelected)
            {
            	toProcess.add(item);
            }
            if(toProcess.isEmpty())
			{
				result = 'No Account is in process!';
			}
        }

        for(wrap item:toProcess)
        {
        	i++;
        	/**
        	*we check if this is not the last account, we will print comma
        	*or if this is the last or the only account, we will print point
        	*/
			if(i != toProcess.size())
        	{
        		result += item.myAccount.Name+', ';
        	}
        	else 
        	{
        		result += item.myAccount.Name+'. ';
        	}
        }
    }

	public AccountsCheck() 
	{
		wrappList = new List<wrap>();
		for(Account item:[SELECT Name, Phone FROM Account])
		{
			wrap w = new wrap();
			w.isSelected = false;
			w.myAccount = item;
			wrappList.add(w);
		}
    }

    public class wrap{
        public boolean isSelected{get;set;}
        public Account myAccount{get;set;}
    }
}