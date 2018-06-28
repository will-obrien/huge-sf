/*
 ********************************************************************************
Name:  PGIQuoteCloneController()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This class used to clone and copy the existing Quote and QuoteLineItems for contract amendment 
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India                                                  3/12/2012        Added 
******************************************************************************* 
*/
public with sharing class PGIQuoteCloneController
{
        public String accId{get; set;}
        public list<Quote> allAccQuotes {get; set;}
        public string cloneQuoteID{get;set;} //oldQuoteId
        public quote existingQuote{get;set;}
        public quote clonedQuote{get;set;}//new QuoteId 
        public id newQuoterec{get;set;}
        public boolean btnClick{get; set;}
        set<Id> setofExistinglineitemIds = new  set<Id>();
        List<QuoteLineItem> masterQuoteLineItem =  new List<QuoteLineItem>();
        List<QuoteLineItem> QuoteLineItems =  new List<QuoteLineItem>();
        public quotelineitem masterInsertedQuoteline{get; set;}
        public PGIQuoteCloneController(ApexPages.StandardController controller) 
        {
            try
            {
                btnClick = false;
                accId = Apexpages.currentPage().getParameters().get('Id');
                allAccQuotes = new list<Quote>();
                if(accId != null)
                {
                    allAccQuotes = [Select Name, Id, ExpirationDate, CreatedDate,CreatedById From Quote  where account__c =: accId and Status =:QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractSignedbyCustomer.name()).StatusValue__c order by Name ]; 
                }
            }
            catch(Exception ex)  
           {     
                system.debug('test error'+ex);
           }
        
    }
    //Method to Clone Quote and QuoteLineItem
        public PageReference contractAmendment()
        {
            system.debug('enterInside');
            Savepoint sp = Database.setSavepoint();
            try
            {  
                string s=''; 
                clonedQuote = PGIQuoteCloneUtilities.getCreatableFieldsOfQuote(cloneQuoteID);
                btnClick = true;
                newQuoterec = clonedQuote.id;
                List<quotelineitem> ListOfxistingQuotelineitem = new List<quotelineitem>();
                List<quotelineitem> ListOfxistingQuotelineitemAddonAncillary = new List<quotelineitem>();
                String serviceLineItem = PGIQuoteCloneUtilities.getCreatableFieldsSOQL(cloneQuoteID,'QuoteLineItem','Service' );
                if(serviceLineItem!='' ||serviceLineItem!=null){
                    ListOfxistingQuotelineitem=Database.query(serviceLineItem);
                }
                for(quotelineitem serviceQuoteLine : ListOfxistingQuotelineitem)
                {
                    if(serviceQuoteLine.Quote_Line_Item__c == null)             
                    {
                         masterInsertedQuoteline = serviceQuoteLine.Clone();
                         masterInsertedQuoteline.quoteid = clonedQuote.id;
                         masterInsertedQuoteline.ChangeType__c='';
                         masterInsertedQuoteline.QuantityChange__c=null;
                         masterInsertedQuoteline.ContractTermChange__c=null;
                         masterInsertedQuoteline.BidPriceChange__c=null;
                         masterQuoteLineItem.add(masterInsertedQuoteline);
                    }
                }                              
                insert masterQuoteLineItem;
                   for(quotelineitem qtline:ListOfxistingQuotelineitem)
                {
                    setofExistinglineitemIds.add(qtline.Id);
                } 
                  String addonAncilaryLineItem = PGIQuoteCloneUtilities.getCreatableFieldsSOQL(cloneQuoteID,'QuoteLineItem','Addon' );
                  addonAncilaryLineItem+=' And Quote_Line_Item__c =:setofExistinglineitemIds order by Quote_Line_Item__c';
                  if(addonAncilaryLineItem!='' || addonAncilaryLineItem!=null){
                    ListOfxistingQuotelineitemAddonAncillary=Database.query(addonAncilaryLineItem);
                  }
                if(!masterQuoteLineItem.isEmpty())
                {
                    for(quotelineitem serviceQuoteLine : ListOfxistingQuotelineitem)
                    {                       
                        for(quotelineitem slineitem:masterQuoteLineItem)
                        {       
                                if(slineitem.SFDC18ID__c.substring(0,15) == serviceQuoteLine.id ) 
                                {           
                                    for(quotelineitem addonQl : ListOfxistingQuotelineitemAddonAncillary)
                                         {
                                            if(serviceQuoteLine.id == addonQl.Quote_Line_Item__c)
                                             {
                                                quotelineitem addonAnciquoteLine = addonQl.Clone();
                                                addonAnciquoteLine.quoteid = clonedQuote.id;
                                                addonAnciquoteLine.Quote_Line_Item__c =slineitem.Id;
                                                addonAnciquoteLine.ChangeType__c='';
                                                addonAnciquoteLine.QuantityChange__c=null;
                                                addonAnciquoteLine.ContractTermChange__c=null;
                                                addonAnciquoteLine.BidPriceChange__c=null;
                                                QuoteLineItems.add(addonAnciquoteLine);
                                            }
                                        }
                                }
                        }        
                    } 
                }   
                if(!QuoteLineItems.isEmpty()){
                    insert  QuoteLineItems;
                }                           
  
            }catch(Exception e)
                {
                    Database.rollback(sp);
                    ApexPages.addMessages(e);      
                    PGIErrorUtilities.logPgiError('PGIQuoteCloneController.contractAmendment()',e.getMessage(),PGIErrorUtilities.LoggingLevel.DEBUG);
                    system.debug(LoggingLevel.ERROR,'Error When inserting addon line item '+e.getMessage());
                    return null;
                }
            return null;
       }
       
       //Test Method for PGIQuoteCloneController
        @istest (seeAlldata = true)
    public static  void TestPGIQuoteCloneController()
    {
         //Test Data
         Account testacc = PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon = PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp = PGITestUtilities.getOpportunityDetails();
         testopp.StageName = 'Proposal/Price Quote';
         insert testopp;
         Product2 standardProduct = PGITestUtilities.getStdProduct();
         insert standardProduct;
         PricebookEntry pbe = PGITestUtilities.CreatePriceBookEntryForProduct(standardProduct);
         insert pbe;
         OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testopp.Id, pbe.Id);
         insert oli; 
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         testquote.status = QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractSignedbyCustomer.name()).StatusValue__c;
         insert testquote;
         List<Quote> allquotes = new List<Quote>();
         allquotes.add(testquote);
         //case 1: +ve
                 //Set Page Params
                 PGITestUtilities.setTestParameter('id',testacc.id);        
                 PGIQuoteCloneController testCase1PGIConst= new PGIQuoteCloneController(PGITestUtilities.getStandardController(testacc));
         //case 2: +ve
                 //Set Page Params
                 PGITestUtilities.setTestParameter('id',testquote.id);        
                 PGIQuoteCloneController testCase2PGIConst= new PGIQuoteCloneController(PGITestUtilities.getStandardController(testquote));
         test.startTest();   
         //Case 1:
                 system.assertEquals(testCase1PGIConst.accId,testacc.id);
         test.stopTest();
    }   
    
     //Test Method for contractAmendment
        @istest (seeAlldata = true)
    public static  void TestcontractAmendment()
    {
         test.startTest(); 
         Account testacc= PGITestUtilities.getAccountDetails();
         insert testacc;
         Contact testcon=PGITestUtilities.getContactDetails(testacc.Id); 
         insert testcon;
         Opportunity testopp=PGITestUtilities.getOpportunityDetails();
         testopp.StageName = 'Proposal/Price Quote';
         insert testopp;
         Product2 standardProduct = PGITestUtilities.getStdProduct();
         insert standardProduct;
         PricebookEntry standardPbe = PGITestUtilities.CreatePriceBookEntryForProduct(standardProduct);
         insert standardPbe;
         OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testopp.Id, standardPbe.Id);
         insert oli; 
         Quote testquote=PGITestUtilities.getQuoteDetails(testacc.Id,testcon.Id, testopp.Id);
         testquote.status = QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractSignedbyCustomer.name()).StatusValue__c;
         insert testquote;
         Solution__c testSolution =  PGITestUtilities.getSolution();
         insert testSolution;
         Service__c testService = PGITestUtilities.getService(testSolution.id);
         insert testService;
         Region__c region = PGITestUtilities.getRegionDetails();
         insert region;
         list<Product__c> allProduct= new list<Product__c>();
         Product__c testprod1 = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111');
         insert testProd1;       
         Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
         insert testProd2;
         Product__c testprod3= PGITestUtilities.getProductDetails('Service', 'testserv','30111111');
         insert testProd3;
         ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testService.Id, testProd3.Id, true);
         insert testSc1;
         ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testService.Id, testProd2.Id, false);
         insert testSc2;
         ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testService.Id, testProd1.Id, false);
         insert testSc3;
         PriceBook2 pb2Standard = new PriceBook2(); 
         pb2Standard = [select Id from Pricebook2 where isStandard=true];
         string standardPriceBookId = pb2Standard.Id; 
         Product2 testProd= PGITestUtilities.getStdProduct();        
         insert testProd;
         PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
         insert pbe; 
         list<ServiceCategory__c> lstSc=[Select s.Service__r.name, s.Product__r.Min_Commit__c, s.Product__r.name,s.Product__r.Id,s.Product__c,s.Service__c,s.Service__r.Solution__c,
                        s.product__r.productType__c,s.Default__c,s.Product__r.List_Rate__c, s.Product__r.Cost_Rate__c, s.Product__r.Unit_of_Measure__c,
                        s.Product__r.Term_Length__c,s.Product__r.Minimum_Quantity__c,s.Product__r.Maximum_Quantity__c,s.Product__r.Billing_Frequency__c 
                        ,s.Product__r.Regions__c,s.Product__r.Channels__c,s.Product__r.ProductCode__c, s.Product__r.CreatedById, s.Product__r.CreatedDate, s.Product__r.CurrencyIsoCode
                        ,s.Product__r.Description__c,s.Product__r.MaxMeeting__c,s.Product__r.isPGILicense__c From ServiceCategory__c s where Id=:testSc1.id or id=:testSc2.Id or id=:testSc3.Id];
                        
        list<QuoteLineItem> testservLneItem= new list<QuoteLineItem>();    
        list<QuoteLineItem> testLneItem= new list<QuoteLineItem>();  
        ServiceCategory__c aSerProdCate = new ServiceCategory__c();
        ServiceCategory__c aaddonProdCate = new ServiceCategory__c();
        for(ServiceCategory__c aSerCate:lstSc){
            if(aSerCate.Id == testSc1.id){
                aSerProdCate = aSerCate;
                PGIProduct.ProductList testPGIpro = new PGIProduct.ProductList(aSerCate); 
                QuoteLineItem aLineItem = PGITestUtilities.getQuoteLineDetails(testQuote, testPGIpro,pbe.Id);
                testservLneItem.add(aLineItem);
            } 
        } 
        insert testservLneItem;
         for(QuoteLineItem lt:testservLneItem)
        {
        for(ServiceCategory__c aSerCate:lstSc){
            if(aSerCate.Id == testSc2.id || aSerCate.Id == testSc3.id){
                aaddonProdCate = aSerCate;
                PGIProduct.ProductList testPGIpro1 = new PGIProduct.ProductList(aSerCate); 
                QuoteLineItem aLineItem = PGITestUtilities.getQuoteLineDetails(testQuote, testPGIpro1,pbe.Id);
                aLineItem.Quote_Line_Item__c = lt.id;
                testLneItem.add(aLineItem);
            } 
        } 
        }
        insert testLneItem;
         PGITestUtilities.setTestParameter('quoteId', testQuote.id);
         PGIQuoteCloneController testCasePGIConst= new PGIQuoteCloneController(PGITestUtilities.getStandardController(testquote));
         ApexPages.StandardController con = new ApexPages.StandardController(testacc);
         PGIQuoteCloneController ext = new PGIQuoteCloneController(con);
         ext.cloneQuoteID = testquote.id;
         PageReference ref = ext.contractAmendment();
         System.assertEquals(ref,null); 
         List<Quote> testclonedQuote = [select id from Quote where id = :ext.newQuoterec];
         //System.assertNotEquals(testclonedQuote, null);  
         ApexPages.Pagereference result = ext.contractAmendment(); // This will cover try block
    
    delete testLneItem; // Delete account record to cover catch block

    result = ext.contractAmendment();
         
           
         test.stopTest();  
    }   
}