public class WorkPeriod 
{
	public String Name {get; set;}
    public String ID {get; set;}
	public Date startDate {get; set;}
    public Date endDate {get; set;}
    public String OrderID {get; set;}
    public String RateID {get; set;}

    public WorkPeriod(String Name, String ID, String OrderID, String RateID, Date startDate, Date endDate)
    {
        this.Name = Name;
        this.ID = ID;
        this.OrderID = OrderID;
        this.RateID = RateID;
        this.startDate = startDate;
        this.endDate = endDate;
    }
}