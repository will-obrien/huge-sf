public class SharedSmartLifeDataSummaryClass{
    public String balanceDate {get; set;}
    public String balanceDisplay {get; set;}
    public String balanceExpiration {get; set;}
    public String balanceUnit {get; set;}
    public String balanceValue {get; set;}    
    public String totalDate {get; set;}    
    public String totalDisplay {get; set;}
    public String totalExpiration {get; set;}
    public String totalUnit {get; set;}
    public String totalValue {get; set;}
    
    public SharedSmartLifeDataSummaryClass(String balanceDate, String balanceDisplay, String balanceExpiration, String balanceUnit, String balanceValue,
                                      String totalDate, String totalDisplay, String totalExpiration, String totalUnit, String totalValue){                                      
        this.balanceDate = balanceDate;
        this.balanceDisplay = balanceDisplay;
        this.balanceExpiration = balanceExpiration;
        this.balanceUnit = balanceUnit;
        this.balanceValue = balanceValue;    
        this.totalDate = totalDate;
        this.totalDisplay = totalDisplay;
        this.totalExpiration = totalExpiration;
        this.totalUnit = totalUnit;
        this.totalValue = totalValue;                                           
    }
}