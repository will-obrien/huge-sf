/********************************************************************************
Name:  PgiQuoteDetailsController()
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
public with sharing class PgiQuoteDetailsController {
    public string quoteId {get ;set;}      
    public set<Id> quoteLineItemIds {get; set;}
    public set<Id> addedProducts {get; set;}
    public set<Id> ancillaryProductIds {get; set;}
    public list<PGIProduct>ProdConfigDetails{get;set;}
    public list<Id> Addproducts {get;set;}
    public string selectedQuoteLineItemId {get; set;}       
    public boolean isCancelled {get; set;}
    public decimal selectedRowId {get; set;}   
    public decimal latestRowId {get; set;}  
    public string deleteQuoteLineId {get;set;}
    
    public PgiQuoteDetailsController() {
        try{            
            quoteId = Apexpages.currentPage().getParameters().get('quoteId');
            string strQuoteLineItemId= Apexpages.currentPage().getParameters().get('quoteLineIds');
            quoteLineItemIds = new set<Id>();
            strQuoteLineItemId = strQuoteLineItemId.substring(1, strQuoteLineItemId.Length()-1);
            if(strQuoteLineItemId != null && strQuoteLineItemId != ''){
                    list<String> listIds = new list<String>();
                    listIds = strQuoteLineItemId.split(',');
                    for(string str : listIds){
                            if(Str != null && Str != '' ){
                                quoteLineItemIds.add(Id.ValueOf(Str.trim()));        
                            }
                    }
            }
            ProdConfigDetails = QuoteSelectionUtilities.getConfigureServiceUsage(quoteLineItemIds, quoteId);
            for(PGIProduct aProduct:ProdConfigDetails)  {   
                latestRowId= aProduct.latestRowId;
            }
      
        }
        catch(exception e){
            system.debug('exception'+ e);
        }
    }   

    public PageReference AddAditionalProducts() {
        try
        {   
            list<PGIProduct.ProductList> addNewProd= new list<PGIProduct.ProductList> ();
            list<selectOption> newProductOptions= new list<SelectOption>();
            set<id> addedProductLst = new set<id>();
            set<Id> ServiceIds = new set<Id>(); 
            
            for(PGIProduct addProduct: ProdConfigDetails){
                if( addProduct.quoteLineItemId == selectedQuoteLineItemId){
                    ServiceIds.add(addProduct.serviceId);
                    Addproducts= addProduct.addedProducts;
                }
            }
            for(Id aproductOption:Addproducts){                     
                addedProductLst.add(aproductOption);
            }
            for(PGIProduct addProduct: ProdConfigDetails){
                if( addProduct.quoteLineItemId == selectedQuoteLineItemId){                      
                    for(selectOption aProduct :addProduct.productOptions){
                        if(!addedProductLst.contains(aProduct.getValue())){
                            newProductOptions.add(aProduct);
                        }
                    }                       
                    addProduct.productOptions=newProductOptions;                            
                }
            }
            list<PGIProduct> newproddetails=QuoteSelectionUtilities.getAdditionalUsage(ServiceIds, Addproducts,latestRowId);    
            for(PGIProduct newP: newproddetails){
                latestRowId= newP.latestRowId;
                addNewProd  =newP.productLst;           
            }  
            
            for(PGIProduct newProdAdd: ProdConfigDetails){
                for(PGIProduct.ProductList finalProd: addNewProd  ){
                    if(newProdAdd.quoteLineItemId== selectedQuoteLineItemId && newProdAdd.serviceId==finalProd.serviceId ){
                        finalProd.masterServiceId = selectedQuoteLineItemId;
                        newProdAdd.productLst.add(finalProd);
                    }
                }       
            }       
            if( addProducts!=null && addProducts.size()>0) {            
                for(id productId: addProducts){
                    if(addedProducts==null) addedProducts = new set<Id>();
                    addedProducts.add(productId);
                } 
            }
        }
        catch(Exception ex){
            PGIErrorUtilities.logPgiError('PgiQuoteDetailsController:AddAditionalProducts()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When adding additional products '+ex.getMessage());
        }   
        return null;
    }   
    
    
    public PageReference AddAncillaryProducts() {
        try
        {
         list<PGIProduct.ProductList> addNewProd= new list<PGIProduct.ProductList> ();
        list<selectOption> newProductOptions= new list<SelectOption>();
        list<selectOption> newAncillaryOptions= new list<SelectOption>();
        set<id> addedProductLst = new set<id>();
        
        set<Id> ServiceIds = new set<Id>(); 
        for(PGIProduct addProduct: ProdConfigDetails){
            if( addProduct.quoteLineItemId == selectedQuoteLineItemId){
                ServiceIds.add(addProduct.serviceId);
                Addproducts= addProduct.ancillaryProducts;
            }
        }
        for(Id aproductOption:Addproducts){                     
            addedProductLst.add(aproductOption);
        }
        for(PGIProduct addProduct: ProdConfigDetails){
            if( addProduct.quoteLineItemId == selectedQuoteLineItemId){                      
                for(selectOption aProduct :addProduct.ancillaryOptions){
                    if(!addedProductLst.contains(aProduct.getValue())){
                        newAncillaryOptions.add(aProduct);
                    }
                }                       
                addProduct.ancillaryOptions=newAncillaryOptions;                            
            }
        }
        list<PGIProduct> newproddetails=QuoteSelectionUtilities.getAdditionalUsage(ServiceIds, Addproducts, latestRowId);   
        for(PGIProduct newP: newproddetails){
            latestRowId= newP.latestRowId;
            addNewProd  =newP.productLst;           
        }  
        
        for(PGIProduct newProdAdd: ProdConfigDetails){
            for(PGIProduct.ProductList finalProd: addNewProd  ){
                if(newProdAdd.quoteLineItemId== selectedQuoteLineItemId && newProdAdd.serviceId==finalProd.serviceId ){
                    finalProd.masterServiceId = selectedQuoteLineItemId;
                    newProdAdd.productLst.add(finalProd);
                }
            }       
        }       
        if( addProducts!=null && addProducts.size()>0) {            
            for(id productId: addProducts){
                if(ancillaryProductIds==null) ancillaryProductIds = new set<Id>();
                ancillaryProductIds.add(productId);
            } 
        }
    }
        catch(Exception ex){
            PGIErrorUtilities.logPgiError('PgiQuoteDetailsController:AddAncillaryProducts()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When adding ancillary products '+ex.getMessage());
        }   
        return null;
    }
        
    public PageReference deletelineItem()
     {
     try
        {
        list<PGIProduct> updatedLst= new list<PGIProduct>();
        if(selectedRowId!=null){ 
            set<Id> selectedMasterQuoteLineId = new set<Id>();
            set<Id> SetQuoteLineIds= new set<Id>();
            string serQuoteLineId;
            if(deleteQuoteLineId!=null){                
                for(PGIProduct aProdlst: ProdConfigDetails){                
                    for(PGIProduct.ProductList finalProd: aProdlst.productLst){                     
                        if(finalProd.customRowId == selectedRowId && finalProd.isServiceProduct && finalProd.quoteLineItemId == Id.valueOf(deleteQuoteLineId)){                       
                            selectedMasterQuoteLineId.add(finalProd.quoteLineItemId);
                            serQuoteLineId = finalProd.quoteLineItemId;                 
                            break;                       
                        } 
                 }
                }
            }               
            for(PGIProduct aProdlst: ProdConfigDetails){ 
                list<PGIProduct.ProductList > lstProds= new list<PGIProduct.ProductList>();
                if(aProdlst.quoteLineItemId!=serQuoteLineId){
                    for(PGIProduct.ProductList finalProd: aProdlst.productLst){
                    
                        if(selectedRowId != finalProd.customRowId  ){  lstProds.add(finalProd);
                        }else{                                           
                             if(finalProd.quoteLineItemId!=null){                               
                                if(deleteQuoteLineId!=null && deleteQuoteLineId!='' && finalProd.quoteLineItemId==deleteQuoteLineId){
                                    SetQuoteLineIds.add(finalProd.quoteLineItemId);
                                    if(finalProd.productType=='Ancillary'){
                                        if(ancillaryProductIds==null) ancillaryProductIds = new set<Id>();
                                        ancillaryProductIds.add(finalProd.productId);
                                    }else if(finalProd.productType=='Add-on'){
                                        if(addedProducts==null) addedProducts = new set<Id>();
                                        addedProducts.add(finalProd.productId);
                                    }   
                                }                       
                             } 
                             system.debug('#D'+addedProducts);
                    
                            if(ancillaryProductIds!=null&& ancillaryProductIds.contains(finalProd.productId)){ 
                                aProdlst.ancillaryOptions.add( new selectOption(finalProd.productId,finalProd.ProductName));
                                ancillaryProductIds.remove(finalProd.productId);
                            } else if(addedProducts!=null&& addedProducts.contains(finalProd.productId)){
                                aProdlst.productOptions.add( new selectOption(finalProd.productId,finalProd.ProductName));
                                addedProducts.remove(finalProd.productId);                          
                            }
                        }
                    }   
                    aProdlst.productlst= new list<PGIPRoduct.ProductList>();
                    aProdlst.productlst =   lstProds;
                    updatedLst.add(aProdlst);
                }
            }
            if(serQuoteLineId!=null){
                QuoteLineItemUtil.deleteServiceQuoteLineItems(selectedMasterQuoteLineId);
            } else {
                QuoteLineItemUtil.deleteQuoteLineItems(SetQuoteLineIds);
            }  
        }            
        ProdConfigDetails = new list<PGIProduct>();
        ProdConfigDetails = updatedlst;
        }catch(Exception ex){
            PGIErrorUtilities.logPgiError('PgiQuoteDetailsController:deletelineItem()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When deleting line item '+ex.getMessage());
        }   
            
        return null;
    }   
    
    /**********************************************************************
    Configure service to existing QuoteLineItem
    *********************************************************************/
                
    public PageReference updateServices() {
        try
        {
	    	List<String> quantities = new List<String>();
        	if(QuoteSelectionUtilities.hasNegativeMinCommitQuantity(ProdConfigDetails, quantities))
            {
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, String.format(system.label.Min_Commit_Quantity_Error, quantities));
            	ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.FATAL, String.format(system.label.Min_Commit_Quantity_Error_2, quantities));
                Apexpages.addMessage(myMsg); 
                Apexpages.addMessage(myMsg2); 
                isCancelled=false; 
            }
            else
            {
		        Boolean status = QuoteSelectionUtilities.configureQuoteLineItem(ProdConfigDetails,quoteId );
		        if(!status){
		            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter valid input data');
		            myMsg.getComponentLabel();
		            Apexpages.addMessage(myMsg); 
		            isCancelled=false;  
		        }else{
		            isCancelled=true; 
		        }
            }
        }catch(Exception ex){
            PGIErrorUtilities.logPgiError('PgiQuoteDetailsController:updateServices()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When updating service '+ex.getMessage());
        }   
        return ApexPages.currentPage();        
    }
    //Test Methods
     @istest(seeAlldata=true) 
     private static void test_pgiQuoteDetailsController(){
        
        Test.setCurrentPage(Page.PgiQuoteDetails);
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
        Product__c testprod1 = PGITestUtilities.getProductDetails('Service','TestAddon','10111111');
        insert testProd1;       
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary','TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Add-on','testserv','30111111');
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
        
        list<QuoteLineItem> quotelst=[Select q.UnitPrice, q.Service__c, q.QuoteId, q.Quantity, q.Product__c, q.PricebookEntry.Name, q.PricebookEntryId, q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testQuote.Id];
        set<Id> quoItemid=new set<Id>();
        string quoteItemIds;
        for(quoteLineItem quoItem:quotelst){
         quoItemid.add(quoItem.Id);
         if(quoteItemIds!=null)
         quoteItemIds=quoteItemIds+',';
         quoteItemIds=quoteItemIds+quoItem.Id;
        }
        PGITestUtilities.setTestParameter('quoteId', testQuote.Id);
        PGITestUtilities.setTestParameter('quoteLineIds',quoteItemIds);
        PgiQuoteDetailsController proSelcon=new PgiQuoteDetailsController();
        test.startTest();
    //    system.assertNotEquals(proSelcon.ProdConfigDetails.size(),0);  
        test.stopTest ();
     }
     @istest(seeAlldata=true) 
   private static void test_AddAditionalProducts(){
   
        
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
        Product__c testprod1= PGITestUtilities.getProductDetails('Service', 'testserv','30111111');
        testprod1.Term_Length__c=1;
        insert testProd1;
        Product__c testprod1addon = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111') ;
        insert testprod1addon;      
        Product__c testprod1Ancillary = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
        insert testProd1Ancillary;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testprod1.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testprod1addon.Id, false);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1Ancillary.Id, false);
        insert testSc3;
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;
        OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe.Id);
        insert oli;    
        QuoteLineItem testquoteLineItem3=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
        insert testquoteLineItem3; 
        QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod1addon.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem3.Id);
        testquoteLineItem2.Quote_Line_Item__c=testquoteLineItem3.id;
        insert testquoteLineItem2;
        QuoteLineItem testquoteLineItem1=PGITestUtilities.getTestQuoteLineItem (testProd1Ancillary.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem3.Id);
        testquoteLineItem1.Quote_Line_Item__c=testquoteLineItem3.id;
        insert testquoteLineItem1;
        PageReference pref=Page.PgiQuoteDetails;
        Test.setCurrentPage(pref);
        Set<Id> allQuoteLineItems= new Set<Id>();
        allQuoteLineItems.add(testquoteLineItem3.Id);
        allQuoteLineItems.add(testquoteLineItem2.Id);
        allQuoteLineItems.add(testquoteLineItem1.Id);
        PGITestUtilities.setTestParameter('quoteId', testQuote.Id);
        PgiQuoteDetailsController con= new PgiQuoteDetailsController();
        con.quoteId=testQuote.Id;
        con.quoteLineItemIds= allQuoteLineItems;  
        con.ProdConfigDetails = QuoteSelectionUtilities.getConfigureServiceUsage(con.quoteLineItemIds,con.quoteId);
        con.selectedQuoteLineItemId=testquoteLineItem3.id; 
        list<Id> Addproducts=new list<Id>();
        Addproducts.add(testprod1addon.Id);
        for(PGIProduct pgiPro:con.ProdConfigDetails)
        pgiPro.addedProducts=Addproducts; 
        con.AddAditionalProducts();
        system.assertNotEquals(con.ProdConfigDetails.size(),0);  
        system.assertNotEquals(con.addedProducts.size(),0);  
        
    
   }
    @istest(seeAlldata=true)
   private static void test_AddAncillaryProducts(){
   
       
        test.startTest();
        Test.setCurrentPage(Page.PgiQuoteDetails);
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
        Product__c testprod1= PGITestUtilities.getProductDetails('Service', 'testserv','30111111');
        testprod1.Term_Length__c=1;
        insert testProd1;
        Product__c testprod1addon = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111') ;
        insert testprod1addon;      
        Product__c testprod1Ancillary = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
        insert testProd1Ancillary;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testprod1.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testprod1addon.Id, false);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1Ancillary.Id, false);
        insert testSc3;
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;
        OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe.Id);
        insert oli;    
        QuoteLineItem testquoteLineItem3=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
        insert testquoteLineItem3; 
        QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod1addon.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem3.Id);
        testquoteLineItem2.Quote_Line_Item__c=testquoteLineItem3.id;
        insert testquoteLineItem2;
        QuoteLineItem testquoteLineItem1=PGITestUtilities.getTestQuoteLineItem (testProd1Ancillary.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem3.Id);
        testquoteLineItem1.Quote_Line_Item__c=testquoteLineItem3.id;
        insert testquoteLineItem1;
        PageReference pref=Page.PgiQuoteDetails;
        Test.setCurrentPage(pref);
        Set<Id> allQuoteLineItems= new Set<Id>();
        allQuoteLineItems.add(testquoteLineItem3.Id);
        allQuoteLineItems.add(testquoteLineItem2.Id);
        allQuoteLineItems.add(testquoteLineItem1.Id);
        PGITestUtilities.setTestParameter('quoteId', testQuote.Id);
        PgiQuoteDetailsController con= new PgiQuoteDetailsController();
        con.quoteId=testQuote.Id;
        con.quoteLineItemIds= allQuoteLineItems;  
        con.ProdConfigDetails = QuoteSelectionUtilities.getConfigureServiceUsage(con.quoteLineItemIds,con.quoteId);
        con.selectedQuoteLineItemId=testquoteLineItem3.id; 
        list<Id> Addproducts=new list<Id>();
        Addproducts.add(testProd1Ancillary.Id);
        for(PGIProduct pgiPro:con.ProdConfigDetails)
        pgiPro.ancillaryProducts=Addproducts; 
        con.AddAncillaryProducts();
        system.assertNotEquals(con.ProdConfigDetails.size(),0);  
        system.assertNotEquals(con.ancillaryProductIds.size(),0);  
        
        
   }
   @istest(seeAlldata=true)
   private static void test_deletelineItem(){
     
       
        test.startTest();
        Test.setCurrentPage(Page.PgiQuoteDetails);
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
        Product__c testprod1= PGITestUtilities.getProductDetails('Service', 'testserv','30111111');
        testprod1.Term_Length__c=1;
        insert testProd1;
        Product__c testprod1addon = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111') ;
        insert testprod1addon;      
        Product__c testprod1Ancillary = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
        insert testProd1Ancillary;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testprod1.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testprod1addon.Id, false);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1Ancillary.Id, false);
        insert testSc3;
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        string standardPriceBookId = pb2Standard.Id;
        Product2 testProd= PGITestUtilities.getStdProduct();        
        insert testProd;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=testProd.Id, UnitPrice=99, isActive=true);
        insert pbe;
        OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, pbe.Id);
        insert oli;   
        QuoteLineItem testquoteLineItem3=PGITestUtilities.getServiceQuoteLineItem(testprod1.Id,testSer.Id,testQuote.Id,pbe);
        insert testquoteLineItem3; 
        QuoteLineItem testquoteLineItem2=PGITestUtilities.getTestQuoteLineItem(testprod1addon.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem3.Id);
        testquoteLineItem2.Quote_Line_Item__c=testquoteLineItem3.id;
        insert testquoteLineItem2;
        QuoteLineItem testquoteLineItem1=PGITestUtilities.getTestQuoteLineItem (testProd1Ancillary.Id,testSer.Id,testQuote.Id,pbe,testquoteLineItem3.Id);
        testquoteLineItem1.Quote_Line_Item__c=testquoteLineItem3.id;
        insert testquoteLineItem1;
        PageReference pref=Page.PgiQuoteDetails;
        Test.setCurrentPage(pref);
        Set<Id> allQuoteLineItems= new Set<Id>();
        allQuoteLineItems.add(testquoteLineItem3.Id);
        allQuoteLineItems.add(testquoteLineItem2.Id);
        allQuoteLineItems.add(testquoteLineItem1.Id);
        PGITestUtilities.setTestParameter('quoteId', testQuote.Id);
        PgiQuoteDetailsController con= new PgiQuoteDetailsController();
        con.quoteId=testQuote.Id;
        con.quoteLineItemIds= allQuoteLineItems;  
        con.ProdConfigDetails = QuoteSelectionUtilities.getConfigureServiceUsage(con.quoteLineItemIds,con.quoteId);
        con.selectedQuoteLineItemId=testquoteLineItem3.id; 
        con.deleteQuoteLineId=testquoteLineItem1.Id; 
        for(PGIProduct pro: con.ProdConfigDetails){
          for(PGIProduct.ProductList prolst:pro.productLst){
            con.selectedRowId=prolst.customRowId ;
          }
        }
        con.deletelineItem();
        system.assertNotEquals(con.ProdConfigDetails.size(),0);  
        //system.assertNotEquals(con.ancillaryProductIds.size(),0);  
        
        
   }
   @istest(seeAlldata=true)
   private static void test_updateServices(){ 
        //Case1:
        test.startTest();
        Test.setCurrentPage(Page.PgiQuoteDetails);
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
        Product__c testprod2 = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
        insert testProd2;
        Product__c testprod3= PGITestUtilities.getProductDetails('Add-on','testserv','30111111');
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
        list<QuoteLineItem> quotelst=[Select q.UnitPrice, q.Service__c, q.QuoteId, q.Quantity, q.Product__c, q.PricebookEntry.Name, q.PricebookEntryId, q.Approval_Status__c From QuoteLineItem q where q.QuoteId=:testQuote.Id];
        set<Id> quoItemid=new set<Id>();
        string quoteItemIds;
        for(quoteLineItem quoItem:quotelst){
         quoItemid.add(quoItem.Id);
         if(quoteItemIds!=null)
         quoteItemIds=quoteItemIds+',';
         quoteItemIds=quoteItemIds+quoItem.Id;
        }
        PGITestUtilities.setTestParameter('quoteId', testQuote.Id);
        PGITestUtilities.setTestParameter('quoteLineIds',quoteItemIds);
        PgiQuoteDetailsController proSelcon=new PgiQuoteDetailsController();
      //  system.assertNotEquals(proSelcon.ProdConfigDetails.size(),0); 
        proSelcon.updateServices();
        //Case2:
        testQuote=new Quote();
        PGITestUtilities.setTestParameter('quoteId', testQuote.Id);
        proSelcon=new PgiQuoteDetailsController();
        proSelcon.updateServices();
   }
}