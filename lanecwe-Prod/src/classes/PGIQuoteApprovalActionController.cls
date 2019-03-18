/********************************************************************************
Name:  PGIQuoteApprovalActionController() 
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

public with sharing class PGIQuoteApprovalActionController {
    public string approvalProcessComment {get; set;}
    public QuoteAccount quoteInfo {get; set;}
    public list<PGIProduct.ProductList> allProductDetailsList{get; set;}
    public string requestQuoteId  {get; set;}
    public list<processinstance>approvalstatus ;
    public boolean approvalProcessed {get;set;}
    public boolean bypass{get;set;} 
    public string commentsforapprovar{get;set;}
    public boolean Isapprovalprocess {get;set;}
    public boolean iscloned{get;set;}
    public PGIQuoteApprovalActionController(){
    try{
        requestQuoteId = apexPages.currentpage().getParameters().get('QuoteId'); 
       iscloned=[select IsCloned__c from quote where id=:requestQuoteId].IsCloned__c ;
        bypass=[select Non_Std_Terms_Conditions__c from quote where id =:requestQuoteId ].Non_Std_Terms_Conditions__c;
        commentsforapprovar=[select Comment_For_Approver__c from quote where id =:requestQuoteId ].Comment_For_Approver__c;
        allProductDetailsList =  QuoteLineItemUtil.getAllProductDetails(requestQuoteId);
         quoteInfo= QuoteAccInfoUtilities.getQuoteAccInfo(requestQuoteId); 
        list<ProcessInstanceWorkitem> approvalAction=[Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =:requestQuoteId limit 1];
                 system.debug('approvalAction'+approvalAction);
                  if(approvalAction.isEmpty()){
                        approvalProcessed=true;
                        Isapprovalprocess=false;
                  }else{
                        approvalProcessed=false;
                        Isapprovalprocess=true;
                  }
        }
       
        catch(exception e)
        {
            system.debug('exception'+e);
        }                                  
    } 
    
    public PageReference approveRequest(){       
        try {
                list<ProcessInstanceWorkitem> approveProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:requestQuoteId limit 1];
                Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                req2.setComments(approvalProcessComment);
                req2.setAction('Approve');
                req2.setNextApproverIds(null);
                req2.setWorkitemId(approveProcsId[0].Id);
                Approval.ProcessResult result2 =  Approval.process(req2);
                QuoteStatusUtilities.updateApprovalStatus(requestQuoteId,'Approved');
                QuoteStatusUtilities.updateQuoteStatus(requestQuoteId, QCStatusValues__c.getInstance(PGIQuoteStatusEnum.PricingApproved.name()).StatusValue__c);
               
        }
        catch(Exception ex){
               PGIErrorUtilities.logPgiError('PGIQuoteApprovalActionController:approveRequest()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
               system.debug(LoggingLevel.ERROR,'Error When approving the request '+ex.getMessage()); 
        }
        PageReference approveReject= new PageReference('/apex/PGIPendingRequest');
        approveReject.setRedirect(true); 
        return approveReject;
    } 
    
     public Pagereference rejectRequest(){
           try { 
               
                 {
                        list<ProcessInstanceWorkitem> rejectProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:requestQuoteId limit 1];
                        Approval.ProcessWorkitemRequest rejectApp = new Approval.ProcessWorkitemRequest();
                        rejectApp.setComments(approvalProcessComment);
                        rejectApp.setAction('Reject');
                        rejectApp.setNextApproverIds(null);
                        rejectApp.setWorkitemId(rejectProcsId[0].Id);
                        Approval.ProcessResult resApp =  Approval.process(rejectApp);
                         QuoteStatusUtilities.updateQuoteStatus(requestQuoteId,QCStatusValues__c.getInstance(PGIQuoteStatusEnum.QuoteInProgress.name()).StatusValue__c); 
                        approvalstatus =[select status from processinstance where processinstance.targetobjectid=:requestQuoteId and processinstance.status='rejected'];
                        QuoteStatusUtilities.updateApprovalStatus(requestQuoteId,approvalstatus[0].status );
                }
            }
            catch(Exception ex){
                 PGIErrorUtilities.logPgiError('PGIQuoteApprovalActionController:rejectRequest()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
                 system.debug(LoggingLevel.ERROR,'Error When rejecting the request '+ex.getMessage());                
           }
        PageReference approveReject= new PageReference('/apex/PGIPendingRequest');
        approveReject.setRedirect(true); 
        return approveReject;
    }
    public Pagereference QuoteDetailpage(){     
        PageReference quoteDetail= new PageReference('/'+requestQuoteId);
        quoteDetail.setRedirect(true); 
        return quoteDetail;
         
    }
  private static testMethod void test_PGIQuoteApprovalActionController(){ 
         
         test.starttest();
         Test.setCurrentPage(Page.PGIQuoteApprovalAction);
         //Test Data
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.StageName= 'Proposal/Price Quote';
         insert testopp;
         quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         insert testquote;
         //case1: set param for quoteId
         PGITestUtilities.setTestParameter('QuoteId', testquote.Id);
         QuoteAccount testquoteAcc=new QuoteAccount(testquote,testopp);
         System.debug('#test'+testquoteAcc);
         PGIQuoteApprovalActionController testCase1pgiQuteApprovalCon = new PGIQuoteApprovalActionController();
         //case2: set param for quoteId
         PGITestUtilities.setTestParameter('QuoteId', null);
         PGIQuoteApprovalActionController testCase2pgiQuteApprovalCon = new PGIQuoteApprovalActionController();
         //assert:case1
     //    system.assertEquals(testCase1pgiQuteApprovalCon.quoteInfo.quoteName ,testquoteAcc.quoteName );
         //assert:case2
       //  system.assertEquals(testCase1pgiQuteApprovalCon.allProductDetailsList.size(),0 );
         list<ProcessInstanceWorkitem> approvalAction=[Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =:testquote.id limit 1];
      test.stoptest();    
      }
      
        //Test Method for Approval Request
    @istest (seeAlldata=true) 
    public static void test_approveRequest() {
        test.startTest();
        Test.setCurrentPage(Page.PGIQuoteApprovalAction);
        //Testdata 
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
        
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Quote testQuote1= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        testQuote1.Non_Std_Terms_Conditions__c=true;
        insert testQuote1;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111');
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
        							Where QuoteId=:testQuote.Id LIMIT 50000];
    
       // PGITestUtilities.setTestParameter('QuoteId', testquote.Id);
        PGIQuoteApprovalActionController testpgiQuteApprovalCon = new PGIQuoteApprovalActionController();
        testpgiQuteApprovalCon.requestQuoteId=testquote.Id;
        testpgiQuteApprovalCon.approveRequest();
        quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testpgiQuteApprovalCon.requestQuoteId];
        list<ProcessInstanceWorkitem> approveProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:testquote.Id limit 1];
      //  System.assertEquals(approveProcsId.size(),0);
        
        /*Added*/
        PGITestUtilities.setTestParameter('QuoteId', testquote1.Id);
        PGIQuoteApprovalActionController testpgiQuteApprovalCon1 = new PGIQuoteApprovalActionController();
        testpgiQuteApprovalCon1.requestQuoteId=testquote1.Id;
        testpgiQuteApprovalCon1.approveRequest();
        quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testpgiQuteApprovalCon.requestQuoteId];
        list<ProcessInstanceWorkitem> approveProcsId1=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:testquote1.Id limit 1];
        
        
        
        testSubmitApprovalRequest(UserInfo.getUserId(),testquote.Id);
      //  System.assertNotEquals(UserInfo.getUserId(),Null); 
        approveProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:testquote.Id limit 1];
       // System.assertEquals(approveProcsId.size(),1); 
        quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testpgiQuteApprovalCon.requestQuoteId];
     //   System.assertEquals(quotelst[0].Approval_Status__c, 'Pending for Approval');
        testpgiQuteApprovalCon.approveRequest();
        quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testpgiQuteApprovalCon.requestQuoteId];
      //  System.assertEquals(quotelst[0].Approval_Status__c, 'Approved');
        test.stopTest();
        
    } 
        @istest (seeAlldata=true) 
        public static  void test_rejectRequest(){
            test.startTest();
        Test.setCurrentPage(Page.PGIQuoteApprovalAction);
        //Testdata 
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
        
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Quote testQuote1= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        testQuote1.Non_Std_Terms_Conditions__c=true;
        insert testQuote1;
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
        							Where QuoteId=:testquoteLineItem1.Id];
        //System.assertNotEquals(quotelst.size(),0);
        //requestQuoteId
      //  PGITestUtilities.setTestParameter('QuoteId', testquote.Id);
        PGIQuoteApprovalActionController testpgiQuteApprovalCon = new PGIQuoteApprovalActionController();
        testpgiQuteApprovalCon.requestQuoteId=testquote.Id;
        testpgiQuteApprovalCon.rejectRequest();
        quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testpgiQuteApprovalCon.requestQuoteId];
        list<ProcessInstanceWorkitem> rejectProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:testquote.Id limit 1];
       
      //  System.assertEquals(rejectProcsId.size(),0);
        
        /*Added*/
        PGITestUtilities.setTestParameter('QuoteId', testquote1.Id);
        PGIQuoteApprovalActionController testpgiQuteApprovalCon1 = new PGIQuoteApprovalActionController();
        testpgiQuteApprovalCon1.requestQuoteId=testquote1.Id;
        testpgiQuteApprovalCon1.rejectRequest();
        quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testpgiQuteApprovalCon.requestQuoteId];
        list<ProcessInstanceWorkitem> rejectProcsId1=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:testquote1.Id limit 1];
        
        
       /* PgiQuoteApprovalController testQuoteApprovalcon=new PgiQuoteApprovalController();
        testQuoteApprovalcon.quoteId=testquote.Id;
        testQuoteApprovalcon.userId=UserInfo.getUserId(); 
        testQuoteApprovalcon.submitApprovalRequest(); */
        testSubmitApprovalRequest(UserInfo.getUserId(),testquote.Id);
        
      //  System.assertNotEquals(UserInfo.getUserId(),Null); 
        rejectProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:testquote.Id limit 1];
       // System.assertEquals(rejectProcsId.size(),1); 
        quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testpgiQuteApprovalCon.requestQuoteId];
       // System.assertEquals(quotelst[0].Approval_Status__c, 'Pending for Approval');
        testpgiQuteApprovalCon.rejectRequest();
        quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testpgiQuteApprovalCon.requestQuoteId limit 1];
      //  System.assertEquals(quotelst.size(), 1);
      //  System.assertEquals(quotelst[0].Approval_Status__c,'Approval Required');
        test.stopTest();
         
       }
        private static testMethod void test_QuoteDetailpage(){
            Test.setCurrentPage(Page.PGIQuoteApprovalAction);
        //  PGITestUtilities.setTestParameter('QuoteId', 'quote123');
            PGIQuoteApprovalActionController testpgiQuteDetailCon = new PGIQuoteApprovalActionController();
            PageReference pageRef=testpgiQuteDetailCon.QuoteDetailpage();  
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