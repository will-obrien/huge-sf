public class Page1_Cntrl {

    public void OnSelect() {
        Account acc=[Select Id,Name,AccountNumber,(Select Id,Name from Opportunities) from Account WHERE Name LIKE :'%'+SelectedName+'%'];
        SelectedId=acc.AccountNumber;
        if(acc.Opportunities.size()>0)
        {
            IsDataPresent=true;
        }
        else
        {
            IsDataPresent=false;
        }
        Opps=acc.Opportunities;
    }
    public String SelectedName{get;set;}
    public String SelectedId{get;set;}
    public List<SelectOption> accOptions{get;set;}
    public List<String> accNames{get;set;}
    public List<Opportunity> Opps{get;set;}
    public boolean IsDataPresent{get;set;}
    public Page1_Cntrl()
    {
        IsDataPresent=false;
        List<Account> accList=[SELECT Name FROM Account];
        accOptions=new List<SelectOption>();
        accNames=new List<String>();
        for(Account a:accList)
        {
            accNames.Add(a.Name);
            accOptions.Add(new SelectOption(a.Name,a.Name));
        }
    }
}