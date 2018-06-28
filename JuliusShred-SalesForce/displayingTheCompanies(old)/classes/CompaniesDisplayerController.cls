/**
 * This code responds for generating the Company data than will be used in VF page
 * */
public class CompaniesDisplayerController
{
    private Company Microsoft;
    private Company Apple;
    private Order firstOrder;
    private Order secondOrder;
    private Rate normalRate;
    private Rate halfTimeRate;
    private WorkPeriod firstWP;
    private WorkPeriod secondWP;
    
    public List<companiesWrapper> comWrapperList {get; set;}

    public CompaniesDisplayerController() 
    {
        comWrapperList = createData();
    }
    /**
     * The method below serves for creating the data and putting it into our custom comWrapperList
	 **/
    private List<companiesWrapper> createData ()
    {
        Microsoft = new Company('Microsoft', '1micr');
        Apple = new Company('Apple', '1app');
        
        firstOrder = new Order('firstOrder', '1ord', Microsoft.ID);
        secondOrder = new Order('secondOrder', '2ord', Apple.ID);
        
        normalRate = new Rate('normalRate', '1rate', 400, 300);
        halfTimeRate = new Rate('halfTimeRate', '2rate', 200, 100);

        firstWP = new WorkPeriod('firstWP', '1WP', firstOrder.ID, normalRate.ID, Date.today(), Date.today().addDays(30));
        secondWP = new WorkPeriod('secondWP', '2WP', secondOrder.ID, halfTimeRate.ID, Date.today(), Date.today().addDays(70));
        
        List<companiesWrapper> comWrapperList = new List<companiesWrapper>();
        
        comWrapperList.add(new companiesWrapper('Name', Microsoft.Name, Apple.Name));
        comWrapperList.add(new companiesWrapper('Work Period', firstWP.Name, secondWP.Name));
        comWrapperList.add(new companiesWrapper('Revenue', string.valueof(normalRate.Revenue), string.valueof(halfTimeRate.Revenue)));
        comWrapperList.add(new companiesWrapper('Margin', string.valueof(normalRate.Margin), string.valueof(halfTimeRate.Margin)));
        
        return comWrapperList;   
    }
    /**
     * This snippet creates the wrapper class that serves for providing the custom type of companiesWrapper 
     * that contains info about our company
     **/ 
    public class companiesWrapper
    {
        public String rowDescription {get;set;}
        public String company1 {get;set;}
        public String company2 {get;set;}

        public companiesWrapper(String rowDescription, String company1, String company2)
        {
            this.rowDescription = rowDescription;
            this.company1 = company1;
            this.company2 = company2;
        }
    }     
}