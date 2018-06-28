/********************************************************************************
Name:  PGIQuoteLineItemTriggerUtilities()    
Copyright © 2012  PGI   
======================================================
====================================================== 
Purpose:
-------    
 Trigger to update Contract Type on Quote
====================================================== 
======================================================
History 
-------
VERSION  AUTHOR                DATE           DETAIL              
1.0    - CapgeminiIndia         23/10/2012         Initial Development 
********************************************************************************/  
public class PGIQuoteLineItemTriggerUtilities{ 

public static void updateContractType(Set<Id> quoteIdlst){
        Map<ID,list<QuotelineItem>> quoteMaplst=new  Map<ID,list<QuotelineItem>>();
        list<QuotelineItem> quoteItemlst=new list<QuotelineItem>();
        set<String> productlst=new  set<String>();
        Map<Id,String> quoteMapConType =new Map<Id,String>();
        list<Quote> quolst=new List<Quote>();
        Boolean licenseProduct=false;
        Boolean nonlicenseProduct=false; 
        
        list<QuotelineItem> quoteLinelst=[Select  q.Product__r.isPGILicense__c, q.Product__r.Name, q.Product__c ,q.quoteId From QuoteLineItem q where q.QuoteId=:quoteIdlst and q.Product__r.ProductType__c='Service' limit 100];
        for(QuotelineItem quoteline:quoteLinelst){
             quoteItemlst=new list<QuotelineItem>();
             
             if((quoteMaplst.get(quoteline.quoteId))!=null){
                quoteItemlst=quoteMaplst.get(quoteline.quoteId);
                quoteItemlst.add(quoteline);
                quoteMaplst.put(quoteline.quoteId,quoteItemlst);
             }
             else{
                quoteItemlst.add(quoteline);
                quoteMaplst.put(quoteline.quoteId,quoteItemlst);
             }
         } 
        Map<Id,Quote> quotelst=new Map<Id,Quote>([Select q.Quote_Type__c, q.Account__r.Status__c,q.ContractType__c,q.IsMinimumContractType__c From Quote q where q.Id=:quoteIdlst]);
        for(Quote quo:quotelst.Values()){
            if(quoteMaplst.get(quo.Id)==null){
              quo.ContractType__c=null;
              quolst.add(quo);
            }
        }
        for(list<QuoteLineItem> quoItemlst:quoteMaplst.Values()){
                Set<String> proItem=new set<String>();
                Id quoteId;
                for(QuoteLineItem quoItem:quoItemlst){ 
                        if(quoteId==null) 
                            quoteId=quoItem.quoteId;
                        if(quoItem.Product__r.isPGILicense__c==true)
                             licenseProduct=true;
                        else 
                             nonlicenseProduct=true;
                     }   
                       
                if(quotelst.get(quoteId)!=null) 
                {
                    
                      Quote quoteDetail=quotelst.get(quoteId);
                      String ContractType=quoteDetail.ContractType__c;
                      if(quoteDetail.Account__r.Status__c!='Customer'||quoteDetail.Quote_Type__c!='Existing Customer – Rate Change')
                      {
                      			// commented below line of code based on new requirement to set contract type.
                      			// according to new requirement, if a Q/C record has any QLIs with PGi License products represented then Contract Type should be set to “Subscription License Order”
                      			// there is no need for a “Subscription License Agreement” contract type to be set by the system
                              /*if(licenseProduct==true&&nonlicenseProduct==true)
                              {
                                        quoteDetail.ContractType__c='Subscription License Agreement';
                              }
                               else*/ if(licenseProduct==true)  
                                      {
                                           quoteDetail.ContractType__c='Subscription License Order';
                                      }
                                    else if(nonlicenseProduct=true)
                                          {
                                            if(quoteDetail.IsMinimumContractType__c==true)
                                             // quoteDetail.ContractType__c='Customer Service Order(with Minimum Commitment)';
                                            quoteDetail.ContractType__c='Customer Service Order' ;
                                            else
                                            quoteDetail.ContractType__c='Customer Service Order' ;
                                             //quoteDetail.ContractType__c='Customer Service Order(without Minimum Commitment)';
                                          }
                      }                  
                      else
                          quoteDetail.ContractType__c='Services & Pricing Schedule – Customer Rates';
                       if(contractType!=quoteDetail.ContractType__c&&quoteDetail.ContractType__c!='Customer Service Order(with Minimum Commitment)')
                        {
                            quoteDetail.IsMinimumContractType__c=false;
                            quoteDetail.MinimumContractLength__c=null;
                            quoteDetail.Minimum_Committment_Value__c=null;
                        }
                     quolst.add(quoteDetail);
                }
                                 
                    
        }
          
        update quolst; 
    }
    
    
    
@isTest(seeAlldata=true) 
    public static void test_getConfigureServiceUsage() {
        test.startTest();
        //Test.setCurrentPage(Page.PGIQuoteApprovalAction);
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
        Product__c testprod1 = PGITestUtilities.getProductDetails('Service', 'TestAddon','10111111');
        
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Service','TestAncillary','20111111');
        insert testProd2;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
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
        Set<Id> quoteIdlst=new Set<Id>();
        quoteIdlst.add(testQuote.ID);
        //Case1:Customer Service Order(without Minimum Commitment)
        updateContractType(quoteIdlst);
        list<Quote> quolst=[Select ContractType__c from Quote where id=:testQuote.Id];
        system.assertEquals(quolst[0].ContractType__c,'Customer Service Order');
        //Case2:Customer Service Order(with Minimum Commitment)
        testQuote.IsMinimumContractType__c=true;
        testQuote.MinimumContractLength__c='Monthly';
        testQuote.Minimum_Committment_Value__c='1';
        update testQuote;
        updateContractType(quoteIdlst);
        quolst=[Select ContractType__c from Quote where id=:testQuote.Id];
        system.assertEquals(quolst[0].ContractType__c,'Customer Service Order');
        //Case3:Subscription License Agreement
        testProd1.isPGILicense__c=true;
        update testProd1;
        updateContractType(quoteIdlst);
         quolst=[Select ContractType__c from Quote where id=:testQuote.Id];
        system.assertEquals(quolst[0].ContractType__c,'Subscription License Order');
        //Case4:Subscription License Order
        testProd2.isPGILicense__c=true;
        update testProd2;
        updateContractType(quoteIdlst);
         quolst=[Select ContractType__c from Quote where id=:testQuote.Id];
        system.assertEquals(quolst[0].ContractType__c,'Subscription License Order');
        
        //Case5:Services & Pricing Schedule – Customer Rates
        testAcc.Status__c='Customer';
        update testAcc;
        testQuote.Quote_Type__c='Existing Customer – Rate Change';
        testQuote.Account__c=testAcc.Id;
        update testQuote;
        updateContractType(quoteIdlst);
        //Case5:isDelete
        delete testquoteLineItem1;
        delete testquoteLineItem2;
        updateContractType(quoteIdlst);
        
    }
    
}