public with sharing class TopupClass{
    public String type {get; set;}
    public String msisdn {get; set;}
    public String checkout_id {get; set;}
    public AmountClass amount {get; set;}
    public ValidityClass validity {get; set;}

    public TopupClass(String t, String m, String c){
        this.type = t;
        this.msisdn = m;
        this.checkout_id = c;    
    }

    public class AmountClass{    
        public String value {get; set;}
        public String unit {get; set;}        
        public AmountClass(String v, String u){
            this.value = v;
            this.unit = u;
        }       
    }
    
    public class ValidityClass{    
        public String value {get; set;}
        public String unit {get; set;}    
        public ValidityClass(String v, String u){
            this.value = v;
            this.unit = u;
        }        
    }
}