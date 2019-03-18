/********************************************************************************
Name:  PgiNewQuoteDocGeneratorController{()  
Copyright © 2012  PGI   
======================================================
======================================================
Purpose:
-------    
 This Class is used to generate Template based on the Contract Type
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE           DETAIL              
1.0    - CapgeminiIndia         25/10/2012         Initial Development 
********************************************************************************/ 
public with sharing class PgiNewQuoteDocGeneratorController{
    
    /* Stores the dummy String, which is used to initialize strings those contains contract document group name. */
    private static final String DUMMY_STRING = 'DummyString';
    
    /* Stores the list of products used in the quote. */
    private list<PGIProduct.ProductList> allProductDetailsList{get; set;}
    
    /* Stores the contract type for the quote. */
    private String contractType{get;set;}
    
    /* Stores the quote id. */
    private Id QuoteId {get;set;}
    
    /* Used on the VF page to print the terms and conditions for add-ons. */
    public list<PGIServicesInformation__c> productContent{get; set;}
    
    /* Used on the VF page to display the SLA header. */
    public boolean isSLA {get;set;}
    
    /* Used on the VF page to display the common header. */
    public boolean isCommon{get;set;}
    
    /* Used on the VF page to display the header. */
    public boolean isHeader{get;set;}
    
    /* Used on the VF page to display the SLO header. */
    public boolean isSLO {get;set;}
    
    /* Stores boolean value to check for CSO without commitment. */
    public boolean isCSOWithoutCommitment {get;set;}
    
    /* Stores boolean value to check for CSO with commitment. */
    public boolean isCSOWithCommitment {get;set;}
    
    /* Stores boolean value to check for common CSO. */
    public boolean isCSOCommon {get;set;}
    
    /* Stores boolean value to check for service pricing schedule. */
    public boolean isServicePricingSchedule {get;set;}
    
    /* Stores user phone string. */
    public String userPhone{get;set;}
    
    /* Stores user fax string. */
    public String userFax{get;set;}
    
    /* Stores max service term value. */
    public Long maxServiceTerm{get;set;}

    /* Stores a map for product ID to product verbiage values. */
    public map<Id,list<PGIContractProductDetails.Verbiage>> allProductIDwithVerbiage{get;set;}
    
    /* Stores a map for contract document group to verbiage. */
    public map<string,set<string>> allGrpVerbiage{get;set;}

    /* Stores a map for contract document group to verbiage. */
    public string footerNotesFromAccount {get;set;}
    
    /* Stores a map for contract document group to verbiage. */
    public string legalEntityAccountName {get;set;}
    
    /* Stores a map for contract document group to verbiage. */
    public string stringlogo {get;set;} 
    
    /* Stores a map for contract document group to verbiage. */
    public string billingaddress{get;set;}
    
    /* These maps are used to implement the two column approach. Ideally there will be two lists per contract document group, one for first
       column and another for second column. */
    
    /* Stores a map for contract document group to List of List of licensed add-ons. */
    public Map<String,list<list<PGIProduct.ProductList>>> cDGToLicensedAddonProductList{get;set;}
    
    /* Stores a map for contract document group to List of List of non-licensed add-ons. */
    public Map<String,list<list<PGIProduct.ProductList>>> cDGToNonLicensedAddonProductList{get;set;}
    
    /* Stores a map for contract document group to List of List of existing non-licensed add-ons. */
    public Map<String, list<PGIProduct.ProductList>> cDGToExistingNonLicensedAddonProductList{get;set;}
    
    /* Stores list of licensed service contract document group. */
    public List<String> licensedServiceCDG{get;set;}
    
    /* Stores list of licensed add-on contract document group. */
    public List<String> licensedAddonProductCDG{get;set;}
    
    /* Stores list of non-licensed add-on contract document group. */
    public List<String> nonLicensedAddonProductCDG{get;set;}
    
    /* Stores map of contract document group to list of products. */
    public Map<String, List<PGIProduct.ProductList>> licensedServiceProductByGroup{get;set;}
    
    /* Stores contract document custom settings object. */
    public ContractDocument_Settings__c docSettings
    {
        get
        {
            if (docSettings == null)
            {
                docSettings = ContractDocument_Settings__c.getInstance(PGIAppConstants.CONTRACT_DOC_CUSTOM_SETTINGS);
            }
            return docSettings;
        }
        set;
    }
    
    /* Stores concatenated string of non-licensed contract document group names. */
    public String nonLicensedCDGString
    {
        get;
        set;
    }
    
    /* Stores concatenated string of licensed contract document group names. */
    public String nonLicensedExistingCDGString
    {
        get;
        set;
    }
    
    /* Stores concatenated string of licensed contract document group names. */
    public String licensedAddOnCDGString
    {
        get;
        set;
    }
    
    /* Stores boolean value to check if quote has licensed add ons or not. */
    public Boolean hasLicensedAddOns
    {
        get;
        set;
    }

	/* Stores boolean value to check if quote has non-licensed add ons or not. */
    public Boolean hasNonLicensedAddOns
    {
        get;
        set;
    }
    
    public string createddates{get;set;}
    public string expirationdate{get;set;}
    public list<string> QuoteAddress{get;set;}
    
    /**
     * Contructor for the controller class. Used to initialize all the required collection
     * and queries required data.
     */
     public PgiNewQuoteDocGeneratorController(ApexPages.StandardController controller){
        try{
            quoteId = apexPages.currentpage().getParameters().get('Id');
            allProductDetailsList =  QuoteLineItemUtil.getAllProductDetails(quoteId);
            //system.debug('allProductDetailsList $$$$$$$ '+allProductDetailsList.size());
            allProductIDwithVerbiage = QuoteLineItemUtil.getMapVerb(quoteId);
            allGrpVerbiage = QuoteLineItemUtil.getverbgrpmap(quoteId);
            Quote quote =[select CreatedDate__c, ContractType__c, ExpirationDateQuoteDocumennt__c from Quote where Id=:quoteId];
            contractType = quote.ContractType__c;
            createddates= quote.CreatedDate__c.format();
            expirationdate= quote.ExpirationDateQuoteDocumennt__c.format();
            // Initialize all the collections that are used on VF page.
            licensedServiceCDG = new List<String>();
            licensedAddonProductCDG = new List<String>();
            nonLicensedAddonProductCDG = new List<String>();
            licensedServiceProductByGroup = new Map<String, List<PGIProduct.ProductList>>();
            cDGToLicensedAddonProductList = new map<String,list<list<PGIProduct.ProductList>>>();
            cDGToNonLicensedAddonProductList = new map<String,list<list<PGIProduct.ProductList>>>();
            cDGToExistingNonLicensedAddonProductList = new Map<String, list<PGIProduct.ProductList>>();
            hasLicensedAddOns = true;
            hasNonLicensedAddOns = true;
            licensedAddOnCDGString = DUMMY_STRING;
            nonLicensedExistingCDGString = DUMMY_STRING;
            nonLicensedCDGString = DUMMY_STRING;
            QuoteAddress = new list<string>();
            // call the method to populate all the collections, which contains data to be diplayed in contract document group.
            prodDetails();
         }
         catch (Exception e)
         {
            system.debug('$$$Exception'+ e);
         }
   }
               
   /**
    * Populates all the collections with the iformation that is required to be displayed in the
    * contract document.
    */                 
   public void prodDetails(){

        //set for unique product ids.
        set<Id> productIds = new set <Id>();
        //list of max service term values.
        list<Double> maxServiceTermLst= new list<Double>();
        
        // loop through the product list and product ids, max service terms and product verbiages.
        for (PGIProduct.ProductList qLineItems:allProductDetailsList){
            if(qLineItems.productId!=null || qLineItems.productId!=''){
                    productIds.add(qLineItems.productId);
            }
            if(qLineItems.isServiceProduct && qLineItems.termLength!=null){
                maxServiceTermLst.add(qLineItems.termLength);
            }
            
            if(!((allProductIDwithVerbiage.keyset()).contains(qLineItems.productId)))
            {
                allProductIDwithVerbiage.put(qLineItems.productId,new list<PGIContractProductDetails.Verbiage>());
            }
            
            if(!((allGrpVerbiage.keyset()).contains(qLineItems.ContractDocumentGroup)))
            {
                allGrpVerbiage.put(qLineItems.ContractDocumentGroup,new set<string>());
            }
        }
        // find out the max service term.
        if(!maxServiceTermLst.isEmpty()){
            maxServiceTerm=maxServiceTermLst[0].round();
            for(integer i=0;i<maxServiceTermLst.size();i++){
                if(maxServiceTermLst[i].round()>maxServiceTerm){
                    maxServiceTerm=maxServiceTermLst[i].round();
                }
            }
        }
          
        productContent=[select Content__c,name from PGIServicesInformation__c  order by name];
         if(contractType=='Subscription License Order'){
                  isSLO=true;
                  isCommon=true;
                  isHeader=true;
            }else if (contractType=='Subscription License Agreement'){
                  isSLA=true;
                  isCommon=true;
                  isHeader=true;
            }else if (contractType=='Customer Service Order'){
                  isCSOCommon=true;
                  isCSOWithCommitment=true;
                  isHeader=true;
            }/*
            else if (contractType=='Customer Service Order(without Minimum Commitment)'){
                  isCSOCommon=true;
                  isCSOWithoutCommitment=true;
                  isHeader=true;
            }
            */
            else if (contractType=='Services & Pricing Schedule – Customer Rates'){
                isServicePricingSchedule=true;
            }
            
            string keyOfUser='';
            // populate the user information.
            for(User userDetails : [select Phone ,Fax,KeyForContract__c From User where Id =:userinfo.getuserId()]){
                    userPhone=userDetails.Phone;
                    userFax=userDetails.Fax;
                    keyOfUser=userDetails.KeyForContract__c;
            }
            //To display the Service Information Section
            if(keyOfUser!=null){
                for(Account acc :[select Name,FooterContentForContract__c,logo__c,address__c from account where KeyForContract__c=:keyOfUser limit 1]){
                    legalEntityAccountName=acc.Name;
                    footerNotesFromAccount=acc.FooterContentForContract__c;
                    stringlogo=acc.logo__c.replace('amp;', '');
                    billingaddress=acc.address__c;
                    QuoteAddress=BillingAddress.split(',',3);
                }
            }
            
            //list<Add_on_FeatureContractTerms__c> serviceInformationLst =[Select Contract_Term__r.Terms_and_Conditions__c, Contract_Term__r.Name, Contract_Term__c, Add_on_Feature__r.Name,Add_on_Feature__c From Add_on_FeatureContractTerms__c where Add_on_Feature__c In:productIds];
            groupProductsByContractDocumentGroup();
   }
   
   /**
    * Processes all the products and groups the information by contract document group for licensed
    * and non-licensed products.
    */    
   private void groupProductsByContractDocumentGroup()
   {
        // Set of licensed service category ids.
        Set<Id> licensedServiceIds = new Set<Id>();
        // Set of non-licensed service category ids.
        Set<Id> nonLicensedServiceIds = new Set<Id>();
        // Set of service product ids.
        Set<Id> serviceProductIds = new Set<Id>();
        // List of product list used to collect products for a contract document group.
        List<PGIProduct.ProductList> productList = new List<PGIProduct.ProductList>();
        // Map of contract document group to licensed add-on products.
        Map<String, List<PGIProduct.ProductList>> licensedAddonProductByGroup = new Map<String, List<PGIProduct.ProductList>>();
        // Map of contract document group to non-licensed add-on products.
        Map<String, List<PGIProduct.ProductList>> nonLicensedAddonProductByGroup = new Map<String, List<PGIProduct.ProductList>>();
        // Collect licensed service and non-licensed service products.
        for(PGIProduct.ProductList prodDetails:allProductDetailsList){
            // collect service product ids and service category id for the licensed service product.
            // this will be used in generating map for licensed add-ons.
            if (prodDetails.isServiceProduct && prodDetails.isPGILicense)
            {
                licensedServiceIds.add(prodDetails.serviceId);
                serviceProductIds.add(prodDetails.productId);
                if (prodDetails.ContractDocumentGroup != null)
                {
                    
                    licensedServiceProductByGroup.put(prodDetails.ContractDocumentGroup, 
                            addProductToList(licensedServiceProductByGroup.get(prodDetails.ContractDocumentGroup), prodDetails));
                }
            }
            // collect service product ids and service category id for the non-licensed service product.
            // this will be used in generating map for non-licensed add-ons.
            else if (prodDetails.isServiceProduct && !prodDetails.isPGILicense)
            {
                nonLicensedServiceIds.add(prodDetails.serviceId);
                serviceProductIds.add(prodDetails.productId);
                if (prodDetails.nonLicensedContractDocumentGroup != null)
                {
                    nonLicensedAddonProductByGroup.put(prodDetails.nonLicensedContractDocumentGroup, 
                            addProductToList(nonLicensedAddonProductByGroup.get(prodDetails.nonLicensedContractDocumentGroup), prodDetails));
                }
            }
        }
        //system.debug('nonLicensedAddonProductByGroup $$$$$$$ '+nonLicensedAddonProductByGroup.keySet());
        // Set containing the id of licensed add-on products, to avoid the addition of duplicate products.
        Set<Id> licensedAddonProductIds = new Set<Id>();
        // Collect add-on products for licensed service package.
        for(PGIProduct.ProductList prodDetails:allProductDetailsList){
            if (!serviceProductIds.contains(prodDetails.productId) 
                && licensedServiceIds.contains(prodDetails.serviceId)
                && !licensedAddonProductIds.contains(prodDetails.productId)
                && prodDetails.ContractDocumentGroup != null)
            {
                licensedAddonProductByGroup.put(prodDetails.ContractDocumentGroup, 
                            addProductToList(licensedAddonProductByGroup.get(prodDetails.ContractDocumentGroup), prodDetails));
                licensedAddonProductIds.add(prodDetails.productId);
            }
        }
        // Set containing the id of non-licensed add-on products, to avoid the addition of duplicate products.
        Set<Id> nonLicensedAddonProductIds = new Set<Id>();
        // Collect add-on products for non-licensed service package.
        for(PGIProduct.ProductList prodDetails:allProductDetailsList){
            if (!serviceProductIds.contains(prodDetails.productId) 
                && nonLicensedServiceIds.contains(prodDetails.serviceId)
                && !nonLicensedAddonProductIds.contains(prodDetails.productId)
                && prodDetails.nonLicensedContractDocumentGroup != null)
            {
                // check if add-on already exists in licensed add-ons.
                if (licensedAddonProductIds.contains(prodDetails.productId))
                {
                    cDGToExistingNonLicensedAddonProductList.put(prodDetails.nonLicensedContractDocumentGroup, 
                            addProductToList(cDGToExistingNonLicensedAddonProductList.get(prodDetails.nonLicensedContractDocumentGroup), prodDetails));
                }
                else
                {
                    nonLicensedAddonProductByGroup.put(prodDetails.nonLicensedContractDocumentGroup, 
                            addProductToList(nonLicensedAddonProductByGroup.get(prodDetails.nonLicensedContractDocumentGroup), prodDetails));
                }
                nonLicensedAddonProductIds.add(prodDetails.productId);
            }
        }
            
        Set<String> licensedServiceCDGSet = licensedServiceProductByGroup.keyset();
        // sort the licensed add-on contract document groups.
        licensedAddonProductCDG.addAll(licensedAddonProductByGroup.keyset());
        licensedAddonProductCDG.sort();
        // sort the non-licensed add-on contract document groups.
        Set<String> nonLicensedCDGs = new Set<String>();
        // need to add to set collection first, so that duplicates are not added.
        nonLicensedCDGs.addAll(nonLicensedAddonProductByGroup.keyset());
        nonLicensedCDGs.addAll(cDGToExistingNonLicensedAddonProductList.keyset());
        // now add all the CDGs to list, so that we can do the sorting.
        nonLicensedAddonProductCDG.addAll(nonLicensedCDGs);
        nonLicensedAddonProductCDG.sort();
        if(nonLicensedAddonProductCDG.isEmpty())
        {
            this.hasNonLicensedAddOns = false;
        }
        // divide the licensed add-on product for contract document groups for two column approach.
        for (String contractDocGroupName : licensedAddonProductCDG)
        {
            productList = licensedAddonProductByGroup.get(contractDocGroupName);
            // create concatenated string of contract document group names, this will be used on VF page
            // to check whether map has new add-ons for CDGs.
            licensedAddOnCDGString += contractDocGroupName;
            if (productList != null)
            {
                productList.sort();
                cDGToLicensedAddonProductList.put(contractDocGroupName, divideProductList(productList, false));
            }
        }
        // divide the non-licensed add-on product for contract document groups for two column approach.
        for (String contractDocGroupName : nonLicensedAddonProductByGroup.keyset())
        {
            productList = nonLicensedAddonProductByGroup.get(contractDocGroupName);
            // create concatenated string of contract document group names, this will be used on VF page
            // to check whether map has new add-ons for CDGs.
            nonLicensedCDGString += contractDocGroupName;
            if (productList != null)
            {
                productList.sort();
                cDGToNonLicensedAddonProductList.put(contractDocGroupName, divideProductList(productList, false));
            }
        }
        // sort the list of existing add-ons for non-licensed CDGs.
        for (String contractDocGroupName : cDGToExistingNonLicensedAddonProductList.keyset())
        {
            productList = cDGToExistingNonLicensedAddonProductList.get(contractDocGroupName);
            // create concatenated string of existing contract document group names, this will be used on VF page
            // to check whether map has existing add-ons or not.
            nonLicensedExistingCDGString += contractDocGroupName;
            if (productList != null)
            {
                productList.sort();
                cDGToExistingNonLicensedAddonProductList.put(contractDocGroupName, productList);
            }
        }
        // remove the contract document group name for licensed service from licensed add-on CDGs.
        // to avoid the duplicacy.
        licensedServiceCDG.addAll(licensedServiceProductByGroup.keyset());
        for (Integer i = 0; i < licensedAddonProductCDG.size(); i++)
        {
            if (licensedServiceCDGSet.contains(licensedAddonProductCDG.get(i)))
            {
                licensedAddonProductCDG.remove(i);
                i--;
            }
        }
        // sort the licensed service contract document groups.
        licensedServiceCDG.sort(); 
        if(licensedServiceCDG.isEmpty())
        {
            this.hasLicensedAddOns = false;
        }
        /*system.debug('licensedServiceCDG $$$$$$$ '+licensedServiceCDG);
        system.debug('licensedAddonProductCDG $$$$$$$ '+licensedAddonProductCDG);
        system.debug('nonLicensedAddonProductCDG $$$$$$$ '+nonLicensedAddonProductCDG);
        system.debug('licensedServiceProductByGroup $$$$$$$ '+licensedServiceProductByGroup);
        system.debug('cDGToLicensedAddonProductList $$$$$$$ '+cDGToLicensedAddonProductList);
        system.debug('cDGToExistingNonLicensedAddonProductList $$$$$$$ '+cDGToExistingNonLicensedAddonProductList);
        system.debug('nonLicensedExistingCDGString $$$$$$$ '+nonLicensedExistingCDGString);
        system.debug('nonLicensedCDGString $$$$$$$ '+nonLicensedCDGString);
        system.debug('licensedAddOnCDGString $$$$$$$ '+licensedAddOnCDGString);
        system.debug('hasLicensedAddOns $$$$$$$ '+hasLicensedAddOns);*/
   }
   
   /**
    * Adds add-on product to the list. If list of null then initializes it.
    */   
   private List<PGIProduct.ProductList> addProductToList(List<PGIProduct.ProductList> productList, PGIProduct.ProductList prodDetails)
   {
        if (productList == null)
        {
            productList = new List<PGIProduct.ProductList>();
        }
        productList.add(prodDetails);
        return productList;
   }
   
   /**
    * Divides the given product list into two list of same sizes.
    *
    * @param productList, list of PGI Add-ons.
    * @param hasExistingProduct, boolean to check if list has existing add-ons then it is not required to be divided.
    *
    * @returns List of divided list of products.
    */      
   private List<List<PGIProduct.ProductList>> divideProductList(List<PGIProduct.ProductList> productList, Boolean hasExistingProduct)
   {
        List<List<PGIProduct.ProductList>> dividedData = new List<List<PGIProduct.ProductList>>();
        if (productList != null && !productList.isEmpty())
        {
            Integer upperLimit = 0;
            Integer lowerLimit = 0;
            Integer size = productList.size();
            // if list size is less than or equal to one, then do not divide the list.
            if (size <= 1 || hasExistingProduct)
            {
                dividedData.add(productList);
                // add empty list for the second column data, so that formatting looks good.
                if (!hasExistingProduct)
                {
                    dividedData.add(new List<PGIProduct.ProductList>());
                }
            }
            // if list has even number of products then divided the list to two equal size list for
            // first and second column.
            else if (Math.mod(size, 2) == 0)
            {
                upperLimit = size/2;
                lowerLimit = upperLimit;
            }
            // if list has odd number of products then divided the list to two lists for
            // first and second column, where first column will have one more product than second one.
            else
            {
                upperLimit = (Integer)Math.ceil(size/2) + 1;
                lowerLimit = size - upperLimit;
            }
            // add the products to the first and second column data.
            if (upperLimit != 0 && lowerLimit !=0)
            {
                List<PGIProduct.ProductList> firstColumnData = new List<PGIProduct.ProductList>();
                List<PGIProduct.ProductList> secondColumnData = new List<PGIProduct.ProductList>();
                for (Integer i = 0; i < size; i++)
                {
                    if (i < upperLimit)
                        firstColumnData.add(productList.get(i));
                    else
                        secondColumnData.add(productList.get(i));
                }
                dividedData.add(firstColumnData);
                dividedData.add(secondColumnData);
            }
        }
        return dividedData;
   }
       @istest (seeAlldata=true)
       private static void test_PGIPdfGeneratorTemplateController(){
        test.startTest();
        //Testdata 
        set<id>quoteId= new set<Id>();
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
        testQuote.ContractType__c = 'Customer Service Order';
        insert testQuote;
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        list<Product__c> allProduct= new list<Product__c>();
        Product__c testprod1= PGITestUtilities.getProductDetails('Service', 'testserv','30111111');
        testprod1.Term_Length__c=1;
        insert testProd1;
        Product__c testprod1addon = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','10111111') ;
        testprod1addon.ContractDocumentGroup__c='Audio';
        insert testprod1addon;      
        Product__c testprod1Ancillary = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','20111111');
        insert testProd1Ancillary;
        Product__c testprod2= PGITestUtilities.getProductDetails('Service', 'testserv','3a111111');
        testprod2.Term_Length__c=4;
        insert testProd2;
        Product__c testprod2addon = PGITestUtilities.getProductDetails('Add-on', 'TestAddon','1a111111') ;
        testprod2addon.ContractDocumentGroup__c='Audio';
        insert testprod2addon;      
        Product__c testprod2Ancillary = PGITestUtilities.getProductDetails('Ancillary', 'TestAncillary','2a111111');
        insert testProd2Ancillary;
        Solution__c testSoln = PGITestUtilities.getSolution();
        insert testSoln;
        Service__c testSer= PGITestUtilities.getService(testSoln.Id);
        insert testSer;
        Service__c testSer1= PGITestUtilities.getService(testSoln.Id);
        insert testSer1;
        ServiceCategory__c testSc1= PGITestUtilities.getSerCategory(testSer.Id, testprod1.Id, true);
        insert testSc1;
        ServiceCategory__c testSc2= PGITestUtilities.getSerCategory(testSer.Id, testprod1addon.Id, false);
        insert testSc2;
        ServiceCategory__c testSc3= PGITestUtilities.getSerCategory(testSer.Id, testProd1Ancillary.Id, false);
        insert testSc3;
        ServiceCategory__c testSc4= PGITestUtilities.getSerCategory(testSer1.Id, testprod2.Id, true);
        insert testSc4;
        ServiceCategory__c testSc5= PGITestUtilities.getSerCategory(testSer1.Id, testprod2addon.Id, false);
        insert testSc5;
        ServiceCategory__c testSc6= PGITestUtilities.getSerCategory(testSer1.Id, testProd2Ancillary.Id, false);
        insert testSc6;
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
        QuoteLineItem testquoteLineItem6=PGITestUtilities.getServiceQuoteLineItem(testprod2.Id,testSer1.Id,testQuote.Id,pbe);
        insert testquoteLineItem6;
        QuoteLineItem testquoteLineItem5=PGITestUtilities.getTestQuoteLineItem(testprod2addon.Id,testSer1.Id,testQuote.Id,pbe,testquoteLineItem6.Id);
        testquoteLineItem5.Quote_Line_Item__c=testquoteLineItem6.Id;
        insert testquoteLineItem5;
        QuoteLineItem testquoteLineItem4=PGITestUtilities.getTestQuoteLineItem(testProd2Ancillary.Id,testSer1.Id,testQuote.Id,pbe,testquoteLineItem6.Id);
        testquoteLineItem4.Quote_Line_Item__c=testquoteLineItem6.Id;
        insert testquoteLineItem4;
        Contract_Terms__c testContractTerm=PGITestUtilities.getContractTerms('Group Audio','terms');
        insert testContractTerm;
        Add_on_FeatureContractTerms__c testAddonTerm=PGITestUtilities.getProdTerms(testContractTerm.Id,testProd1.Id);
        insert testAddonTerm;
        Add_on_FeatureContractTerms__c testAddonTerm1=PGITestUtilities.getProdTerms(testContractTerm.Id,testprod2.Id);
        
        insert testAddonTerm1;
        Test.stopTest();
        PageReference pref=Page.PgiQuoteDocument;
        Test.setCurrentPage(pref);
        PGITestUtilities.setTestParameter('Id',testquote.id); 
        PgiNewQuoteDocGeneratorController con= new PgiNewQuoteDocGeneratorController(PGITestUtilities.getStandardController(testQuote));
        //Case1:Customer Service Order(without Minimum Commitment)
        list<Quote> quolst=[Select ContractType__c from Quote where id=:testQuote.Id];
        system.assertEquals(quolst[0].ContractType__c,'Customer Service Order');
            system.assertEquals(con.contractType,'Customer Service Order');
            system.assertEquals(con.isCSOCommon,true);
            system.assertEquals(con.isCSOWithoutCommitment,null);
            system.assertEquals(con.isHeader,true);
            Contract_Terms__c testcont=PGITestUtilities.getContractTerms('term1','termsAndConditions');
            insert testcont;
            Add_on_FeatureContractTerms__c testProdterms=PGITestUtilities.getProdTerms(testcont.Id,testprod1.Id);
            insert testProdterms;
        //Case2:Customer Service Order(with Minimum Commitment)
        testQuote.IsMinimumContractType__c=true;
        testQuote.MinimumContractLength__c='Monthly';
        testQuote.Minimum_Committment_Value__c='1';
        update testQuote;
        quoteId.add(testQuote.Id);
        PGIQuoteLineItemTriggerUtilities.updateContractType(quoteId);
        con= new PgiNewQuoteDocGeneratorController(PGITestUtilities.getStandardController(testQuote));
        quolst=[Select ContractType__c from Quote where id=:testQuote.Id];
            system.assertEquals(quolst[0].ContractType__c,'Customer Service Order');
            system.assertEquals(con.isCSOCommon,true);
            system.assertEquals(con.isCSOWithCommitment,true);
            system.assertEquals(con.isHeader,true);
        //Case3:Subscription License Agreement
        testProd1.isPGILicense__c=true;
        update testProd1;
        quoteId.add(testQuote.Id);
        PGIQuoteLineItemTriggerUtilities.updateContractType(quoteId);
        quolst=[Select ContractType__c from Quote where id=:testQuote.Id];
            system.assertEquals(quolst[0].ContractType__c,'Subscription License Order');
        con= new PgiNewQuoteDocGeneratorController(PGITestUtilities.getStandardController(testQuote));
            system.assertEquals(con.isSLO,true);
            system.assertEquals(con.isCommon,true);
            system.assertEquals(con.isHeader,true);
        //Case4:Subscription License Order
        testProd2.isPGILicense__c=true;
        update testProd2;
        quoteId.add(testQuote.Id);
        PGIQuoteLineItemTriggerUtilities.updateContractType(quoteId);
         quolst=[Select ContractType__c from Quote where id=:testQuote.Id];
            system.assertEquals(quolst[0].ContractType__c,'Subscription License Order');
        con= new PgiNewQuoteDocGeneratorController(PGITestUtilities.getStandardController(testQuote));
            system.assertEquals(con.isSLO,true);
            system.assertEquals(con.isCommon,true);
            system.assertEquals(con.isHeader,true);      
        //Case5:Services & Pricing Schedule – Customer Rates
        testQuote.ContractType__c='Services & Pricing Schedule – Customer Rates';
        update testQuote;
        con= new PgiNewQuoteDocGeneratorController(PGITestUtilities.getStandardController(testQuote));
            system.assertEquals(con.isServicePricingSchedule,true);
        
       }
}