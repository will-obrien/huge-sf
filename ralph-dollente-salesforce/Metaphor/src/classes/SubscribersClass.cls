public class SubscribersClass{    
    public String role {get; set;}
    public String msisdn {get; set;}
    public Shared_UsageClass usage {get; set;}

    public SubscribersClass(String role, String msisdn, Shared_UsageClass usage){
        this.role = role;
        this.msisdn = msisdn;
        this.usage = usage;        
    }        
}