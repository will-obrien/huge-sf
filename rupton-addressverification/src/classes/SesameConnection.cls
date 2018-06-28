public class SesameConnection{

    private static final String sConnectionString = 'https://saas.loqate.com/json/';
    private static final String connectionString = 'http://saas.loqate.com/json/';
    private String userKey;
    private Integer remainingTransactions;
    private LoqateLicense__c licenseInfo;
    
    public SesameConnection(){
     	licenseInfo = [Select l.User_Name__c, l.Remaining_Transactions__c, l.Name, l.License_Key__c, l.Expiry_Date__c From LoqateLicense__c l]; 
        userKey = licenseInfo.License_Key__c;
        remainingTransactions = licenseInfo.Remaining_Transactions__c.intValue();
    }
    
    public HttpRequest connect(String connectionUrl){
        if (remainingTransactions == 0){
            //throw an exception and return
        }
        return new HttpRequest();
            
    }
}