public class OdysseyLinkDetailClass{
    public String cilantro_id {get; set;}
    public List<String> accounts {get; set;}
    
    public OdysseyLinkDetailClass(String cilantroId, List<String> accounts){
        this.cilantro_id = cilantroId;
        this.accounts = accounts;    
    }
}