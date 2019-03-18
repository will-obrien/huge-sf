public with sharing class LeadSourcePlaceHolder {
  
  public String leadSource {get;set;}
  public String leadSourceDetail {get;set;}
  public Date leadSourceDate {get;set;}
  public String offer {get;set;}
  public String offerType {get;set;}
  public String url {get;set;}
  
  public String previousLeadSource {get;set;}
  public String previousLeadSourceDetail {get;set;}
  public Date previousLeadSourceDate {get;set;}
  
  public LeadSourcePlaceHolder(){
    
  }
  
  public LeadSourcePlaceHolder(Lead lead){
    this.leadSource = lead.LeadSource;
    this.leadSourceDetail = lead.Lead_Source_Detail__c;
    this.leadSourceDate = lead.Lead_Source_Date__c;
    this.offer = lead.Offer__c;
    this.offerType = lead.Offer_Type__c;
    this.url = lead.URL__c;
    this.previousLeadSource = lead.Lead_Source_previous__c;
    this.previousLeadSourceDetail = lead.Lead_Source_Detail_previous__c;
    this.previousLeadSourceDate = lead.Lead_Source_Date_previous__c;
  }
  
  public LeadSourcePlaceHolder(Account account){
    this.leadSource = account.PersonLeadSource;
    this.leadSourceDetail = account.Lead_Source_Detail__c;
    this.leadSourceDate = account.Lead_Source_Date__c;
    this.offer = account.Offer__c;
    this.offerType = account.Offer_Type__c;
    this.url = account.Lead_URL__c;
    this.previousLeadSource = account.Lead_Source_previous__c;
    this.previousLeadSourceDetail = account.Lead_Source_Detail_previous__c;
    this.previousLeadSourceDate = account.Lead_Source_Date_previous__c;
  }
  
  public String getCurrentPlaceHolderKey(){
    if(this.leadSourceDate == null && this.leadSource == null)
      return null;
    return String.valueOf(this.leadSourceDate) + '-' + this.leadSource + '-' + this.leadSourceDetail;
  }

  public String getPreviousPlaceHolderKey(){
    if(this.previousLeadSourceDate == null && this.previousLeadSource == null)
      return null;
    return String.valueOf(this.previousLeadSourceDate) + '-' + this.previousLeadSource + '-' + this.previousLeadSourceDetail;
  }

}