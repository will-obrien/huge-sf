/********************************************************************************
Name:  PgiQuoteApprovalUtilities() 
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This is the Utilities Class for Quote Approval Process
====================================================== 
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India                                                  1/10/2012        Added 
********************************************************************************/  
public with sharing class PgiQuoteApprovalUtilities {
 
    public static boolean isRequiredApproval(Id QuoteId){
        Boolean status = false;
        if(quoteId !=null){
        status= [Select Status,Is_Approval_Required__c From Quote where Id=:quoteId].Is_Approval_Required__c;
      
        }       
        return status;      
    }
    
    public static string getQueueName(Id QuoteId){
        Quote quote =[ Select  Id, Owner_Region__c, Approval_Level__c From Quote where Id=:quoteId];
        String queueNameLevel = quote.Approval_Level__c;
        String ownerRegion = quote.Owner_Region__c;
        PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
        Map<String, Map<String, String>> regionWiseApprovalLevelMap = staticResources.regionWiseApprovalLevelMap;
        Map<String, String> approvalLevelMap;
        if (regionWiseApprovalLevelMap != null)
        {
            approvalLevelMap = regionWiseApprovalLevelMap.get(ownerRegion);
        }
        string GroupName='';
        if(queueNameLevel.equalsIgnoreCase('Level 1') || queueNameLevel.equalsIgnoreCase(approvalLevelMap.get('Level 1'))){
        GroupName='NA PGI level 1 App';
        }else if(queueNameLevel.equalsIgnoreCase('Level 2') || queueNameLevel.equalsIgnoreCase(approvalLevelMap.get('Level 2'))){
             GroupName='NA PGI level 2 App';
        }else if(queueNameLevel.equalsIgnoreCase('Level 3') || queueNameLevel.equalsIgnoreCase(approvalLevelMap.get('Level 3'))){
             GroupName='NA PGI Level 3 App';
        }else if(queueNameLevel.equalsIgnoreCase('Level 4') || queueNameLevel.equalsIgnoreCase(approvalLevelMap.get('Level 4'))){
             GroupName='NA PGI level 4 App';
        }else if(queueNameLevel.equalsIgnoreCase('Level 5') || queueNameLevel.equalsIgnoreCase(approvalLevelMap.get('Level 5'))){
             GroupName='NA PGI level 5 App';
        }else if(queueNameLevel.equalsIgnoreCase('Level 6') || queueNameLevel.equalsIgnoreCase(approvalLevelMap.get('Level 6'))){
             GroupName='NA PGI level 6 App';
        }
        system.debug('####GroupName'+GroupName);
        return GroupName;
    }
  //TestMethod for isRequiredApproval
     public static testMethod void test_PgiQuAppUtilIsRequiredApp(){ 
         //Test Data
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.StageName = 'Proposal/Price Quote';
         insert testopp;
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         testquote.Is_Approval_Required__c=true;
         insert testquote;
         //Case1:Is_Approval_Required__c with true
         Boolean test1status=PgiQuoteApprovalUtilities.isRequiredApproval(testquote.Id);
          //Case1:Is_Approval_Required__c with false
         testquote.Is_Approval_Required__c=false;
         update testquote;
         Boolean test2status=PgiQuoteApprovalUtilities.isRequiredApproval(testquote.Id);
         //assert case1:
         system.assertEquals(test1status, true);
         //assert case2:
         system.assertEquals(test2status, false);
     }
      //TestMethod for getQueueName
     @istest(seeAlldata=false) 
     public static  void test_PgiQuAppUtilgetQueueName(){ 
         //Test Data
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.StageName = 'Proposal/Price Quote';
         insert testopp;
		 PGITestUtilities.createRegionWiseAppLevNameSetting();
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
        // Quote testquote1=PGITestUtilities.getQuoteDetails(testacc1.Id,testcon1.Id, testopp1.Id);
        // testquote1.Non_Std_Terms_Conditions__c=true;
        // insert testquote1;
         //Case 1:Approval_Level__c='Level 1'
         testquote.Non_Std_Terms_Conditions__c=true;
         testquote.Approval_Level__c='Level 1';
         insert testquote; 
         String test1GroupName=PgiQuoteApprovalUtilities.getQueueName(testquote.Id); 
          //Case 2:Approval_Level__c='Level 2'
         testquote.Approval_Level__c='Level 2';
         update testquote; 
         String test1GroupNametemp=PgiQuoteApprovalUtilities.getQueueName(testquote.Id); 
         testquote.Approval_Level__c='Level 6';
         update testquote;
         String test2GroupName=PgiQuoteApprovalUtilities.getQueueName(testquote.Id); 
          //Case 3:Approval_Level__c='Level 3'
         testquote.Approval_Level__c='Level 3';
         update testquote; 
         String test3GroupName=PgiQuoteApprovalUtilities.getQueueName(testquote.Id); 
          //Case 4:Approval_Level__c='Level 4'
         testquote.Approval_Level__c='Level 4';
         update testquote; 
         String test4GroupName=PgiQuoteApprovalUtilities.getQueueName(testquote.Id); 
          //Case 5:Approval_Level__c='Level 5'
         testquote.Approval_Level__c='Level 5';
         update testquote; 
         String test5GroupName=PgiQuoteApprovalUtilities.getQueueName(testquote.Id); 
          //Case 6:Approval_Level__c='Level 6'
         testquote.Approval_Level__c='Level 6';
         update testquote; 
         String test6GroupName=PgiQuoteApprovalUtilities.getQueueName(testquote.Id); 
         //assert-Case1
         system.assertEquals(test1GroupName,'NA PGI level 1 App');
         //assert-Case2
         system.assertEquals(test2GroupName,'NA PGI level 6 App');
         //assert-Case3
         system.assertEquals(test3GroupName,'NA PGI Level 3 App');
         //assert-Case4
         system.assertEquals(test4GroupName,'NA PGI level 4 App');
         //assert-Case5
         system.assertEquals(test5GroupName,'NA PGI level 5 App');
         //assert-Case6
         system.assertEquals(test6GroupName,'NA PGI level 6 App');
         //Assert Exception
         system.assertEquals(test1GroupNametemp,'NA PGI level 2 App');
     
     }
     
}