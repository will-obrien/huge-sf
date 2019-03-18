public class AccountController
{

    public String phone { get; set; }

    public String name { get; set; }

    public String site { get; set; }
    
    public String type { get; set; }
    
   
    
    public AccountController()
    {
        
        
    }
    
    
    List<Account> accounts;
    Account account;
    
    public PageReference createAccount()
    {
        PageReference pg;
        account = new Account();     
        account.Name=name;
        account.Site=site;
        account.Phone=phone;
        account.Type=type;
        insert account;
        pg=new PageReference('/apex/CreateAccount');
        pg.setRedirect(true);
        return pg;
        
    }
    
    public List<SelectOption> getCountriesOptions() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('','-None-'));
        countryOptions.add(new SelectOption('Prospect','Prospect'));
        countryOptions.add(new SelectOption('Customer - Direct','Customer - Direct'));
        countryOptions.add(new SelectOption('Customer - Channel','Customer - Channel'));
        countryOptions.add(new SelectOption('Channel Partner / Reseller','Channel Partner / Reseller'));
        countryOptions.add(new SelectOption('Installation Partner','Installation Partner'));
        countryOptions.add(new SelectOption('Technology Partner','Technology Partner'));
        countryOptions.add(new SelectOption('Other','Other'));
 	      return countryOptions;
    }
    
    
    
	public List<Account> getAccounts() 
    {
		
       	 accounts = [SELECT  Name,Site,Type,Phone  FROM Account order by CreatedDate desc limit 10];
       
    	return accounts;
    }
    
    


}