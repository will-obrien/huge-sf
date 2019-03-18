/* 
    Class : APTPS_DaikinPricingCallbackTest
    Description : This class covers APTPS_DaikinPricingCallback custom pricing code.
    Author : Parth Sevak , @Apttus            
*/
@isTest
private class APTPS_DaikinPricingCallbackTest {

    private static final String LINE_TYPE_PRODUCT_SERVICE = 'Product/Service';
    private static final String LINE_TYPE_OPTION = 'Option';
    private static final String LINE_STATUS_NEW = 'New';
    private static final String PRICE_TYPE_RECURRING = 'Recurring';
    private static final String CHARGE_TYPE_OVERAGE = 'Overage';
    private static final String CHARGE_TYPE_INCLUDED_UNITS = 'Included Units';
    private static final String CHARGE_TYPE_COMMIT = 'Commit';
    private static final String CHARGE_TYPE_INCLUDED = 'Included';
    private static final String LINE_STATUS_CANCELLED = 'Cancelled';
    
    static testMethod void testCustomPricingLogic() {
        //create config custom class properties
        Apttus_Config2__ConfigCustomClasses__c configCustomClassesProperty = new Apttus_Config2__ConfigCustomClasses__c();
        configCustomClassesProperty.Name = 'Config Custom Classes';
        configCustomClassesProperty.Apttus_Config2__PricingCallbackClass__c = 'APTPS_DaikinPricingCallback';
        insert configCustomClassesProperty;
        
        APTPS_Bundle_Products_With_Option_Price__c bundleCS = new APTPS_Bundle_Products_With_Option_Price__c();
        bundleCS.Name = 'Equipment & Tasking';
        insert bundleCS;
        
        //Create Accounts
        Account account = new Account(Name = 'APTPS TST Account 1');
        insert account;
        
        Contact contact = APTPS_DaikinTestDataUtility.getContact(account);
        insert contact;
        
        //create Opportunity
        Opportunity opportunity = APTPS_DaikinTestDataUtility.getOpp(account);
        insert opportunity;
        
        //create price list
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'APTPS TST PriceList 1', Apttus_Config2__Active__c = true);
        insert priceList;
        
        //Create Product
        list<Product2> productsList = new list<Product2>();
        Product2 product1 = new product2(Name = 'Service Technician', ProductCode = 'ATP 0001', Apttus_Config2__ConfigurationType__c = 'Standalone', IsActive = true); 
        productsList.add(product1);
        
        Product2 product21 = new product2(Name = 'Personnel Vehicle Mileage/Mile', ProductCode = 'ATP 0002', Apttus_Config2__ConfigurationType__c = 'Standalone', IsActive = true); 
        productsList.add(product21);
        
        Product2 product3 = new product2(Name = 'Cab', ProductCode = 'ATP 0003', Apttus_Config2__ConfigurationType__c = 'Standalone', IsActive = true); 
        productsList.add(product3);
        
        Product2 product4 = new product2(Name = 'Equipment & Tasking', ProductCode = 'ATP 0004', Apttus_Config2__ConfigurationType__c = 'Bundle', IsActive = true,
            Apttus_Config2__HasOptions__c = true); 
        productsList.add(product4);
        
        insert productsList;
        
        //create price list items
        list<Apttus_Config2__PriceListItem__c> priceListItems = new list<Apttus_Config2__PriceListItem__c>();
        Apttus_Config2__PriceListItem__c priceListItem1 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__ListPrice__c = 1000, Apttus_Config2__ProductId__c = product1.Id, Apttus_Config2__ChargeType__c = 'Standard Price');
        priceListItems.add(priceListItem1);
        
        Apttus_Config2__PriceListItem__c priceListItem2 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__ListPrice__c = 1000, Apttus_Config2__ProductId__c = product21.Id, Apttus_Config2__ChargeType__c = 'Subscription Fee');
        priceListItems.add(priceListItem2);
        
        Apttus_Config2__PriceListItem__c priceListItem3 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__ListPrice__c = 1000, Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__ChargeType__c = 'Subscription Fee');
        priceListItems.add(priceListItem3);
        
        Apttus_Config2__PriceListItem__c priceListItem4 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__ListPrice__c = 1000, Apttus_Config2__ProductId__c = product4.Id, Apttus_Config2__ChargeType__c = 'Subscription Fee');
        priceListItems.add(priceListItem4);
        insert priceListItems;
        
        //create quote/proposal
        Apttus_Proposal__Proposal__c quote = APTPS_DaikinTestDataUtility.getQuote(account, contact, opportunity, priceList);
        insert quote;
        
        //create product configuration
        Apttus_Config2__ProductConfiguration__c configuration = new Apttus_Config2__ProductConfiguration__c(Name = 'APTpS TST Configuration 1', Apttus_Config2__AccountId__c = account.Id, Apttus_Config2__PriceListId__c = priceList.Id, Apttus_QPConfig__Proposald__c = quote.Id, Apttus_Config2__Status__c = LINE_STATUS_NEW, Apttus_Config2__VersionNumber__c = 1, Apttus_Config2__EffectivePriceListId__c = priceList.Id);
        insert configuration;
        
        //create line items
        list<Apttus_Config2__LineItem__c> lineItemsList = new list<Apttus_Config2__LineItem__c>();
        
        product1 = [Select Id from Product2 where Name = 'Service Technician' limit 1]; 
        Apttus_Config2__LineItem__c lineItem1 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration.Id, 
            Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, Apttus_Config2__ProductId__c = product1.Id, 
            Apttus_Config2__BasePrice__c = 1000, APTPS_Cost__c = 500, APTPS_Margin_Percentage__c = 10, 
            Apttus_Config2__ChargeType__c = 'One Time Fee', Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__PrimaryLineNumber__c = 1);
        lineItemsList.add(lineItem1);
        
        product21 = [Select Id from Product2 where Name = 'Personnel Vehicle Mileage/Mile' limit 1]; 
        Apttus_Config2__LineItem__c lineItem2 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration.Id, 
            Apttus_Config2__LineType__c = LINE_TYPE_OPTION, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
            Apttus_Config2__ProductId__c = product21.Id, Apttus_Config2__BasePrice__c = 1000,
            APTPS_Cost__c = 500, APTPS_Selling_Price__c = 600, Apttus_Config2__ChargeType__c = 'One Time Fee', 
            Apttus_Config2__Quantity__c = 60, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 2, 
            Apttus_Config2__PriceType__c = PRICE_TYPE_RECURRING);
        lineItemsList.add(lineItem2);
        
        product3 = [Select Id from Product2 where Name = 'Cab' limit 1]; 
        Apttus_Config2__LineItem__c lineItem3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration.Id, 
            Apttus_Config2__LineType__c = 'Product/Service', Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
            Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__BasePrice__c = 1000,
            APTPS_Cost__c = 900, APTPS_Selling_Price__c = 1500, Apttus_Config2__ChargeType__c = 'One Time Fee', 
            Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 3, 
            Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustedPrice__c = 10, Apttus_Config2__NetPrice__c = 1490);
        lineItemsList.add(lineItem3);
        
        
        Product2 prd2 = new product2(Name = 'APTS TST Product 222', ProductCode = 'ATP1 0002', Apttus_Config2__ConfigurationType__c = 'Standalone', IsActive = true); 
        insert prd2;
        
        Apttus_Config2__LineItem__c lineItemSO6= new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration.Id, 
            Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE
                                                           , Apttus_Config2__LineStatus__c = 'New', Apttus_Config2__PriceMethod__c = 'Per Unit'
                                                           , Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__Frequency__c = 'One Time'
                                                           , Apttus_Config2__BasePrice__c = 1000
                                                           , Apttus_Config2__Term__c = 1
                                                           , APTPS_Cost__c = 900, APTPS_Margin_Percentage__c = 10
                                                           , Apttus_Config2__ChargeType__c = 'Standard Price'
                                                           , Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1
                                                           , Apttus_Config2__PrimaryLineNumber__c = 1, Apttus_Config2__SellingFrequency__c = 'One Time'
                                                           , Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__TotalQuantity__c = 1, Apttus_Config2__SellingTerm__c = 1);
        insert lineItemSO6;
       
        product4 = [Select Id from Product2 where Name = 'Equipment & Tasking' limit 1]; 
        Apttus_Config2__LineItem__c lineItem4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration.Id, 
            Apttus_Config2__LineType__c = 'Product/Service', Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
            Apttus_Config2__ProductId__c = product4.Id, Apttus_Config2__BasePrice__c = 1000,
            APTPS_Cost__c = 900, APTPS_Selling_Price__c = 1500, Apttus_Config2__ChargeType__c = 'One Time Fee', 
            Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 4, 
            Apttus_Config2__PriceType__c = PRICE_TYPE_RECURRING, APTPS_Selling_Price_Previous__c = 1500);
        lineItemsList.add(lineItem4);
        
        Apttus_Config2__LineItem__c lineItem5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration.Id, 
            Apttus_Config2__LineType__c = 'Option', Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
            Apttus_Config2__ProductId__c = product4.Id, Apttus_Config2__BasePrice__c = 1000,
            APTPS_Cost__c = 900, APTPS_Selling_Price__c = 1500.00, Apttus_Config2__ChargeType__c = 'One Time Fee', 
            Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 5, 
            Apttus_Config2__PriceType__c = PRICE_TYPE_RECURRING, Apttus_Config2__NetPrice__c = 1490,
            Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustmentAmount__c = 10, APTPS_Margin_Percentage__c = 100, 
            Apttus_Config2__AdjustedPrice__c = 10);
        lineItemsList.add(lineItem5);
        
        insert lineItemsList;
        
        test.startTest();
        APTPS_DaikinPricingCallback callBackPricingObj = new APTPS_DaikinPricingCallback();
        callBackPricingObj.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
        
        Boolean result = Apttus_Config2.PricingWebService.computeBasePriceForItemColl(configuration.Id, 1);
        system.assert(result);
        
        test.stopTest();
    }

}