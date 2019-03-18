public class WorkPeriod 
{
    public String name{get;set;}
    public String id{get;set;}
    public Order order{get;set;}
    public Rate rate{get;set;}
    public Date startDate{get;set;}
    public Date endDate{get;set;}
    
     /**
     * Constructor for class WorkPeriod. It tooks 6 parameters:
     * rate's name, ID, Order, Rate on this order, end and start date of
     * this work period
     */
    public WorkPeriod(String name, String id, Order order, Rate rate, Date startDate, Date endDate)
    {
        this.name = name;
        this.id = id;
        this.order = order;
        this.rate = rate;
        this.startDate = startDate;
        this.endDate = endDate;
    }
}