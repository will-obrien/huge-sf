public class Company 
{
    public String name{get;set;}
    public String id{get;set;}
    
    /**
     * Constructor for class Company. It tooks 2 parameters:
     * Company's name and ID
     */
    public Company(String name, String id)
    {
        this.name = name;
        this.id = id;
    }
}