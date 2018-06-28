public class Shared_BalanceClass{        
    public String udate {get; set;}
    public String unit {get; set;}
    public String value {get; set;}
    public String display {get; set;}
    public String expiration {get; set;}
    
    public Shared_BalanceClass(String dtd, String unit, String value, String display, String expiration){
        this.udate = dtd;
        this.unit = unit;
        this.value = value;
        this.display = display;
        this.expiration = expiration;        
    }    
}