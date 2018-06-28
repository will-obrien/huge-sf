/********************************************************************************
Name:  PGIQuoteDocGeneratorController()  
Copyright © 2012  PGI   
======================================================
======================================================
Purpose:
-------    
 This Class is used to generate PDF and attach in the QuotePDF Object.
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE           DETAIL              
1.0    - CapgeminiIndia         28/11/2012         Initial Development 
********************************************************************************/ 
public with sharing class PGIQuoteDocGeneratorController{
        public ID parentId {get;set;}
        public String quoteNumber {get;set;}
        public String contractType{get;set;}
        
        public PGIQuoteDocGeneratorController(ApexPages.StandardController controller){
            parentId=apexpages.currentPage().getParameters().get('id');
            quoteNumber=[select QuoteNumber from Quote where Id=:parentId ].QuoteNumber;
            contractType=[select ContractType__c from Quote where Id=:parentId ].ContractType__c;
        }
 
  public PageReference savePdf() {
    //PageReference pdf = Page.PGIQuoteDocGeneratorTemplate;
    PageReference pdf = Page.PgiQuoteDocumentnew ;
        pdf.getParameters().put('id',parentId);
    Blob body;
    try {
        body = pdf.getContent();
        }catch (VisualforceException ex) {
            PGIErrorUtilities.logPgiError('PGIPdfGeneratorController:savePdf()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Visualforce error while saving PDF '+ex.getMessage());
            body = Blob.valueOf('Some Text');
        }
       
        QuoteDocument attachQuotePdf = new QuoteDocument();
        system.debug('$$$$$$'+parentid);
        attachQuotePdf.quoteid=parentId;
        attachQuotePdf.Document=body;
        insert attachQuotePdf;
        
        
    return new PageReference('/'+parentId);
        
  }
  
  
  
  @istest (seeAlldata=false)
  private static void test_PGIPdfGeneratorController(){
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        PageReference pref=Page.PGIQuoteDocGenerator;
        pref.getParameters().put('id',testQuote.Id);
        Test.setCurrentPage(pref);
        PGIQuoteDocGeneratorController con= new PGIQuoteDocGeneratorController(PGITestUtilities.getStandardController(testQuote));
        Test.startTest();
        pref=con.savePdf();
        //assert to check that they were sent to the correct page
        System.assertEquals(pref.getUrl(),'/'+testQuote.id);
        System.assertEquals(1,[select count() from QuoteDocument where quoteid = :testQuote.id]);
        Test.stopTest(); 
  }
}