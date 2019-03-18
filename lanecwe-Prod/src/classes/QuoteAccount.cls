public class QuoteAccount{

    public string quoteId {get; set;}
    public string quoteName {get; set;}
    public string quoteStatus {get; set;}
    public string accountName {get; set;}
    public string salesRepName {get; set;}
    public string Email {get; set;}
    public string phoneNumber {get; set;}
    public string clientContact {get; set;}
    public string accountId {get; set;}
    public string quoteContact{get;set;}
    public double totalAnnualvalue{get;set;}
    public double totalContractValue{get;set;}
    public double totalMRR{get;set;}
    public double totalPrice {get;set;}
    public double totalMargin {get;set;}
    public String quoteCurrency {get;set;}
    public string territoryCode {get;set;}
    public string dealType {get;set;}
    public boolean isRFP{get;set;}
    
    
    public QuoteAccount(){
    }
    public QuoteAccount(Quote objQuote, Opportunity objAccount){
        this.quoteId= objQuote.QuoteNumber;
        this.quoteName = objQuote.Name;
        this.quoteStatus = objQuote.Status;
        this.accountName = objAccount.Account.Name;  
       this.quoteContact  = objQuote.Contact.Name;
        //this.quoteContact  = objQuote.Signer_Contact_Name__r.Name;
       //this.quoteContact  = objQuote.Signer_Contact_Name__c;
        this.phoneNumber = objAccount.Account.phone;
        this.accountId = objAccount.AccountId;
        this.Email=objQuote.Email;
        //this.salesRepName = userinfo.getName();
        this.salesRepName = objQuote.Quote_Owner__c;
        this.totalAnnualvalue=objQuote.Total_Annual_value__c;
        this.totalContractValue=objQuote.Total_Contract_Value__c;
        this.totalMRR=objQuote.Total_MRR__c;
        this.totalPrice=objQuote.TotalPrice__c;
        this.totalMargin=objQuote.Total_Margin__c;
        this.quoteCurrency=objQuote.Quote_Currency__c;
        this.territoryCode=objQuote.Sales_Rep_Id__c;
        this.dealType=objQuote.opportunity.type;
        this.isRFP=objAccount.Is_RFP__c;
        
    }

}