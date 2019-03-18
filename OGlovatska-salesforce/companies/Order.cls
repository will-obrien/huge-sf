public class Order 
{
    public String orderName{get;set;}
    public String id{get;set;}
    public Company orderCompany{get;set;}
    
    /**
     * Constructor for class Order. It tooks 3 parameters:
     * order's name, ID and Company, which own this order
     */
    public Order(String orderName, String id, Company orderCompany)
    {
        this.orderName = orderName;
        this.id = id;
        this.orderCompany = orderCompany;
    }
}