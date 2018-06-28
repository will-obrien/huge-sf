public class PGIQuote{

    public string QuoteName {get; set;}
    public string QuoteId {get; set;}
    public string accountName {get;set;}
    public string contactName {get;set;}
    public string status {get;set;}
    public String createdBy{get; set;}
    public String quoteNumber{get; set;}
    public Date quoteExpiredDate{get; set;}
    public string opportunityCloseDate{get;set;}
    public decimal amount{get;set;}
    public decimal mrr{get;set;}
    public string Owner{get;set;}
    public string approvername{get;set;}
    public String opportunityType{get;set;}
    public PGIQuote(Quote Q){
        
        this.QuoteName=q.Name;
        this.QuoteId=q.Id;
        this.accountName=q.opportunity.account.name ;
      //this.accountName=q.account__r.name ;
        this.contactName=q.Contact.Name;
        this.status=q.Status;
        this.createdBy = q.CreatedById;
        this.quoteExpiredDate = q.ExpirationDate;
        this.opportunityCloseDate=Q.opportunity.CloseDate.format();
        this.amount=Q.opportunity.Amount__c;
        this.mrr=Q.opportunity.MRR_Total__c;
        this.owner=q.opportunity.owner.name;
        this.approvername=q.Approver_Name__r.name;
        this.opportunityType = q.Opportunity.Type;
}
}