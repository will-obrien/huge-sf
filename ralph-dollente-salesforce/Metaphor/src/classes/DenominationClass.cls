public class DenominationClass{    
    public String id {get; set;}
    public String type {get; set;}
    public AmountClass amount {get; set;}
    
    public DenominationClass(String id, String type, AmountClass amount){
        this.id = id;
        this.type = type;
        this.amount = amount;           
    }
}