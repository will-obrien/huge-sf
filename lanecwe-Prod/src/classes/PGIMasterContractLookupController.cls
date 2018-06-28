/********************************************************************************
Name:  PGIMasterContractLookupController()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This class used to search Tesla company and Contract name
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India                                                  23/10/2012        Added 
********************************************************************************/  
public with sharing class PGIMasterContractLookupController 
{ 
   public string searchString{get;set;} 
   public List<PGI_Contract__c> results{get;set;}
   public string accountId{get; set;} 
   public string quoteType{get; set;}  
   public PGIMasterContractLookupController() {
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
            PGIErrorUtilities.logPgiError('PGIMasterContractLookupController:search()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When searching for Contract name '+ex.getMessage());
        }

    return null;
 }
 
  private List<PGI_Contract__c> performSearch(string searchString)
  {
    string soql;
     if(quoteType == 'Existing Customer – Rate Change')
     {
            soql = 'select id, name, Owner.FirstName, Owner.LastName , Contract_Number__c,Document_Type__c , Service_Commencement_Date__c,Company__c from PGI_Contract__c ';
            System.debug('contract number' +soql);
            if(searchString != '' && searchString != null)
             {
                soql = soql +  ' where Account__c=:accountId and name LIKE  \'' + searchString +'%\'';
                soql = soql + ' limit 45';
                System.debug('contract number' +soql);
             }
            else
            {
                soql = soql +  ' where Account__c=:accountId LIMIT 25';
            }    
            return database.query(soql); 
     }else
           return(new List<PGI_Contract__c>());
  }
  
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
  
  //Test method for TestPGIMasterContractLookupController
   public static testMethod void TestPGIMasterContractLookupController(){
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        testQuote.Quote_Type__c='Existing Customer – Rate Change';
        insert testQuote;
        PGI_Contract__c testContract=PGITestUtilities.getContract(testAcc.Id,testQuote.Id);
        insert testContract ;
        Test.startTest();
        PageReference pref=Page.PGIMasterContractSearch;
        PGITestUtilities.setTestParameter('Id',testQuote.Id);  
        pref.getParameters().put('accountId',testAcc.Id);
        pref.getParameters().put('quoteType',testQuote.Quote_Type__c);
        pref.getParameters().put('lksrch','test');
        Test.setCurrentPage(pref);
        PGIMasterContractLookupController con= new PGIMasterContractLookupController();
        pref=con.search();
        con.getFormTag();
        con.getTextBox();
        system.assertEquals(con.quoteType,testquote.Quote_Type__c);
        system.assertEquals(con.searchString,'test');
        system.assertEquals(con.results.size(),1);
        Test.stopTest();
   }
 
}