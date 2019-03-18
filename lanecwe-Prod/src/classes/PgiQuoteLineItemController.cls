/********************************************************************************
Name:  PgiQuoteLineItemController()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This class used to create and edit PGIProduct data  
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India                                                  7/10/2012        Added 
********************************************************************************/  
public with sharing class PgiQuoteLineItemController {
        
    public string lineItemId {get; set;}   
    public string quoteId {get; set;}
    public list<PGIProduct.ProductList> allProductDetailsList{get; set;}
    set<Id>productId= new set<Id>();
    set<Id>ServId= new set<Id>();
    public set<Id> addedProducts {get; set;}
    public list<PGIProduct>ProdUsageDetails{get;set;}
    public list<Id> Addproducts {get;set;}
    public string selectedServiceId {get; set;}
    public list<Id> allQuoteLineItems {get; set;}
    public Boolean isRecordLocked {get; set;}
    public Boolean isAboveLevel3 {get; set;}
    public String userLevel {get; set;}
    public list<User> currentUser {get; set;}
    public  PgiQuoteLineItemController (ApexPages.StandardController controller)
    {

       try
           {
              quoteId = Apexpages.currentPage().getParameters().get('Id');
              system.debug('####quoteId'+quoteId);
              allProductDetailsList =  QuoteLineItemUtil.getAllProductDetails(quoteId);
              isRecordLocked = quoteLineItemUtil.isRecordLocked(quoteId);
              isAboveLevel3 = false;
              currentUser = [select id, Level_Of_Authority__c  from User where id =:UserInfo.getUserId()];
              for(User u :currentUser)
              {
                if(u.Level_Of_Authority__c.equalsIgnoreCase('Level 1') || u.Level_Of_Authority__c.equalsIgnoreCase('Level 2'))
                {
                    isAboveLevel3= false;
                }
                else
                {
                    isAboveLevel3= true;
                }
              }
           }
      catch(Exception ex)  {     
            system.debug('test error'+ex);
          }
    }    
    
    public PageReference deletelineItem()
     {
        try
        {
            if(lineItemId!=null){
                     set<Id> SetQuoteLineIds= new set<Id>();
                     SetQuoteLineIds.add(lineItemId);
                     QuoteLineItemUtil.deleteQuoteLineItems(SetQuoteLineIds);
                     allProductDetailsList =QuoteLineItemUtil.getAllProductDetails(quoteId);
            }
        }catch(Exception ex){
            PGIErrorUtilities.logPgiError('PgiQuoteLineItemController:deletelineItem()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When deleting line item '+ex.getMessage());
        }       
        
        return null;
    }
    
    public PageReference editQuoteLineItems()
    {
        try
        {
        PageReference pageRefLineItem;
        allQuoteLineItems= new list<Id>();
        for(PGIProduct.ProductList lineItem: allProductDetailsList){
            if(lineItem.isEditChecked!=null&&lineItem.isEditChecked){
                allQuoteLineItems.add(lineItem.quoteLineItemId);              
            }
        }
        }catch(Exception ex){
            PGIErrorUtilities.logPgiError('PgiQuoteLineItemController:editQuoteLineItems()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When editing line item '+ex.getMessage());
        }   
    
        return null;
    }
    

    
           //Test Method for Approval Request
    @istest (seeAlldata=true) 
    private static void test_PgiQuoteLineItemController() {
        test.startTest();
        Test.setCurrentPage(Page.PgiQuoteLineItem);
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
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111') ;
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Service', 'testserv','30111111');
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
        //Case1:set params for Id  
        PGITestUtilities.setTestParameter('Id', testQuote.Id);
        PgiQuoteLineItemController test1pgiQuoLinItCon=new PgiQuoteLineItemController(PGITestUtilities.getStandardController(testQuote));
        //Assert
        system.assertEquals(test1pgiQuoLinItCon.isRecordLocked,false);
        // system.assertNotEquals(test1pgiQuoLinItCon.allQuoteLineItems.size(),0);
        //Case1:set null value for Id
        PGITestUtilities.setTestParameter('Id',null);
        PgiQuoteLineItemController test2pgiQuoLinItCon=new PgiQuoteLineItemController(PGITestUtilities.getStandardController(testQuote));
        //Case1:set invalid value for Id
        PGITestUtilities.setTestParameter('Id','test123');
        PgiQuoteLineItemController test3pgiQuoLinItCon=new PgiQuoteLineItemController(PGITestUtilities.getStandardController(testQuote));
        test.stopTest();
    }
     @istest (seeAlldata=true) 
    private static void test_editQuoteLineItems() {
        test.startTest();
        Test.setCurrentPage(Page.PgiQuoteLineItem);
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
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111') ;
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
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
        //Case1:set params for Id  
        PGITestUtilities.setTestParameter('Id', testQuote.Id);
        PgiQuoteLineItemController test1pgiQuoLinItCon=new PgiQuoteLineItemController(PGITestUtilities.getStandardController(testQuote));
        //Assert
        system.assertNotEquals(test1pgiQuoLinItCon.allProductDetailsList.size(),0);
        for(PGIProduct.ProductList lineItem: test1pgiQuoLinItCon.allProductDetailsList){
            lineItem.isEditChecked=true;          
        }
        test1pgiQuoLinItCon.editQuoteLineItems();
        system.assertNotEquals(test1pgiQuoLinItCon.allQuoteLineItems.size(),0);
        
        
    }
       @istest (seeAlldata=true) 
    private static void test_deletelineItem() {
        test.startTest();
        Test.setCurrentPage(Page.PgiQuoteLineItem);
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
        Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111'); 
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
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
        PGITestUtilities.setTestParameter('Id', testQuote.Id);
        PgiQuoteLineItemController test1pgiQuoLinItCon=new PgiQuoteLineItemController(PGITestUtilities.getStandardController(testQuote));
         //Assert
        system.debug('#allProductdetail'+test1pgiQuoLinItCon.allProductDetailsList);
        system.debug('#pros'+test1pgiQuoLinItCon.ProdUsageDetails);
        system.assertEquals(test1pgiQuoLinItCon.allProductDetailsList.size(),1);
        test1pgiQuoLinItCon.lineItemId=testquoteLineItem1.Id;
        list<QuoteLineItem> testquotelst=[Select q.QuoteId From QuoteLineItem q where id=:testquoteLineItem1.Id];
        system.assertEquals(testquotelst.size(),1);
        test1pgiQuoLinItCon.deletelineItem();
        //Assert
        system.debug('#allProductdetail'+test1pgiQuoLinItCon.allProductDetailsList);
        system.assertEquals(test1pgiQuoLinItCon.allProductDetailsList.size(),1); 
        testquotelst=[Select q.QuoteId From QuoteLineItem q where id=:testquoteLineItem1.Id];
        system.assertEquals(testquotelst.size(),0); 
        
    }    
}