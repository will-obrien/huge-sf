public class CompanyController 
{
    public Company firstCompany{get;set;}
    public Company secondCompany{get;set;}
    public Order firstOrder{get;set;}
    public Order secondOrder{get;set;}
    public Rate firstRate{get;set;}
    public Rate secondRate{get;set;}
    public WorkPeriod firstWorkPeriod{get;set;}
    public WorkPeriod secondWorkPeriod{get;set;}
    
    public List<companiesWrapper> displayList{get;set;}
    
    /**
     * Constructor for CompanyController in which asigne value
     * to the variable "displayList" using method data()
     */
    public CompanyController()
    {
        displayList = data();
    }
    
    /**
     * Method uses to create records for Companies, Orders,
     * Rates, Work periods and list of companiesWrapper
     */   
    public List<companiesWrapper> data()
    {
       	firstCompany = new Company('Fruit', '1');
        secondCompany = new Company('Vegetable', '2');
        
        firstOrder = new Order('first order', '1', firstCompany);
        secondOrder = new Order('second order', '1', secondCompany);
        
        firstRate = new Rate('First rate', '1', 200, 400);
        secondRate = new Rate('Second rate', '2', 500, 700);
        
        Date firstStart = Date.today();
        Date firstEnd = firstStart.addDays(300);
        
        Date secondStart = Date.today();
        Date secondEnd = secondStart.addDays(400);
        
        firstWorkPeriod = new WorkPeriod('Summer', '1', firstOrder, firstRate, firstStart, firstEnd);
        secondWorkPeriod = new WorkPeriod('Fall', '2', secondOrder, secondRAte, secondStart, secondEnd);
        
        List<companiesWrapper> companies = new list<companiesWrapper>();
        
        
        companies.add(new companiesWrapper('Name', firstCompany.name, secondCompany.name));
        companies.add(new companiesWrapper('Work period', firstWorkPeriod.name, secondWorkPeriod.name));
        companies.add(new companiesWrapper('Revenue', String.valueOf(firstRate.revenue), String.valueOf(secondRate.revenue)));
        companies.add(new companiesWrapper('Margin', String.valueOf(firstRate.margin), String.valueOf(secondRate.margin)));
        
        return companies;      
    }
    
 
 	/**
 	 * Wrapper class for companies to display data in Visualforce page
 	 */
    public class companiesWrapper{
        public String description{get;set;}
        public String firstCompany{get;set;}
        public String secondCompany{get;set;}
        
        public companiesWrapper(String description, String firstCompany, String secondCompany){
            this.description = description;
            this.firstCompany = firstCompany;
            this.secondCompany = secondCompany;
        }
    }    
}