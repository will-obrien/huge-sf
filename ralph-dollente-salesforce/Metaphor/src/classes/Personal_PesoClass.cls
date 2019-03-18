public class Personal_PesoClass{        
    public String expiration {get; set;}
    public Personal_BalanceClass balance {get; set;}

    public Personal_PesoClass(String expiration, Personal_BalanceClass balance){        
        this.expiration = expiration;
        this.balance = balance;
    }
}