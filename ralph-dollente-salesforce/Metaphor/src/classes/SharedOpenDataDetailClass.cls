public class SharedOpenDataDetailClass{
    public String name {get; set;}
    public String expirationdate {get; set;}
    public String value {get; set;}
    public String unit {get; set;}
    public String display {get; set;}
  
    public SharedOpenDataDetailClass(String name, String expirationdate, String value, String unit, String display){                                      
        this.name = name;
        this.expirationdate = expirationdate;
        this.value = value;
        this.unit = unit;
        this.display = display;    
    }
}