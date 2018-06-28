/********************************************************************************
Name:  PGIContactLookupController()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This class used to search  Contact name
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India                                                  23/10/2012        Added 
********************************************************************************/  
public with sharing class PGIContactLookupController 
{ 
   public string searchString{get;set;} 
   public List<Contact> results{get;set;}
   public string accountId{get; set;} 
   public string quoteType{get; set;} 
   public PGIContactLookupController() {
     try{
        searchString = System.currentPageReference().getParameters().get('lksrch');
        accountId = System.currentPageReference().getParameters().get('accountId');
        quoteType = System.currentPageReference().getParameters().get('quoteType');
        results = performSearch(searchString);  
    } catch(Exception ex){
        system.debug('Test'+ex.getMessage());
    }  
  }
 
 public PageReference search() {
    try{        
        results = performSearch(searchString);     
    }catch (Exception ex){
            PGIErrorUtilities.logPgiError('PGIContactLookupController:search()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.DEBUG);
            system.debug(LoggingLevel.ERROR,'Error When searching for Contact name '+ex.getMessage());
        }

    return null;
 }
 
 private List<Contact> performSearch(string searchString)
  {
    string soql;
            soql = 'Select Name, Title , Phone , Owner.FirstName, Owner.LastName ,Email, Account.Name ,AccountId From Contact ';
            
            if(searchString != '' && searchString != null)
             {
                soql = soql +  ' where AccountId = :accountId and name LIKE  \'' + searchString +'%\'';
                soql = soql + ' limit 25';
             }
            else
            {
                soql = soql +  ' where AccountId = :accountId LIMIT 25';
            }  
                 
            return database.query(soql);  
  
  }
  
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
    //Test method for PGIContactLookupController
    public static testMethod void TestPGIContactLookupController(){
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        testQuote.Quote_Type__c='testquoteType';
        insert testQuote;
        Test.startTest();
        PageReference pref=Page.PGIContactSearch;
        PGITestUtilities.setTestParameter('Id',testQuote.Id);  
        pref.getParameters().put('accountId',testAcc.Id);
        pref.getParameters().put('quoteType',testQuote.Quote_Type__c);
        pref.getParameters().put('lksrch','firstName');
        Test.setCurrentPage(pref);
        PGIContactLookupController con= new PGIContactLookupController();
        pref=con.search();
        con.getFormTag();
        con.getTextBox();
        system.assertEquals(con.quoteType,testquote.Quote_Type__c);
        system.assertEquals(con.searchString, 'firstName');
     //   system.assertEquals(con.results.size(),1);
        Test.stopTest();
    }
}