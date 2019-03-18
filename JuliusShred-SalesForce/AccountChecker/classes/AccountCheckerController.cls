/**
* AccountCheckerController used to process the data from AccountCheckerPage and return the accounts that were selected
*/
public class AccountCheckerController
{  
    public List<AccountWrapper> accountsList{get; set;}  
    public List<Account> checkedAccs {get; set;}
   	
    public AccountCheckerController()
    {  
        accountsList = getData();  
    }  
    //getCheckedRecords() fills the checkedAccs list with accounts that we've selected on VF page 
    public void getCheckedRecords()
    {  
        checkedAccs = new List<Account>();  
        for(AccountWrapper acc : accountsList)
        {  
            if(acc.isSelected)
            {  
                checkedAccs.add(acc.myAccount);  
            }  
        }  
        accountsList = getData(); 
    }  
    //this method gets the data from the accounts and fills the accountsList with unselected accounts
    public List<AccountWrapper> getData()
    {  
        List<Account> accList = [SELECT Name,Id,Phone, Description FROM Account];        
        List<AccountWrapper> accountsList = new List<AccountWrapper>();  
        for(Account acc : accList)
        {  
            accountsList.add(new AccountWrapper(acc,false));  
        }  
        return accountsList;  
    }  
    /**
    * AccountWrapper inner class serves for wrapping the accounts
    * it assigns the isSelected value to account providing the selection from the controller 
    */
    public class AccountWrapper
    {  
        public boolean isSelected {get; set;}  
        public Account myAccount {get; set;}  
    
        public AccountWrapper(Account myAccount,Boolean isSelected)
        {  
            this.myAccount = myAccount;  
            this.isSelected = isSelected;  
        }  
    }  
}