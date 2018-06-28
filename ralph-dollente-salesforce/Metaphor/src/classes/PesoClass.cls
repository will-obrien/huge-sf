public class PesoClass{
    public String value {get; set;}
    public String unit {get; set;}
    public String display {get; set;}
        
    public PesoClass(String v, String u, String d){
        this.value = v;
        this.unit = u;
        this.display = d;
    }
}