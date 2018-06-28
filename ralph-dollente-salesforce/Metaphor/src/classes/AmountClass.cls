public class AmountClass{    
    public String unit {get; set;}
    public String value {get; set;}
    public String display {get; set;}
    
    public AmountClass(String unit, String value, String display){
        this.unit = unit;
        this.value = value;
        this.display = display;     
    }    
}