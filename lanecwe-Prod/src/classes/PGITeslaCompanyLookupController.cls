/********************************************************************************
Name:  PGITeslaCompanyLookupController()
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
public with sharing class PGITeslaCompanyLookupController 
{ 
   public string searchString{get;set;} 
   public List<Company__c> results{get; set;}
   public string accountId{get; set;} 
   public string quoteType{get; set;} 
   public PGITeslaCompanyLookupController() {
    
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
        results= performSearch(searchString);      
    }catch (Exception ex){
            PGIErrorUtilities.logPgiError('PGITeslaCompanyLookupController:search()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When searching Tesla company '+ex.getMessage());
        }

     return null;
  }
   
  private List<company__c> performSearch(string searchString) 
  {
       string strSoql = '';
       system.debug('test'+quoteType);
       if(quoteType.equalsIgnoreCase('Existing Customer/Renewal')  || quoteType.equalsIgnoreCase('Existing Customer – Rate Change'))
       {
            strSoql = 'select id, name ,TESLA_CompanyID__c,Account__r.name,CLIENT_COUNT__c,Corporate_Entity__c,Region__c,TESLA_IntlCountryCode__c,TESLA_Territory_Code__c,TESLA_InactiveDate__c from company__c ';
            if(searchString != '' && searchString != null)
            {
                strSoql = strSoql +  ' where Account__c=:accountId and  name LIKE \'' + searchString +'%\'';
                strSoql = strSoql + ' limit 45';
            }
            else
                strSoql = strSoql +  ' where Account__c=:accountId LIMIT 25';
            
            return database.query(strSoql); 
        }  
        else
           return(new List<company__c>());
  }
    
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
   //Test method for PGITeslaCompanyLookupController
   public static testMethod void TestPGITeslaCompanyLookupController(){
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        testQuote.Quote_Type__c='Existing Customer/Renewal';
        insert testQuote;
        Company__c testCompany=PGITestUtilities.getCompany(testAcc.Id);
        insert testCompany;
        Test.startTest();
        PageReference pref=Page.PGITeslaCompanySearch;
        PGITestUtilities.setTestParameter('Id',testQuote.Id);  
        pref.getParameters().put('accountId',testAcc.Id);
        pref.getParameters().put('quoteType',testQuote.Quote_Type__c);
        pref.getParameters().put('lksrch','test');
        Test.setCurrentPage(pref);
        PGITeslaCompanyLookupController con= new PGITeslaCompanyLookupController();
        pref=con.search();
        con.getFormTag();
        con.getTextBox();
        system.assertEquals(con.quoteType,testquote.Quote_Type__c);
        system.assertEquals(con.searchString,'test');
        system.assertEquals(con.results.size(),1);
        Test.stopTest();
   }
 
}