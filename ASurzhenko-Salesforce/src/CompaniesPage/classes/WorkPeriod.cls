public class WorkPeriod 
{
    public String id{get;set;}
    public String name{get;set;}
    public Order__c order{get;set;}
    public Rate__c rate{get;set;}
    public Date startDate{get;set;}
    public Date endDate{get;set;}
    
    public WorkPeriod(String id, String name, Order__c order, Rate__c rate, Date startDate, Date endDate)
    {
        this.id = id;
        this.name = name;
        this.order = order;
        this.rate = rate;
        this.startDate = startDate;
        this.endDate = endDate;
    }
}