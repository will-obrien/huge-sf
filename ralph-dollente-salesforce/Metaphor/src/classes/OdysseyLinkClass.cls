public class OdysseyLinkClass{

    public String status {get; set;}
    public OdysseyLinkDetailClass accounts {get; set;}
        
    public OdysseyLinkClass(String status, OdysseyLinkDetailClass accounts){
        this.status = status;
        this.accounts = accounts;
    }

}