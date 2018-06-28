public class PageReference_Cntrl {
    public List<SelectOption> options{get;set;}
    public PageReference_Cntrl ()
    {
        options=new List<SelectOption>();
    }
    public void PopulateData() {
        
    }
    public List<SelectOption> getAccList()
    {
        List<Account> accounts=[SELECT Id,Name FROM Account];
        for(Account acc:accounts)
        {
            options.Add(new SelectOption(acc.Id,acc.Name));
        }
        
        return options;
    }
    
    public List<Account> getAccountList()
    {
        List<Account> accounts=[SELECT Id,Name FROM Account];
        
        return accounts;
    }
    
    public void getPopulateData()
    {
        
    }
    public PageReference Random() {
        PageReference pg=new PageReference('/apex/Page2');
        return pg;
    }


}