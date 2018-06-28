public class AccountClass 
{
    public List<AccountWrap> wrapList{get;set;}
    public String myResults{get;set;}
    
    /*
     * Method used to display choosen Accounts 
     */
    public void processAccounts()
    {
        myResults = 'Next Accounts were selected: ';
        for(AccountWrap wraps: wraplist){
            if(wraps.isSelected)
            {
                myResults += wraps.acc.Name + ', ';
            }
        }
    }
    
    /*
	 * Method used to fill wrapList with Accounts
	 */
    public AccountClass()
    {
        wrapList = new List<AccountWrap>();
        for(Account a: [SELECT Name FROM Account])
        {
            wrapList.add(new AccountWrap(a, false));
        }
    }
    
    /**
	 * Wrapper class. Constructor takes as parameters Account 
	 * and boolean value to check if Account was selected in checkbox
	 */
    public class AccountWrap
    {
        public Account acc{get;set;}
        public Boolean isSelected{get;set;}
        
        public AccountWrap(Account acc, Boolean isSelected)
        {
            this.acc= acc;
            this.isSelected = isSelected;
        }
        
    }

}