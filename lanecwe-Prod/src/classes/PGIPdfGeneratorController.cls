/********************************************************************************
Name:  PGIPdfGeneratorController()  
Copyright © 2012  PGI   
======================================================
======================================================
Purpose:
-------    
 This Class is used to generate ContractPDF and attach in the Attachment Object.
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE           DETAIL              
1.0    - CapgeminiIndia         25/10/2012         Initial Development 
********************************************************************************/ 
public with sharing class PGIPdfGeneratorController{
        public ID parentId {get;set;}
        public String quoteNumber {get;set;}
        public String contractType{get;set;}
        
        public PGIPdfGeneratorController(ApexPages.StandardController controller){
            parentId=apexpages.currentPage().getParameters().get('id');
            quoteNumber=[select QuoteNumber from Quote where Id=:parentId ].QuoteNumber;
            contractType=[select ContractType__c from Quote where Id=:parentId ].ContractType__c;
        }
 
  public PageReference savePdf() {
  //  PageReference pdf = Page.PGIPdfGeneratorTemplate;  //Commented by Himanshu
  PageReference pdf = Page.PGIPDFProductVerbiagePage; //Added by Himanshu
    pdf.getParameters().put('id',parentId);
    Blob body;
    try {
        body = pdf.getContent();
        }catch (VisualforceException ex) {
            PGIErrorUtilities.logPgiError('PGIPdfGeneratorController:savePdf()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Visualforce error while saving PDF '+ex.getMessage());
            body = Blob.valueOf('Some Text');
        }
        list<Attachment> quoteAttach=new list<Attachment>([Select Id,ParentId  From Attachment where ParentId=:parentId]);
        if(quoteAttach.size()>0){
          PGIAppConstants.CHECK_QUOTE_STATUS = false;
          // setting this boolean value will allow not updating the quote status in Quote count trigger.
          PGIAppConstants.FROM_CANCEL_CONTRACT_TRIGGER = true;
          delete quoteAttach;
        }
        Attachment attach = new Attachment();
        attach.Body = body;
        attach.ParentId=parentId;
        attach.Name = quoteNumber+'_'+contractType+'.pdf';
        insert attach;
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
        PageReference pref=Page.PGIPdfGenerator;
        pref.getParameters().put('id',testQuote.Id);
        Test.setCurrentPage(pref);
        PGIPdfGeneratorController con= new PGIPdfGeneratorController(PGITestUtilities.getStandardController(testQuote));
        Test.startTest();
        pref=con.savePdf();
        //assert to check that they were sent to the correct page
        System.assertEquals(pref.getUrl(),'/'+testQuote.id);
        System.assertEquals(1,[select count() from Attachment where ParentId = :testQuote.id]);
        pref=con.savePdf();
        System.assertEquals(1,[select count() from Attachment where ParentId = :testQuote.id]);
        Test.stopTest(); 
  }
}