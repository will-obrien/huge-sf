public class PageBlockTableEnhancerDemo_Con {
    public String targetField { get; set; }
    /*
    *Return list of records to be displayed(can be any sobject)
    **/
    public List<Account> getAccounts(){
        return [SELECT Name,AccountNumber,Type,Phone,Rating FROM Account];
    }
    
   
}