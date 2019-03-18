public class Rate 
{
	public String Name {get; set;}
    public String ID {get; set;}
    public Integer Revenue {get; set;}
    public Integer Margin {get; set;}
    
    public Rate (String Name, String ID, Integer Revenue, Integer Margin)
    {
        this.Name = Name;
        this.ID = ID;
        this.Revenue = Revenue;
        this.Margin = Margin;
    }
}