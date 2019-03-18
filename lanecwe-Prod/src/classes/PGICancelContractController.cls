/********************************************************************************
Name:  PGICancelContractController()  
Copyright © 2012  PGI   
======================================================
======================================================
Purpose:
-------    
 This Class is used to delete ContractPDF 
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE           DETAIL              
1.0    - CapgeminiIndia         13/04/2013         Initial Development 
********************************************************************************/ 
public with sharing class PGICancelContractController{
        public ID parentId {get;set;}
        public PGICancelContractController(ApexPages.StandardController controller){
            parentId=apexpages.currentPage().getParameters().get('id');
            
        }
 
  public PageReference cancelContract() {
  try{
         list<Attachment> quoteAttach=new list<Attachment>([Select Id,ParentId  From Attachment where ParentId=:parentId]);
             if(quoteAttach.size()>0){
                 PGIAppConstants.CHECK_QUOTE_STATUS = false;
                 delete quoteAttach;
             }
             Quote quoteStatus=[Select Status from Quote where Id=:parentId];
             quoteStatus.Status=QCStatusValues__c.getInstance(PGIQuoteStatusEnum.PricingApproved.name()).StatusValue__c;
             update quoteStatus;         
             
        }
        catch(Exception e){
            system.debug('Cancel Exception'+ e);
         return new PageReference('/'+parentId);
        }
    return new PageReference('/'+parentId);
  }
  
   @istest (seeAlldata=false) 
    private static  void testPGICancelContractController(){
        set<id>quoteId= new set<Id>();
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
        Account acc=new Account();
        acc=PGITestUtilities.getAccountDetails();
        insert acc;
        Contact con=PGITestUtilities.getContactDetails(acc.Id);
        insert con;
        Opportunity  opp=PGITestUtilities.getOpportunityDetails();
        insert opp;
        Quote quote=PGITestUtilities.getQuoteDetails(acc.id,con.id,opp.id);
        quote.Status=QCStatusValues__c.getInstance(PGIQuoteStatusEnum.PricingApproved.name()).StatusValue__c;
        insert quote;
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=quote.id;
        insert attach;
        test.starttest();
        PGITestUtilities.setTestParameter('id',quote.id);
         PGICancelContractController testCase= new PGICancelContractController(PGITestUtilities.getStandardController(quote));  
        testCase.cancelContract();
        test.stoptest();
        
 }

}