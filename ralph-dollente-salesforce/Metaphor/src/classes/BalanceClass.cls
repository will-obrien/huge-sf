public class BalanceClass{
    public PesoClass peso {get; set;}
    public OpenDataClass open_data {get; set;}   
    public SmartLifeDataClass smart_life_data {get; set;}
    public ErrorClass error {get; set;}
   
    public BalanceClass(PesoClass p, OpenDataClass o, SmartLifeDataClass s, ErrorClass e){
        this.peso = p;   
        this.open_data = o;       
        this.smart_life_data = s;
        this.error = e;
    }
}