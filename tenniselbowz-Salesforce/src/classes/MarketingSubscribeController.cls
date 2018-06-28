public with sharing class MarketingSubscribeController {

    public Account SubscriberAccount{get; set;}
    public Contact SubscriberContact{get;set;}
    Public Boolean ShowSuccessMessages{get;set;}
    
    public MarketingSubscribeController(){
    
    SubscriberAccount = new Account();
    SubscriberContact = new Contact();
    ShowSuccessMessages=false;
    }
    
    public PageReference Save(){
    
    SubscriberAccount.phone=SubscriberContact.phone;
    SubscriberAccount.Email__c=SubscriberContact.Email;
    insert SubscriberAccount;
    
    SubscriberContact.accountid=SubscriberAccount.id;
    SubscriberContact.MailingCountryCode=SubscriberAccount.BillingCountryCode;
    SubscriberContact.MailingStateCode=SubscriberAccount.BillingStateCode;
    SubscriberContact.MailingCity=SubscriberAccount.BillingCity;
    SubscriberContact.MailingStreet=SubscriberAccount.BillingStreet;
    insert SubscriberContact;
    
    return clearPages();
    }
    
    public PageReference clearPages(){
    ShowSuccessMessages=true;
    
    
    SubscriberAccount = new Account();
    
    SubscriberContact = new Contact();
    
    return null;
    }
    public PageReference cancel(){
    
    PageReference pp = Page.Subscriptions;
    pp.SetRedirect(true);
    return pp;
    }
    
}