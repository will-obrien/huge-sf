public class PGIQuoteRecallActionController{
    
    public string recallComment{get;set;}
    public string requestedQuoteId{get;set;}
    public boolean isCancelled{get;set;}
    public string quoteowner ;
    public string emailapprover ;
    public list<string>approveremail=new list <string>() ;
    public static string ActorName {get;set;}
    List <String> CCAddress = new List <String>();
    public list<processinstance>approvalstatus ;
    
    public PGIQuoteRecallActionController(){
        requestedQuoteId=apexpages.currentpage().getParameters().get('QuoteId');
         
    }
    
    public ID QuoteId ;
        public ID getQuoteId (){return QuoteId;}
            public void setQuoteId(Id q){
                 QuoteId =q;
        }
    
    public PageReference recallRequest() {
        try{
                list<ProcessInstanceWorkItem> recallApprovalLst=[Select p.Id,p.OriginalActorId ,p.OriginalActor.Name ,p.Actor.Name from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:requestedQuoteId limit 1];
               
                ActorName=[select Name from User where Id=:userinfo.getuserId()].name;
                for(ProcessInstanceWorkItem p:recallApprovalLst)
                {
                emailapprover=[select email from user where id=:p.OriginalActorId ].email;
               approveremail.add(emailapprover);
               }
                id templateid=[select id from emailtemplate where name='SendCancellationEmailtoApprover'].id;
                quoteowner=[select Quote_Owner__c from quote where id=:requestedQuoteId].Quote_Owner__c ;
                for(user u:[select manager.email from user where name=:quoteowner])
                {
                CCAddress.add(u.manager.email);
                CCAddress.add(emailapprover);
                
                system.debug('%%%%%%'+CCAddress);
                Approval.ProcessWorkitemRequest recall = new Approval.ProcessWorkitemRequest();
                recall.setComments(recallComment);
                recall.setAction('Removed');
                recall.setNextApproverIds(null);
                recall.setWorkitemId(recallApprovalLst[0].Id);
                Approval.ProcessResult result =  Approval.process(recall);
                approvalstatus=[select status from processinstance where processinstance.targetobjectid=:requestedquoteid and processinstance.status='Removed'];
                system.debug('%%%%%%'+approvalstatus);
                QuoteStatusUtilities.updateQuoteStatus(requestedQuoteId,QCStatusValues__c.getInstance(PGIQuoteStatusEnum.QuoteInProgress.name()).StatusValue__c);
                QuoteStatusUtilities.updateApprovalStatus(requestedquoteid,approvalstatus[0].status );
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                mail.setTargetObjectId(u.id);
                if(CCAddress[0]!=null && CCAddress[0]!='')
                {
                mail.setCcAddresses(CCAddress);
                }
                else
                {
                 mail.setCcAddresses(approveremail);
                }
                
                mail.setTemplateId(templateid);
                mail.setSaveAsActivity(false);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                isCancelled=true;
        }
        }catch(Exception ex){
             system.debug(LoggingLevel.ERROR,'Error When approving the request '+ex.getMessage()); 
                      }
        
        return null;
    }

        
     public PageReference cancel(){
        isCancelled=true; 
        return null;
     }

@istest (seeAlldata=true) 
    public static void test_recallrequest() {
         //Test Data
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.StageName = 'Proposal/Price Quote';
         insert testopp;
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         insert testquote;
         //Case1:set param for quoteId
         PGITestUtilities.setTestParameter('QuoteId', testquote.Id);
         PGIQuoteRecallActionController testCase1PGIQuoterejectcon=new PGIQuoteRecallActionController();
         testCase1PGIQuoterejectcon.getQuoteId();
         testCase1PGIQuoterejectcon.setQuoteId(testquote.id);
         PGITestUtilities.setTestParameter('QuoteId',null);
         PGIQuoteRecallActionController testCase2PGIQuoterejectcon=new PGIQuoteRecallActionController();
            
              }

         @istest (seeAlldata=true)
         public static void rejecttest()
         {
         User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.StageName = 'Proposal/Price Quote';
         insert testopp;
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         insert testquote;
         //Case1:set param for quoteId
         PGITestUtilities.setTestParameter('QuoteId', testquote.Id);
         PGIQuoteRecallActionController testrejectcon=new PGIQuoteRecallActionController();
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
        							Where QuoteId=:testquoteLineItem1.Id];
        PGITestUtilities.setTestParameter('QuoteId', testquote.Id);
        PGIQuoteRecallActionController testpgiQuterejectCon = new PGIQuoteRecallActionController();
        testpgiQuterejectCon.requestedQuoteId=testquote.Id;
        testpgiQuterejectCon.recallRequest();
        quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testpgiQuterejectCon.requestedQuoteId];
        list<ProcessInstanceWorkitem> rejectProcsId=[Select p.Id,p.OriginalActorId ,p.OriginalActor.Name ,p.Actor.Name from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:testquote.Id limit 1];
        System.assertEquals(rejectProcsId.size(),0);   
        
         testSubmitApprovalRequest(UserInfo.getUserId(),testquote.Id);
        System.assertNotEquals(UserInfo.getUserId(),Null); 
        rejectProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:testquote.Id limit 1];
     //   System.assertEquals(rejectProcsId.size(),1); 
        quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testquote.id];
       // System.assertEquals(quotelst[0].Approval_Status__c, 'Pending for Approval');
        testpgiQuterejectCon.recallRequest();
       quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testquote.id limit 1];
        System.assertEquals(quotelst.size(), 1);
      //  System.assertEquals(quotelst[0].Approval_Status__c,'Approval Required');
                                                           
          }
        private static testMethod void test_cancel(){
        Test.setCurrentPage(Page.PGIQuoterecallAction);
        PGIQuoteRecallActionController  testpgiQuteDetailCon = new PGIQuoteRecallActionController();
        PageReference pageRef=testpgiQuteDetailCon.cancel();  
        }
      
        private static void testSubmitApprovalRequest(String userId,String quoteId){
        try{
            list<ProcessInstanceWorkitem> approveProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:quoteId limit 1];
            if(approveProcsId.size()==0)    {
     
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
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