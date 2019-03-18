/***********************************************************************
 Author       :   Amarendar Junuthula
 Created Date :   October 02, 2014
 Description  :   Controller for  Marketing Subscription Page
************************************************************************/

public with sharing class SubController {

    public Account accs{get; set;}
    public Contact cons{get;set;}
    Public Boolean ShowSuccessMessages{get;set;}
    
    public SubController(){
    
    accs = new Account();
    cons = new Contact();
    ShowSuccessMessages=false;
    }
    
    
    //Constructor
    public PageReference Save(){
    

            
            
    accs.phone=cons.phone;
    accs.Email__c=cons.Email;
    insert accs;
    
        
    
    // look for an associated contact with the same email
            Integer cnt = 0;
            for(Contact con : [select Id, AccountId 
                                 from Contact 
                                where Email = :cons.Email ORDER BY LastModifiedDate Desc Limit 1])
            {
                cons.Id = con.Id;
                cnt ++;
            }
            
            if(cnt==1) {
             cons.MailingCountryCode=accs.BillingCountryCode;
    cons.MailingStateCode=accs.BillingStateCode;
    cons.MailingCity=accs.BillingCity;
    cons.MailingStreet=accs.BillingStreet;
            upsert cons;
            }
            else {
    cons.accountid=accs.id;
    cons.MailingCountryCode=accs.BillingCountryCode;
    cons.MailingStateCode=accs.BillingStateCode;
    cons.MailingCity=accs.BillingCity;
    cons.MailingStreet=accs.BillingStreet;
    insert cons;
    }
    return clearPages();
    }
    
    public PageReference clearPages(){
    ShowSuccessMessages=true;
        
    accs = new Account();
    
    cons = new Contact();
    
    return null;
    }
    public PageReference cancel(){
    
    PageReference pp = Page.Subscriptions;
    pp.SetRedirect(true);
    return pp;
    return null;
    }
    
}