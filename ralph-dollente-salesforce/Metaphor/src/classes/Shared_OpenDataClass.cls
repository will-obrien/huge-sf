public class Shared_OpenDataClass{        
    public List<SubscribersClass> subscribers {get; set;}        
    public TotalClass total {get; set;}
    public Shared_BalanceClass balance {get; set;}
    
    public Shared_OpenDataClass(List<SubscribersClass> subscribers, TotalClass total, Shared_BalanceClass balance){
        this.subscribers = subscribers;
        this.total = total;
        this.balance = balance;        
    }    
}