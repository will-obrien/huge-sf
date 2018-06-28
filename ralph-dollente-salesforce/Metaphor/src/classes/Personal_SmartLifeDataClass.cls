public class Personal_SmartLifeDataClass{    
    public String expiration {get; set;}
    public Personal_BalanceClass balance {get; set;}

    public Personal_SmartLifeDataClass(String expiration, Personal_BalanceClass balance){
        this.expiration = expiration;
        this.balance = balance;        
    }    
}