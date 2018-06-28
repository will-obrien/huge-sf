public class Rate 
{
    public String id{get;set;}
    public String name{get;set;}
    public Integer revenue{get;set;}
    public Integer margin{get;set;}
    
    public Rate(String id, String name, Integer revenue, Integer margin)
    {
        this.id = id;
        this.name = name;
        this.revenue = revenue;
        this.margin = margin;
    }
}