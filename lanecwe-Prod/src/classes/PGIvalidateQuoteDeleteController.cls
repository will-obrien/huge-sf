/********************************************************************************
Name:  PGIvalidateQuoteDeleteController() 
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This  Class is used for deleting the quote in Opportunity
====================================================== 
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India                                                  4/10/2012        Added 
********************************************************************************/  
public with sharing class PGIvalidateQuoteDeleteController {
        Quote quote = new Quote();
        list<Opportunity>oppList=new list<Opportunity>();
        list<Quote>quoteList=new list<Quote>();
        public string quoteId {get; set;}
        public  string oppId {get;set;}
        public Quote updateQuote{get;set;}
        public String deleteNotAllowedQuoteStatus
        {
        	get
        	{
	        	if (deleteNotAllowedQuoteStatus == null || deleteNotAllowedQuoteStatus.equals(''))
	        	{
	        		deleteNotAllowedQuoteStatus = deleteNotAllowedQuoteStatus 
	        									+ QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedContractInternalApproval.name()).StatusValue__c
	        									+ QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractDocumentGenerated.name()).StatusValue__c
	        									+ QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedPriceApproval.name()).StatusValue__c
	        									+ 'Submitted quote-Approval';
	        	}
	        	return deleteNotAllowedQuoteStatus;
        	}
        	private set;
        }
        public PGIvalidateQuoteDeleteController (ApexPages.StandardController controller){
             try{
                 if(apexpages.currentPage().getParameters().get('id')!=null)
                 quoteId=apexpages.currentPage().getParameters().get('id');
                    if(quoteId!=null){
                    quoteList=[Select q.TESLA_CompanyID__c,q.OpportunityId, q.Status, q.Rejected_Reason__c, q.Quote_Type__c, q.Name, q.Master_Contract_ID__c, q.Id, q.ExpirationDate, q.Contract_Company_name__c, q.ContactId, q.Company_Tax__c, q.Account__c,q.Opportunity.Opp_Stage__c From Quote q where q.Id=:quoteId];
                    for(Quote deleQuote:quoteList){
                        this.quote =deleQuote;
                        this.oppId=deleQuote.OpportunityId;
                    }
                }
        }catch(Exception e){
            System.debug('newQuote'+e);
        }
    }
      public PageReference checkDelete(){
     try{
        delete quote ;
        return new PageReference('/'+oppId);
     }
      catch (Exception ex){
            PGIErrorUtilities.logPgiError('PGIvalidateQuoteDeleteController:checkDelete()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When returning to opportunity page '+ex.getMessage());
        }
        return null; 
    }
    
  //Test Method for PGIvalidateQuoteDeleteController
    public static TestMethod void test_PGIvalidateQuoteDeleteController() {
        test.startTest();
        Test.setCurrentPage(Page.PGIQuoteApprovalAction);
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        PGITestUtilities.setTestParameter('id', testquote.Id); 
        PGIvalidateQuoteDeleteController test1PGIvalQuDel=new PGIvalidateQuoteDeleteController(PGITestUtilities.getStandardController(testQuote));
        test.stopTest();
    }
    @istest (seeAlldata=false) 
     public static void test_checkDelete() {
        test.startTest();
        Test.setCurrentPage(Page.PGIQuoteApprovalAction);
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        PGITestUtilities.setTestParameter('id', testquote.Id); 
        PGIvalidateQuoteDeleteController test1PGIvalQuDel=new PGIvalidateQuoteDeleteController(PGITestUtilities.getStandardController(testQuote));
        String test1Url=test1PGIvalQuDel.checkDelete().getUrl();
        system.assertEquals(test1Url,'/'+testOpp.Id);
        PGITestUtilities.setTestParameter('id', null); 
        PGIvalidateQuoteDeleteController test2PGIvalQuDel=new PGIvalidateQuoteDeleteController(PGITestUtilities.getStandardController(testQuote));
        PageReference test2Url=test2PGIvalQuDel.checkDelete();
        system.assertEquals(test2Url,null); 
        test.stopTest();
     
     }
}