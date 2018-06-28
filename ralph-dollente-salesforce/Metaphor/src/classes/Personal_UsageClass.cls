public class Personal_UsageClass{    
    public String value {get; set;}
    public String unit {get; set;}
    public String display {get; set;}

    public Personal_UsageClass(String value, String unit, String display){
        this.value = value;
        this.unit = unit;
        this.display= display;        
    }
}