public class Shared_UsageClass{    
    public String udate {get; set;}
    public String unit {get; set;}
    public String value {get; set;}
    public String display {get; set;}

    public Shared_UsageClass(String dtd, String unit, String value, String display){
        this.udate = dtd;
        this.unit = unit;
        this.value = value;
        this.display = display;        
    }    
}