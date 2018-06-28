public class Rate 
{
    public String name{get;set;}
    public String id{get;set;}
    public Integer revenue{get;set;}
    public Integer margin{get;set;}
    
    /**
     * Constructor for class Rate. It tooks 4 parameters:
     * rate's name, ID, revenue and margin 
     */
    public Rate(String name, String id, Integer revenue, Integer margin)
    {
        this.name = name;
        this.id = id;
        this.revenue = revenue;
        this.margin = margin;
    }
}