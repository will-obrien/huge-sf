@isTest
/*
    Class : APTPS_DaikinTestDataUtility
    Description : This class contains blue print of required test data. 
*/
public class APTPS_DaikinTestDataUtility {
    
    public static List<Account> accountListNA;
    public static List<Account> accountListLA;
    public static List<Contact> contacts;
    public static List<Opportunity> oppListNA;
    public static List<Opportunity> oppListLA;
    public static List<Apttus_Proposal__Proposal__c> quoteListNA;
    public static List<Apttus_Proposal__Proposal__c> quoteListLA;
    //
    public static List<Product2> standaloneProductList;
    public static List<Product2> bundleProductList;
    
    //public static List<Apttus_Config2__PriceList__c> priceList; //active
    public static List<Apttus_Config2__PriceListItem__c> priceListItemList; //associated with Price list and Product
    
    public static Product2 getProduct(String productName) {
        return new Product2(Name = productName, Vendor_Supplier__c = 'Test Vendor', IsActive = true, Description = 'Test Description', Apttus_Product__c = true,
         Product_Category__c = 'Test Category');
    }
    
    public static Id getStandardPricebookId() {
        return Test.getStandardPricebookId();
    } 
    
    public static PricebookEntry getPBEntry(Id productId, Id priceBookId, Boolean useStandardPrice) {
        return new PricebookEntry(Product2Id = productId, Pricebook2Id = pricebookId, IsActive = true, UnitPrice = 10, UseStandardPrice = useStandardPrice);
    }
    
    public static Account getAccount(String accName) {
        return new Account(Name = accName);
    }
    
    public static Contact getContact(Account account) {
        return new Contact(FirstName = 'Test Account', LastName = 'NA-1', AccountId = account.Id, Email = 'psevak@apttus.com', Phone = '123456789');
    }
    
    public static Opportunity getOpp(Account account) {
        return new Opportunity(Name = 'Test Opp NA-1', AccountId = account.Id, Line_of_Business__c = 'MA - Maintenance Agreement', Vertical_Market__c = 'Manufacturing Facilities and Warehouses',
            Opp_City__c = 'Ahmedabad', Opp_State__c = 'Gujarat', CloseDate = System.Today() + 30, NextStep = 'Close', StageName = 'A-Purchase order received', Probability = 25, Bypass__c = true);
    }
    
    public static OpportunityLineItem getOppLineItem(Id oppId, Id pbEntryId) {
        OpportunityLineItem oppLineItem = new OpportunityLineItem(OpportunityId = oppId);
        oppLineItem.TAG__c = 'Tag'; oppLineItem.PriceBookEntryId = pbEntryId;
        oppLineItem.UnitPrice = 10; oppLineItem.Multiplier_PAR__c = 1; oppLineItem.Quantity = 1;
        return oppLineItem;
    }
    
    public static Apttus_Config2__PriceList__c getPriceList(String name) {
        return new Apttus_Config2__PriceList__c(Name = name, Apttus_Config2__Active__c = true);
    }
    
    public static APTPS_Configurable_Variables__c getNorthAmericaQuoteCS() {
        APTPS_Configurable_Variables__c northAmericaQuoteCS = new APTPS_Configurable_Variables__c();
        northAmericaQuoteCS.Name = 'North_America_Quote_Price_List';
        northAmericaQuoteCS.APTPS_Variable_Value__c = 'USD Price List';
        return northAmericaQuoteCS;
    }
    
    public static Apttus_Proposal__Proposal__c getQuote(Account account, Contact contact, Opportunity opportunity, Apttus_Config2__PriceList__c priceList) {
        return new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Test Quote NA-1', Apttus_Proposal__Account__c = account.Id, 
            Apttus_Proposal__Opportunity__c = opportunity.Id, Apttus_QPConfig__PriceListId__c = priceList.Id,
            Apttus_Proposal__Primary_Contact__c = contact.Id, Local_Currency__c = 'USD',Bulk_Exchange_Rate__c = 1,
            Estimated_Close_Date__c = System.today() + 30, Quote_Document_Date__c = System.today(), T_C_Country__c = 'USA',
            Brand__c = 'Daikin', Maintenance_Type__c = 'Inspection', Term_in_Years__c = '1');
    }
    
    

}