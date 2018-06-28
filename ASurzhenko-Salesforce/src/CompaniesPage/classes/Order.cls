public class Order 
{
    public String id{get;set;}
    public String name{get;set;}
    public Account company{get;set;}
    
    public Order(String id, String name, Account company)
    {
        this.id = id;
        this.name = name;
        this.company = company;
    }
}