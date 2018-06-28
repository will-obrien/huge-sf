public class Order {
	
    public String Name {get; set;}
    public String ID {get; set;}
    public String CompanyID {get; set;}
    
    public Order(String Name, String ID, String CompanyID)
    {
        this.Name = Name;
        this.ID = ID;
        this.CompanyID = CompanyID;
    }
}