public class AccountObjectController 
{
	public Account firstCompany{get;set;}
    public Account secondCompany{get;set;}
    public Order__c firstOrder{get;set;}
    public Order__c secondOrder{get;set;}
    public Rate__c firstRate{get;set;}
    public Rate__c secondRate{get;set;}
    public Work_Period__c firstWorkPeriod{get;set;}
    public Work_Period__c secondWorkPeriod{get;set;}
    
    public List<AccountObjectWrapper> displayList{get;set;}
    
    /**
     * Constructor for AccountObjectController in which asigne value
     * to the variable "displayList" using method data()
     */
    public AccountObjectController(){
        displayList = data();
    }
    
    /**
     * Method uses to create records for Account, Order__c,
     * Rate__c, Work_period__c and list of AccountObjectWrapper
     */       
    public List<AccountObjectWrapper> data(){
        firstCompany = new Account(Name = 'Asus');
        secondCompany = new Account(Name = 'Samsung');
        
        firstOrder = new Order__c(Name = 'Manager');
        secondOrder = new Order__c(Name = 'Cheef manager');
        
        firstRate = new Rate__c(Name = 'Manager rate', Customer_rate__c = 500, Employer_rate__c = 1050);
        secondRate = new Rate__c(Name = 'Cheef manager rate', Customer_rate__c = 800, Employer_rate__c = 1200);
        
        Date firstStart = Date.today();
        Date firstEnd = firstStart.addDays(300);
        
        Date secondStart = Date.today();
        Date secondEnd = secondStart.addDays(400);
        
        firstWorkPeriod = new Work_Period__c(Name = 'Winter', Order__r = firstOrder, Rate__r = firstRate, 
                                             Start_date__c = firstStart, End_date__c = firstEnd);
        secondWorkPeriod = new Work_Period__c(Name = 'Fall', Order__r = secondOrder, Rate__r = secondRate, 
                                              Start_date__c = secondStart, End_date__c = secondEnd);
        
        List<AccountObjectWrapper> companies = new List<AccountObjectWrapper>();
        
        companies.add(new AccountObjectWrapper('Name', firstCompany.name, secondCompany.name));
        companies.add(new AccountObjectWrapper('Work period', firstWorkPeriod.name, secondWorkPeriod.name));
        companies.add(new AccountObjectWrapper('Customer rate', String.valueOf(firstRate.Customer_rate__c), String.valueOf(secondRate.Customer_rate__c)));
        companies.add(new AccountObjectWrapper('Employer rate', String.valueOf(firstRate.Employer_rate__c), String.valueOf(secondRate.Employer_rate__c)));
        
        return companies;      
    }   
    
    /**
 	 * Wrapper class for Accounts to display data in Visualforce page
 	 */
    public class AccountObjectWrapper
    {
       	public String description{get;set;}
        public String firstAccount{get;set;}
        public String secondAccount{get;set;}
        
        public AccountObjectWrapper(String description, String firstAccount, String secondAccount){
            this.description = description;
            this.firstAccount = firstAccount;
            this.secondAccount = secondAccount;
        } 
    }
}