public class OpenDataClass{
    public String value {get; set;}
    public String unit {get; set;}
    public String display {get; set;}
        
    public OpenDataClass(String v, String u, String d){
        this.value = v;
        this.unit = u;
        this.display = d;
    }
}