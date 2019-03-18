/********************************************************************************
Name:  PgiPendingRequestController()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This class used to Approve or Reject QuoteLineItems 
submitted for Approval
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India                                                  1/10/2012        Added 
********************************************************************************/  
public with sharing class PgiPendingRequestController { 
    
    public list<PgiQuote> pendingQuote{get;set;}    
    public string requestQuoteId {get;set;}
    public PgiPendingRequestController(){
        try{
             pendingQuote=PgiPendingRequestutilities.getWorkItems();  
        }catch(Exception e){
            System.debug('Exception'+ e);
        }
    }
    
    public PageReference QuoteApproveReject(){
        try{
            PageReference approveReject= new PageReference('/apex/PGIQuoteApprovalAction');
            approveReject.setRedirect(true);
            approveReject.getParameters().put('quoteId',requestQuoteId); 
            return approveReject;
            
        }
        catch (Exception ex){
            PGIErrorUtilities.logPgiError('PgiPendingRequestController:QuoteApproveReject()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
                system.debug(LoggingLevel.ERROR,'Error When redirecting to PGIQuoteApprovalAction page '+ex.getMessage());
        }
         return ApexPages.currentPage(); 
    } 
    //Test Method for PgiPendingRequestController
    @istest (seeAlldata=true) 
    public static void test_PgiPendingRequestController() {
        test.startTest();
        
        //Testdata 
        Account testAcc= PGITestUtilities.getAccountDetails();
                insert testAcc;
                Opportunity testOpp= PGITestUtilities.getOpportunityDetails();          
                insert testOpp;
                Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
                Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
                insert testQuote;
                Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
                list<Product__c> allProduct= new list<Product__c>();
                Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on','TestAddon','10111111');
                insert testProd1;               
                Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary','TestAncillary','20111111');
                insert testProd2;
                Product__c testprod3= PGITestUtilities.getProductDetails('Service','testserv','30111111');
                insert testProd3;
                Solution__c testSoln = PGITestUtilities.getSolution();
                insert testSoln;
                Service__c testSer= PGITestUtilities.getService(testSoln.Id);
                insert testSer;
                ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testProd3.Id, true);
                insert testSc1;
                ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testProd2.Id, false);
                insert testSc2;
                ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, false);
                insert testSc3;
                PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
                string standardPriceBookId = pb2Standard.Id;
                Product2 testProd= PGITestUtilities.getStdProduct();        
        		insert testProd; 
        		PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
                insert pbe;
                OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe.Id);
        		insert oli; 
                QuoteLineItem testquoteLineItem1=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
                insert testquoteLineItem1;
                QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod2.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem2;
                QuoteLineItem testquoteLineItem3=PGITestUtilities.getTestQuoteLineItem(testprod3.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem1.Id);
                insert testquoteLineItem3;   
                list<QuoteLineItem> quotelst=[Select q.UnitPrice, q.Service__c, q.QuoteId, q.Quantity, q.Product__c, q.PricebookEntry.Name, q.PricebookEntryId, q.Approval_Status__c 
                							From QuoteLineItem q 
                							Where QuoteId=:testquoteLineItem1.Id LIMIT 50000];
            PGITestUtilities.setTestParameter('QuoteId', testquote.Id);
                quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testquote.Id];
        list<ProcessInstanceWorkitem> approveProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:testquote.Id limit 1];
        //Assert
        System.assertEquals(approveProcsId.size(),0);
            testSubmitApprovalRequest(UserInfo.getUserId(),testquote.Id);
            System.assertNotEquals(UserInfo.getUserId(),Null); 
            approveProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                               where p.ProcessInstance.TargetObjectId =:testquote.Id limit 1];
        //Assert
       // System.assertEquals(approveProcsId.size(),0); 
        PgiPendingRequestController pgiPenReq=new PgiPendingRequestController();
        Test.stoptest();
        
    }
    @istest (seeAlldata=true) 
    public static void test_QuoteApproveReject() { 
        //Test Data
        Account testAcc= PGITestUtilities.getAccountDetails();
                insert testAcc;
                Opportunity testOpp= PGITestUtilities.getOpportunityDetails();          
                insert testOpp;
                Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
                Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
                insert testQuote;
                PgiPendingRequestController pgiPenReq=new PgiPendingRequestController();
        pgiPenReq.requestQuoteId=testQuote.Id;
        String test1=pgiPenReq.QuoteApproveReject().getUrl();
        system.assertEquals(test1,'/apex/PGIQuoteApprovalAction?quoteId='+testQuote.Id);
        
    }
     private static void testSubmitApprovalRequest(String userId,String quoteId){
        try{
                        list<ProcessInstanceWorkitem> approveProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                                                                                where p.ProcessInstance.TargetObjectId =:quoteId limit 1];
                        if(approveProcsId.size()==0)    {
         
                        Approval.ProcessSubmitRequest req1 = 
                                        new Approval.ProcessSubmitRequest();
                        req1.setObjectId(quoteId);
                        
                        req1.setNextApproverIds(new Id[]{userId});
                        //req1.setNextApproverIds(userIds);
                        Approval.ProcessResult result1 = Approval.process(req1);
                        //isCloseWindow   =true;   
                        QuoteStatusUtilities.updateQuoteStatus(quoteId,QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedPriceApproval.name()).StatusValue__c);
                        }                              
                }
                catch(Exception ex){
                                system.debug('TEST'+ex);
                }
                
      }
}