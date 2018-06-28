/********************************************************************************
Name:  QuoteLineItemUtil()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This Utilities used to get QuoteLineItem details and checking quotelineItem is availble for editing
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India          08/10/2012        Added 
**********************************************************************************************/    
public with sharing class QuoteLineItemUtil {

    public static boolean isRecordLocked(Id quoteId){
        boolean isLocked= false;
        if(quoteId!=null) {
            list<ProcessInstanceWorkitem> approveProcslst=[Select p.Id from ProcessInstanceWorkitem p
                                                        where p.ProcessInstance.TargetObjectId =:quoteId limit 1];
            
            Quote updateQuote=[Select Status From Quote where Id=:quoteId];
            if(approveProcslst.size()==1 || updateQuote.status=='Awaiting Co-Signature from VP' 
				|| updateQuote.status == 'Pending Price Approval' 
                || updateQuote.status == QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractSignedbyCustomer.name()).StatusValue__c 
                || updateQuote.status == 'Contract- Waiting for Customer Approval' 
                || updateQuote.status == QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedContractInternalApproval.name()).StatusValue__c 
                || updateQuote.status == 'Submitted quote-Approval' 
                || updateQuote.status == QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedPriceApproval.name()).StatusValue__c
                || updateQuote.status == QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractDocumentGenerated.name()).StatusValue__c 
                || updateQuote.status == QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ReadyforClosedWon.name()).StatusValue__c 
                || updateQuote.status == QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedContractCustomerApproval.name()).StatusValue__c 
                || updateQuote.status == QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ReadyForProvisioning.name()).StatusValue__c) {
                                                    
                isLocked= true;
            }else{
                isLocked= false;
            }                                   
        }
        return isLocked;                                                        
    }
    public static boolean deleteQuoteLineItems(set<Id> quoteLineItems){
        if(quoteLineItems!=null){
        
            list<QuoteLineItem> Qlitems =new list<QuoteLineItem>();
            Qlitems=[select PricebookEntry.Name ,BidPrice__c,TotalPrice,UnitPrice,Quantity,Quantity__c,id,QuoteId from QuoteLineItem where Id in :quoteLineItems];
            if(Qlitems.size()>0){
                delete   Qlitems;
            }
            return true;
        }
        return false;
    }
    
    public static boolean deleteServiceQuoteLineItems(set<Id> quoteLineItems){
        if(quoteLineItems!=null){
        
            list<QuoteLineItem> Qlitems =new list<QuoteLineItem>();
            Qlitems=[select PricebookEntry.Name ,BidPrice__c,TotalPrice,UnitPrice,Quantity,Quantity__c,id,QuoteId from QuoteLineItem where Id in :quoteLineItems or Quote_Line_Item__c in :quoteLineItems];
            if(Qlitems.size()>0){
                delete   Qlitems;
            }
            return true;
        }
        return false;
    }
    
    public static list<PGIProduct.ProductList> getAllProductDetails(Id quoteId ){
        system.debug('$$$Entry');
        list<PGIProduct.ProductList> quoteDetail  = new list<PGIProduct.ProductList>();      
        list<Product__c>    productDetail = new list<Product__c>();   
        list<QuoteLineItem> quotelineItemList = new list<quotelineItem >();                 
        set<Id> setOfLineItemId = new set<Id>();    
        Map<Id, Product__c> MapProducts= new Map<Id, Product__c>();                     
        set<Id> setOfProductId = new set<Id>(); 
        set<Id> setOfServiceId = new set<Id>(); 
        Map<Id, list<ServiceCategory__c>> MapServices= new Map<Id, list<ServiceCategory__c>>(); 
        
        quotelineItemList = [select id,BidPrice__c,Quantity,Quantity__c,QuoteId,UnitPrice,Product__c,Service__c,Product__r.name,Service__r.Name,Quote_Line_Item__c,TotalPrice__c,RowId__c,Approval_Status__c ,Approval_Level__c, Line_Margin_Over_Term__c ,ContractTermChange__c,BidPriceChange__c,QuantityChange__c,ChangeType__c,Contract_Term__c,Contract_Value__c, Annual_value__c,MRR__c from QuoteLineItem  where QuoteId =: quoteId order by rowid__c, Service__c, Quote_Line_Item__c];
        
        User currentUser=[Select  Level_Of_Authority__c From User where Id =:UserInfo.getUserId()];
        
        productDetail = [select Name,Minimum_Quantity__c,Addon_Feature_Name_External__c, Id, Auth_Rate1__c,maxmeeting__c, Auth_Rate2__c, Auth_Rate3__c, Auth_Rate4__c, Auth_Rate5__c , ProductType__c, Auth_Rate6__c , Unit_Of_Measure__c,isPGILicense__c,Quantity__c, List_Rate__c,Target_Price__c, Bid_Price__c , Meet_Authority_Level__c ,Authority_Level__c,Add__c,SubscriptionTerms__c,
                         Billing_Frequency__c ,Term_Length__c,Cost_Rate__c,Description__c,ContractDocumentGroup__c, Non_License_ContractDocumentGroup__c
                                from Product__c  where Id IN (select Product__c from QuoteLineItem where QuoteId =:quoteId)]; 
                                
        for (Product__c product : productDetail ){              
            MapProducts.put(product.Id,product);        
            setOfProductId.add(product.Id);
        }
        
        
        
        Map<Id,list<QuoteLineItem>> mapQuoteLineItem = new Map<Id,list<QuoteLineItem>>();
        for(QuoteLineItem  quoteLine : quotelineItemList)
        {
            setOfServiceId.add(quoteLine.service__c); 
            if(quoteLine.service__c==null || quoteLine.service__r.Name==quoteLine.product__r.Name){
                list<quoteLineItem> allQuoteLines = new list<quoteLineItem>();          
                allQuoteLines.add(quoteline);
                mapQuoteLineItem.put(quoteLine.id,allQuoteLines);
            }           
        }
        
        for(ServiceCategory__c aServiceCat: [Select s.Service__r.name,s.Name,s.Default__c , s.service__r.Solution__c, s.Product__r.Min_Commit__c, s.Product__r.Name , s.Product__r.Id ,s.Product__r.Cost_Rate__c ,s.Product__c From ServiceCategory__c s where s.Service__r.Id =:setOfServiceId ]){
            list<ServiceCategory__c>    allServiceCatelst = new list<ServiceCategory__c>();
            if(MapServices.get(aServiceCat.Service__c)!=null){
                allServiceCatelst=  MapServices.get(aServiceCat.Service__c);
            }
            allServiceCatelst.add(aServiceCat);
            MapServices.put( aServiceCat.Service__c,allServiceCatelst);     
        }
        for(QuoteLineItem  quoteLine : quotelineItemList){          
            if(quoteLine.service__r.Name !=quoteLine.product__r.Name && mapQuoteLineItem.get(quoteLine.Quote_Line_Item__c)!=null){  
                    list<quoteLineItem> allQuoteLines = new list<quoteLineItem>();          
                    allQuoteLines= mapQuoteLineItem.get(quoteLine.Quote_Line_Item__c);
                    allQuoteLines.add(quoteline);           
                    mapQuoteLineItem.put(quoteLine.Quote_Line_Item__c,allQuoteLines);                   
            }           
        }
        
        for(list<quoteLineItem>alQuoteLinewithOrder : mapQuoteLineItem.Values()){
        for(QuoteLineItem  quoteLine : alQuoteLinewithOrder)
        {
            if(MapProducts.get(quoteLine.Product__c)!=null && MapServices.get(quoteLine.Service__c) !=null){
                ServiceCategory__c proServiceCate= new ServiceCategory__c();
                for(ServiceCategory__c aService:MapServices.get(quoteLine.Service__c)){
                    if(aService.Service__c==quoteLine.Service__c && aService.Product__c == quoteLine.Product__c){
                        proServiceCate = aService;
                    }
                }
                PGIProduct.ProductList newquoteDetail = new PGIProduct.ProductList(MapProducts.get(quoteLine.Product__c) ,quoteLine,currentUser.Level_Of_Authority__c,proServiceCate);                              
                quoteDetail.add(newquoteDetail);
            }
        } 
        }
        return quoteDetail;
    }


       
        public static map<Id,list<PGIContractProductDetails.Verbiage>> getMapVerb(Id quoteId ){
        list<PGIProduct.ProductList> quoteDetail  = new list<PGIProduct.ProductList>();      
        list<Product__c>    productDetail = new list<Product__c>();   
        list<Add_on_FeatureContractTerms__c>    VerbiageDetail = new list<Add_on_FeatureContractTerms__c>();      
        list<PGIContractProductDetails.Verbiage> prodContractTermsLst = new list<PGIContractProductDetails.Verbiage>();
        list<QuoteLineItem> quotelineItemList = new list<quotelineItem >();                 
        set<Id> setOfLineItemId = new set<Id>();    
        Map<Id, Product__c> MapProducts= new Map<Id, Product__c>();                     
        set<Id> setOfProductId = new set<Id>(); 
        set<Id> setOfServiceId = new set<Id>(); 
        Map<Id, list<ServiceCategory__c>> MapServices= new Map<Id, list<ServiceCategory__c>>(); 
        
        quotelineItemList = [select id,BidPrice__c,Quantity,Quantity__c,QuoteId,UnitPrice,Product__c,Service__c,Product__r.name,Service__r.Name,Quote_Line_Item__c,TotalPrice__c,RowId__c,Approval_Status__c ,Approval_Level__c, Line_Margin_Over_Term__c ,ContractTermChange__c,BidPriceChange__c,QuantityChange__c,ChangeType__c,Contract_Term__c ,Contract_Value__c, Annual_value__c,MRR__c from QuoteLineItem  where QuoteId =: quoteId order by rowid__c, Service__c, Quote_Line_Item__c];
        
        productDetail = [select Name,Minimum_Quantity__c,Addon_Feature_Name_External__c, Id,add__c, Auth_Rate1__c, Auth_Rate2__c, Auth_Rate3__c, Auth_Rate4__c, Auth_Rate5__c , ProductType__c, Auth_Rate6__c , Unit_Of_Measure__c,isPGILicense__c,Quantity__c, List_Rate__c,Target_Price__c, Bid_Price__c , Meet_Authority_Level__c ,Authority_Level__c,
                         Billing_Frequency__c ,maxmeeting__c,Term_Length__c,Cost_Rate__c,Description__c,ContractDocumentGroup__c, Non_License_ContractDocumentGroup__c
                                from Product__c  where Id IN (select Product__c from QuoteLineItem where QuoteId =:quoteId) ];
        
        for (Product__c product : productDetail ){              
            MapProducts.put(product.Id,product);        
            setOfProductId.add(product.Id);
        }
       
       
        VerbiageDetail=[Select Contract_Term__r.Terms_and_Conditions__c, 
                                                                          Contract_Term__r.Name, Contract_Term__c, Add_on_Feature__r.Name,Add_on_Feature__c,Add_on_Feature__r.ContractDocumentGroup__c ,Add_on_Feature__r.ProductType__c From Add_on_FeatureContractTerms__c 
                                                                          where Add_on_Feature__c In:setOfProductId];
        
        for(Add_on_FeatureContractTerms__c averbiage:VerbiageDetail){
            PGIContractProductDetails.Verbiage verbiageTerms= new PGIContractProductDetails.Verbiage(averbiage);
            prodContractTermsLst.add(verbiageTerms);
            
        }
        
       //map key product id with verbiage details
        map<Id,list<PGIContractProductDetails.Verbiage>> verbiageWrapperMap= new map<Id,list<PGIContractProductDetails.Verbiage>>();
        list<PGIContractProductDetails.Verbiage> verbiageWrapLst= new list<PGIContractProductDetails.Verbiage>();
        for(PGIContractProductDetails.Verbiage termsLst:prodContractTermsLst){
            if(verbiageWrapperMap.get(termsLst.productId)==null){
                verbiageWrapLst= new list<PGIContractProductDetails.Verbiage>();
            }else{
                verbiageWrapLst=verbiageWrapperMap.get(termsLst.productId);
            }
            verbiageWrapLst.add(termsLst);
            verbiageWrapperMap.put(termsLst.productId,verbiageWrapLst);
        }
        return verbiageWrapperMap;
        
        }
        
       
        public static map<string,set<string>> getverbgrpmap(Id quoteId ){
        list<PGIProduct.ProductList> quoteDetail  = new list<PGIProduct.ProductList>();      
        list<Product__c>    productDetail = new list<Product__c>();   
        list<Add_on_FeatureContractTerms__c>    VerbiageDetail = new list<Add_on_FeatureContractTerms__c>();
        list<PGIContractProductDetails.Verbiage> prodContractTermsLst = new list<PGIContractProductDetails.Verbiage>();
        list<QuoteLineItem> quotelineItemList = new list<quotelineItem >();                 
        set<Id> setOfLineItemId = new set<Id>();    
        Map<Id, Product__c> MapProducts= new Map<Id, Product__c>();                     
        set<Id> setOfProductId = new set<Id>(); 
        set<Id> setOfServiceId = new set<Id>(); 
        Map<Id, list<ServiceCategory__c>> MapServices= new Map<Id, list<ServiceCategory__c>>(); 
        
        quotelineItemList = [select id,BidPrice__c,Quantity,Quantity__c,QuoteId,UnitPrice,Product__c,Service__c,Product__r.name,Product__r.MaxMeeting__c,Service__r.Name,Quote_Line_Item__c,TotalPrice__c,RowId__c,Approval_Status__c ,Approval_Level__c, Line_Margin_Over_Term__c ,ContractTermChange__c,BidPriceChange__c,QuantityChange__c,ChangeType__c,Contract_Term__c ,Contract_Value__c, Annual_value__c,MRR__c from QuoteLineItem  where QuoteId =: quoteId order by rowid__c, Service__c, Quote_Line_Item__c];
        
        
        
        productDetail = [select Name,Minimum_Quantity__c,Id,MaxMeeting__c,Addon_Feature_Name_External__c, Auth_Rate1__c, Auth_Rate2__c, Auth_Rate3__c,Auth_Rate4__c, Auth_Rate5__c ,Add__c, ProductType__c, Auth_Rate6__c , Unit_Of_Measure__c,isPGILicense__c,Quantity__c, List_Rate__c,Target_Price__c, Bid_Price__c , Meet_Authority_Level__c ,Authority_Level__c,
                         Billing_Frequency__c ,Term_Length__c,Cost_Rate__c,Description__c,ContractDocumentGroup__c
                                from Product__c  where Id IN (select Product__c from QuoteLineItem where QuoteId =:quoteId) ]; 
        
        for (Product__c product : productDetail ){              
            if(product.ProductType__c=='Service'){
            MapProducts.put(product.Id,product);        
            setOfProductId.add(product.Id);
            }
        }
       
       
        VerbiageDetail=[Select Contract_Term__r.Terms_and_Conditions__c, 
                                                                          Contract_Term__r.Name, Contract_Term__c, Add_on_Feature__r.Name,Add_on_Feature__c,Add_on_Feature__r.ContractDocumentGroup__c ,Add_on_Feature__r.ProductType__c From Add_on_FeatureContractTerms__c 
                                                                          where Add_on_Feature__c In:setOfProductId];
        
        for(Add_on_FeatureContractTerms__c averbiage:VerbiageDetail){
            PGIContractProductDetails.Verbiage verbiageTerms= new PGIContractProductDetails.Verbiage(averbiage);
            prodContractTermsLst.add(verbiageTerms);
            
        }
        
        
        
        map<string,set<string>> Grpverbiagemap= new map<string,set<string>>();
        set<string> verbiageWrapLst= new set<string>();
        for(PGIContractProductDetails.Verbiage termsLst:prodContractTermsLst){
            if(Grpverbiagemap.get(termsLst.contractdocumentgroup)==null){
                verbiageWrapLst= new set<string>();
            }else{
                verbiageWrapLst=Grpverbiagemap.get(termsLst.contractdocumentgroup);
            }
            verbiageWrapLst.add(termsLst.termsConditions);
            Grpverbiagemap.put(termsLst.contractdocumentgroup,verbiageWrapLst);
       List<String> sortThis = new List<String>(Grpverbiagemap.keyset());
       sortthis.sort();
           
       
       
        }
        return Grpverbiagemap;
        
        }
        
    @IsTest(SeeAlldata=true)
    private  static void test_IsRecordLocked(){
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Product2 standardProduct = PGITestUtilities.getStdProduct();
        insert standardProduct;
        PricebookEntry pbe = PGITestUtilities.CreatePriceBookEntryForProduct(standardProduct);
        insert pbe;
        OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe.Id);
        insert oli; 
        Opportunity testOpp2= PGITestUtilities.getOpportunityDetails();
        testOpp2.Name='Case2';      
        insert testOpp2;
        OpportunityLineItem oli2 = PGITestUtilities.getOpportunityLineItemDetails(testOpp2.Id, pbe.Id);
        insert oli2; 
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        cont.email='hsoni@salesforce.com';
        cont.title='mr';
        insert cont;
        //Case 1: 
        Quote testQuoteCase1= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        testQuoteCase1.Status= QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractSignedbyCustomer.name()).StatusValue__c;
        insert testQuoteCase1;
        Boolean case1Status;
        //Case 2: 
        Quote testQuoteCase2= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp2.Id); 
        testQuoteCase2.Status='Quote-InProgress';
        insert testQuoteCase2;
        Boolean case2Status;
        test.startTest();
        //Case 1
            case1Status = QuoteLineItemUtil.isRecordLocked(testQuoteCase1.Id);
        //Case 2
            case2Status = QuoteLineItemUtil.isRecordLocked(testQuoteCase2.Id);
        test.stopTest();
        //Assert
        system.assertEquals(case1Status,true);
        system.assertEquals(case2Status,false);     
    }
    @IsTest(SeeAlldata=true)
    private static void test_DeleteQuoteLineItems(){
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        cont.email='hsoni@salesforce.com';
        cont.title='mr';
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1= PGITestUtilities.getProductDetails('Service','testservice','30111111');
        insert testProd1;       
        
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, true);
        insert testSc1;     
            
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        
        Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd;
        // set up PricebookEntry and Verify that the results are as expected.
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;         
        ServiceCategory__c aSerCate=[Select s.Service__r.name, s.Product__r.Min_Commit__c, s.Product__r.name,s.Product__r.Id,s.Product__c,s.Service__c,s.Service__r.Solution__c,
                        s.product__r.productType__c,s.Default__c,s.Product__r.isPGILicense__c,s.Product__r.MaxMeeting__c, s.Product__r.List_Rate__c, s.Product__r.Cost_Rate__c, s.Product__r.Unit_of_Measure__c,
                        s.Product__r.Term_Length__c,s.Product__r.Minimum_Quantity__c,s.Product__r.Maximum_Quantity__c,s.Product__r.Billing_Frequency__c 
                        ,s.Product__r.Channels__c, s.Product__r.Regions__c, s.Product__r.ProductCode__c, s.Product__r.CreatedById, s.Product__r.CreatedDate, s.Product__r.CurrencyIsoCode
                        ,s.Product__r.Description__c From ServiceCategory__c s where Id=:testSc1.id];
        PGIProduct.ProductList testPGIpro= new PGIProduct.ProductList(aSerCate);
        
        //Case 1:
       //Insert the QuoteLineItem
        QuoteLineItem case1QuoteLine = PGITestUtilities.getQuoteLineDetails(testQuote, testPGIpro,pbe.Id); 
        insert case1QuoteLine;      
        Boolean testCase1LineItem;
        //Case 2: -ve case
        //pass null value
        Boolean testCase2LineItem;
        test.startTest();
            //case 1:
            testCase1LineItem = QuoteLineItemUtil.deleteQuoteLineItems(new set<Id> {case1QuoteLine.Id});
            //case 2:
            testCase2LineItem = QuoteLineItemUtil.deleteQuoteLineItems(null);
        test.stopTest();
        
        //Case 1 assert:        
        system.assertEquals(testCase1LineItem,true);
        //Case 2:
        system.assertEquals(testCase2LineItem,false);   
    set<id>qtest=new set<id>();
      // id temp=[select id from quotelineitem where quoteid=:testquote.id limit 1].id;
       qtest.add(case1QuoteLine.id);
    QuoteLineItemUtil.deleteServiceQuoteLineItems(qtest);
    }
    @IsTest(SeeAlldata=true)
    private static void  test_getAllProductDetails(){   
        //Testdata preparation-Users
        User testUser1=PGITestUtilities.getTestUser(PGITestUtilities.getAdminProfile());
        testUser1.firstName='TestUser1';
        testUser1.Level_Of_Authority__c='Level 1';
        insert testUser1;
        
        Account testAcc= PGITestUtilities.getAccountDetails();
        insert testAcc;
        Opportunity testOpp= PGITestUtilities.getOpportunityDetails();      
        insert testOpp;
        Contact cont= PGITestUtilities.getContactDetails(testAcc.Id); 
        cont.email='hsoni@salesforce.com';
        cont.title='mr';
        insert cont;
        Quote testQuote= PGITestUtilities.getQuoteDetails(testAcc.Id, cont.Id ,testOpp.Id); 
        insert testQuote;
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
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testProd2.Id, true);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1.Id, true);
        insert testSc3;
            
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        
        Product2 testProd= PGITestUtilities.getStdProduct();
        
        insert testProd;
        // set up PricebookEntry and Verify that the results are as expected.
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;         
        list<ServiceCategory__c> lstSc=[Select s.Service__r.name, s.Product__r.Min_Commit__c, s.Product__r.name,s.Product__r.Id,s.Product__c,s.Service__c,s.Service__r.Solution__c,
                        s.product__r.productType__c,s.Default__c,s.Product__r.isPGILicense__c,s.Product__r.MaxMeeting__c, s.Product__r.List_Rate__c, s.Product__r.Cost_Rate__c, s.Product__r.Unit_of_Measure__c,
                        s.Product__r.Term_Length__c,s.Product__r.Minimum_Quantity__c,s.Product__r.Maximum_Quantity__c,s.Product__r.Billing_Frequency__c 
                        ,s.Product__r.Channels__c, s.Product__r.Regions__c, s.Product__r.ProductCode__c, s.Product__r.CreatedById, s.Product__r.CreatedDate, s.Product__r.CurrencyIsoCode
                        ,s.Product__r.Description__c From ServiceCategory__c s where Id=:testSc1.id or id=:testSc2.Id or id=:testSc3.Id];
        list<QuoteLineItem> testLneItem= new list<QuoteLineItem>();
        set<QuoteLineItem>testid=new set<QuoteLineItem>();
        ServiceCategory__c aSerProdCate = new ServiceCategory__c();
        for(ServiceCategory__c aSerCate:lstSc){
            if(aSerCate.Id==testSc1.id){
                aSerProdCate = aSerCate;
            } else{
                PGIProduct.ProductList testPGIpro= new PGIProduct.ProductList(aSerCate);            
                //Insert the QuoteLineItem
                QuoteLineItem aLineItem = PGITestUtilities.getQuoteLineDetails(testQuote, testPGIpro,pbe.Id); 
                testLneItem.add(aLineItem);
            testid.add(aLineItem);
            }
        }
        PGIProduct.ProductList testPGIpro= new PGIProduct.ProductList(aSerProdCate);            
        //Insert the QuoteLineItem
        QuoteLineItem testserLneItem = PGITestUtilities.getQuoteLineDetails(testQuote, testPGIpro,pbe.Id); 
       
       //Case 1:
        list<PGIProduct.ProductList> testCase1ProductLst = new list<PGIProduct.ProductList>();
        test.startTest();
        system.runAs(testUser1) {
            insert testserLneItem;
            list<QuoteLineItem> testQuotelne= new list<QuoteLineItem>();
            for(QuoteLineItem aLineItem : testLneItem){
                aLineItem.Quote_Line_Item__c=testserLneItem.id;
                aLineItem.service__c=testSer.Id;
                testQuotelne.add(aLineItem);
            }
            insert testQuotelne;
            testCase1ProductLst = QuoteLineItemUtil.getAllProductDetails(testQuote.Id);
            test.stopTest();
        }
        //Case 1 assert:
        list<quoteLineItem> testcaseLineItem= [select Id from QuoteLineItem where QuoteId =:testQuote.Id];
        system.assertEquals(testcaseLineItem.size(),3);
        system.assertEquals(testCase1ProductLst.size(),3);  
    
     map<Id,list<PGIContractProductDetails.Verbiage>> testCase2ProductLst = new  map<Id,list<PGIContractProductDetails.Verbiage>>();
      
        system.runAs(testUser1) {
          
            testCase2ProductLst = QuoteLineItemUtil.getMapVerb(testQuote.Id);
       //     test.stopTest();
       
       }
        map<string,set<string>> testCase3ProductLst = new  map<string,set<string>>();
      
        system.runAs(testUser1) {
          
            testCase3ProductLst = QuoteLineItemUtil.getverbgrpmap(testQuote.Id);
       
        }
    
    }
}