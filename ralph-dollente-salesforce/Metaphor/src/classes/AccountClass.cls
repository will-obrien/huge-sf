public class AccountClass{
    public String id {get; set;}
    public ProfileClass profile {get; set;}
    public BalanceClass balance {get; set;}    
    public ErrorClass error {get; set;}
    public List<MemberClass> members {get; set;}
            
    public AccountClass(String id, ProfileClass p, BalanceClass b, ErrorClass err, List<MemberClass> members){
        this.id = id;
        this.profile = p;
        this.balance = b;
        this.error = err;       
        this.members = members;
    }
    
}