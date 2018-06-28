public class Personal_OpenDataClass{    
    public String expiration {get; set;}
    public Personal_BalanceClass balance {get; set;}
    public Personal_OpenDataClass(String expiration, Personal_BalanceClass balance){
        this.expiration = expiration;
        this.balance = balance;        
    }    
}