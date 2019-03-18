public class DetailClass{
    public String validity {get; set;}
    public String resource_id {get; set;}
    public BalanceClass balance {get; set;}

    public DetailClass(String v, String r, BalanceClass b){
        this.validity = v;
        this.resource_id = r;
        this.balance = b;
    }
    
    public class BalanceClass{
        
        public String unit {get; set;}
        public String value {get; set;}
    
        public BalanceClass(String unit, String value){
            this.unit = unit;
            this.value = value;
        }
    }
}