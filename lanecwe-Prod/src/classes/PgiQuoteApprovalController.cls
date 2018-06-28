/********************************************************************************
Name:  PgiQuoteApprovalController() 
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

public with sharing class PgiQuoteApprovalController {    
    public string userId {get; set;}
    public boolean isApprovalRequired {get;set;} 
    public boolean isApprovalRequestInProcess {get; set;}
    public string  ApprovalComment{get;set;}
    public boolean isValidRecord {get; set;}
    public boolean Request{get;set;}        
    public string quoteId{get;set;}  
    public boolean bypass{get;set;}
    id templateid;
     List <String> CCAddress = new List <String>(); 
    public string quoteowner ;
    list<processinstance>approvalstatus;
    public boolean Is_Approval_Required{get;set;}
    public boolean isError {get; set;}   
    public string approvallevel{get;set;}     
    public boolean isCloseWindow {get; set;}             
    public set<id> queueMemberIds {get; set;}
    public PgiQuoteApprovalController(){
    try{ 
       templateid=[select id from emailtemplate where name='ApprovalEmailtoManager'].id;
         quoteId=apexpages.currentpage().getparameters().get('QuoteId');
          bypass=[select Non_Std_Terms_Conditions__c from quote where id=:quoteId ].Non_Std_Terms_Conditions__c ;
          quoteowner=[select Quote_Owner__c from quote where id=:quoteid].Quote_Owner__c ;
          approvallevel=[select Approval_Level__c from quote where id=:quoteId ].Approval_Level__c;
         
          Is_Approval_Required=[select Is_Approval_Required__c from quote where id=:quoteId ].Is_Approval_Required__c;
            list<ProcessInstanceWorkitem> approveProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                        where p.ProcessInstance.TargetObjectId =:quoteId limit 1];
            if(approveProcsId.size()==0)    {
                if(PgiQuoteApprovalUtilities.isRequiredApproval(quoteId)){ 
                        isApprovalRequired=true;                         
                }else{
                        isValidRecord = true;
                }
            }else{
                isApprovalRequestInProcess = true;
            }
                
        }catch(Exception e){
            system.debug('$$$1Exception'+e);
                isError= true; 
        }                       
    }
    
        public list<selectOption> getUsers(){   
        string queueNameLevel=PgiQuoteApprovalUtilities.getQueueName(quoteId);
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('', '- None -'));
        try{
            Id queuegroupId = [ Select Id from Group where type='Queue' and Name= :queueNameLevel].Id;
            List<GroupMember> groupMembers=[Select UserOrGroupId FROM GroupMember WHERE  GroupId  =:queueGroupId];
            set<Id> userIds= new set<Id>();
            set<Id> queueMemberIds= new set<Id>();
            for(GroupMember agroupMem: groupMembers){
                userIds.add(agroupMem.userorGroupId);
                
            }
            for (User aUser: [Select Id,Name,ManagerId FROM User WHERE  Id in :userIds]) {
                options.add(new selectOption(aUser.Id, aUser.Name)); 
            }
        }
        catch(Exception ex){
            PGIErrorUtilities.logPgiError('PgiQuoteApprovalController:getUsers()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When getting the users '+ex.getMessage());
        }
        return options;
    }
    public PageReference submitApprovalRequest() {
        try{
            list<ProcessInstanceWorkitem> approveProcsId=[Select p.Id,p.OriginalActorId from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:quoteId limit 1];
            if(approveProcsId.size()==0)
            {
                QuoteStatusUtilities.updateQuoteStatus(quoteId,QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedPriceApproval.name()).StatusValue__c);
                QuoteStatusUtilities.updateApprovalStatus(quoteId,'Pending');
                QuoteStatusUtilities.updateQuoteApprovalCommentandUser(quoteId,ApprovalComment,userId);
	            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
	            req1.setObjectId(quoteId);
	            req1.setComments(ApprovalComment);
	            req1.setNextApproverIds(new Id[]{userId});
	            Approval.ProcessResult result1 = Approval.process(req1);
	            for(user u:[select id,manager.email,managerid from user where name=:quoteowner])
	            { 
	            	if (u.managerid != this.userId)
	            	{
		            	CCAddress.add(u.manager.email);
		               	//system.debug('%%%%%'+CCAddress) ;
		               	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
		                mail.setTargetObjectId(u.id);
		                mail.setwhatid(quoteid);
		                if(CCAddress[0]!=null && CCAddress[0]!='')
		                {  
		                   mail.setCcAddresses(CCAddress);
		                }
	                    mail.settemplateid(templateid);
		                mail.setSaveAsActivity(false);
		                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		           }
	           }
	           isCloseWindow =true; 
            }                              
        }
        catch(Exception ex){
            //system.debug('ENter');
            PGIErrorUtilities.logPgiError('PgiQuoteApprovalController:submitApprovalRequest()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When submitting for approval '+ex.getMessage());
        }
        return null; 
    }
    //TestMethod for PgiQuoteApprovalController
     public static testMethod void test_PgiQuoteApprovalController(){ 
        Test.setCurrentPage(Page.PGIQuoteApproval);
             //Test Data
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.StageName= 'Proposal/Price Quote';
         insert testopp;
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         insert testquote;
         //Case1:set param for quoteId
         PGITestUtilities.setTestParameter('QuoteId', testquote.Id);
         PgiQuoteApprovalController testCase1PGIQuoteAppovalcon=new PgiQuoteApprovalController();
         //Case2:set null value for quoteId
         PGITestUtilities.setTestParameter('QuoteId',null);
         PgiQuoteApprovalController testCase2PGIQuoteAppovalcon=new PgiQuoteApprovalController();
     }
      @istest (seeAlldata=true) 
    public static void test_submitapproveRequest() {
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
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on','TestAddon','10111111');
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary','TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3=PGITestUtilities.getProductDetails('Service','testserv','30111111');
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
        //Case1:set param value
        PGITestUtilities.setTestParameter('QuoteId', testquote.Id); 
        list<QuoteLineItem> quotelst=[Select  q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testquote.Id];
        list<ProcessInstanceWorkitem> testCase1approveProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:testquote.Id limit 1];
        System.assertEquals(testCase1approveProcsId.size(),0);
        PgiQuoteApprovalController test1QuoteApprovalcon=new PgiQuoteApprovalController();
        test1QuoteApprovalcon.quoteId=testquote.Id;
        test1QuoteApprovalcon.userId=UserInfo.getUserId();
        test1QuoteApprovalcon.submitApprovalRequest(); 
        list<ProcessInstanceWorkitem> testCase2approveProcsId=[Select p.Id from ProcessInstanceWorkitem p
                                                                where p.ProcessInstance.TargetObjectId =:testquote.Id limit 1];
      //  System.assertEquals(testCase2approveProcsId.size(),1);
        PgiQuoteApprovalController test2QuoteApprovalcon=new PgiQuoteApprovalController();
        //Case3:quoteId with null value 
        PGITestUtilities.setTestParameter('QuoteId', '123'); 
        PgiQuoteApprovalController test3QuoteApprovalcon=new PgiQuoteApprovalController();
        test3QuoteApprovalcon.submitApprovalRequest();
        /*Added*/
        PgiQuoteApprovalController sendconfirmationemail=new PgiQuoteApprovalController();
        sendconfirmationemail.submitApprovalRequest();
        /*End*/
       
   
    }
     @istest (seeAlldata=false) 
    public static void test_getUsers() {
         Test.setCurrentPage(Page.PGIQuoteApproval);
         PGITestUtilities.createRegionWiseAppLevNameSetting();
         //Test Data
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.StageName= 'Proposal/Price Quote';
         insert testopp;
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         testquote.Approval_Level__c='Level 1';
         insert testquote;
         //calling getUser with valid QuoteId
         PGITestUtilities.setTestParameter('QuoteId', testquote.Id);
         PgiQuoteApprovalController testQuoteApprovalcon=new PgiQuoteApprovalController();
         testQuoteApprovalcon.quoteId=testquote.Id;
         list<SelectOption> userlst=testQuoteApprovalcon.getUsers();
         // System.assertNotEquals(userlst.size(),0); 
         delete testquote;
        PgiQuoteApprovalController testQuoteApprovalcon1=new PgiQuoteApprovalController();
         testQuoteApprovalcon1.quoteId=testquote.Id;
    }
    
    
}