public class Personal_BoosterClass{    
    public String name {get; set;}
    public String image_url {get; set;}
    public String expiration {get; set;}
    public Personal_BalanceClass balance {get; set;}

    public Personal_BoosterClass(String name, String url, String expiration, Personal_BalanceClass balance){
        this.name = name;
        this.image_url = url;
        this.expiration = expiration;
        this.balance = balance;        
    }       
}