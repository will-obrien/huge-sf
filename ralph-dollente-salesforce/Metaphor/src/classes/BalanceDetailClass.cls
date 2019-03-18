public class BalanceDetailClass{
    public DateTime transactionDate {get; set;}
    public String display {get; set;}
    public String membername {get; set;}
    public String unit {get; set;}
    public String value {get; set;}

    public BalanceDetailClass(DateTime transactionDate, String display, String membername, String unit, String value){
        this.transactionDate = transactionDate;
        this.display = display;
        this.memberName = membername;
        this.unit = unit;
        this.value = value;    
    }
}