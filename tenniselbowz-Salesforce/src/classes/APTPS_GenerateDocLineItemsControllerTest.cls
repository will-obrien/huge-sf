/*
    Class : APTPS_GenerateDocLineItemsControllerTest 
    Description : This method contains test method which covers code of beloe classes
                1. APTPS_GenerateDocLineItemsController 2. APTPS_DocumentLineItemUtility
*/
@isTest
public class APTPS_GenerateDocLineItemsControllerTest {       
    
    public testmethod static void testGenerateLineItemUtility() {        
        Product2 testProduct = APTPS_DaikinTestDataUtility.getProduct('productName');
        insert testProduct;
        Id testPriceBookId = APTPS_DaikinTestDataUtility.getStandardPricebookId();    
        PricebookEntry testPriceBookEntry = APTPS_DaikinTestDataUtility.getPBEntry(testProduct.Id, testPriceBookId, false);
        insert testPriceBookEntry;
        Account testAccount = APTPS_DaikinTestDataUtility.getAccount('accName');
        insert testAccount;
        Contact testContact = APTPS_DaikinTestDataUtility.getContact(testAccount);
        insert testContact; 
        Opportunity testOpportunity = APTPS_DaikinTestDataUtility.getOpp(testAccount);
        insert testOpportunity;
        OpportunityLineItem testOpportunityLineItem = APTPS_DaikinTestDataUtility.getOppLineItem(testOpportunity.Id, testPriceBookEntry.Id);
        insert testOpportunityLineItem;
        Apttus_Config2__PriceList__c testPriceList = APTPS_DaikinTestDataUtility.getPriceList('name');
        insert testPriceList;
        Apttus_Proposal__Proposal__c testProposal = APTPS_DaikinTestDataUtility.getQuote(testAccount,testContact,testOpportunity,testPriceList);
        testProposal.Maintenance_Type__c = 'Inspection';
        testProposal.Term_in_Years__c = '1';
        insert testProposal;
        
        List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
        proposalList.add(testProposal);    
        
        Apttus_Proposal__Proposal_Line_Item__c qLineItem = new Apttus_Proposal__Proposal_Line_Item__c();
        
        qLineItem.Apttus_Proposal__Proposal__c =  testProposal.Id;
        qLineItem.TAG_ID__c = testOpportunityLineItem.TAG__c;
        qLineItem.Apttus_Proposal__Product__c = testOpportunityLineItem.Product2Id;
        qLineItem.Supplier__c = testOpportunityLineItem.Vendor_Supplier__c;
        qLineItem.Product_Description__c = testOpportunityLineItem.Product2.Description;
        qLineItem.Apttus_QPConfig__ListPrice__c = testOpportunityLineItem.ListPrice;
        qLineItem.List_price_Per_Unit__c = testOpportunityLineItem.UnitPrice;
        qLineItem.Multiplier__c = testOpportunityLineItem.Multiplier_PAR__c;
        qLineItem.DST_ID__c = testOpportunityLineItem.DST_ID__c;
        qLineItem.Product_Name__c = testOpportunityLineItem.Product2.Name;
        qLineItem.Apttus_Proposal__Product__c = testOpportunityLineItem.Product2Id;
        qLineItem.Apttus_Proposal__Quantity__c = testOpportunityLineItem.Quantity;
        qLineItem.Is_Last_in_Group__c = true;
        qLineItem.Group_Comment__c = 'test comment 1';
        insert qLineItem;  
        
        Apttus_Proposal__Proposal_Line_Item__c qLineItem1 = qLineItem.clone();
        qLineItem1.Group_Comment__c = null;
        insert qLineItem1;
        
        Apttus_Proposal__Proposal_Line_Item__c qLineItem2 = qLineItem.clone();
        qLineItem2.Is_Last_in_Group__c = false;
        insert qLineItem2;          
                 
        Test.startTest();
        Id proposalId = testProposal.Id;
        ApexPages.currentPage().getParameters().put('Id',proposalId);    
        APTPS_GenerateDocLineItemsController oAPTPSGenerateDocLineItemsController = new APTPS_GenerateDocLineItemsController();                 
        oAPTPSGenerateDocLineItemsController.generateDocumentLineItems();
        List<APTPS_Document_Line_Item__c> docLineItems = [Select Id from APTPS_Document_Line_Item__c limit 10];
        System.assertEquals(5, docLineItems.size());
        
        Apttus_Proposal__Proposal__c testProposal1 = testProposal.clone();
        insert testproposal1;
        //cover exceptions
        try {
            APTPS_DocumentLineItemUtility.insertDocumentLineItems(new List<APTPS_Document_Line_Item__c>{new APTPS_Document_Line_Item__c()});
        } catch(DMLException e) {
             System.assert(e.getMessage().contains('DMLException'));
        }
        try {
            APTPS_DocumentLineItemUtility.getDocumentLineItems(testproposal1.Id);
            APTPS_DocumentLineItemUtility.getDocumentLineItems(null);
            APTPS_DocumentLineItemUtility.getDocumentLineItems('a1YL0000000gF8D');
            APTPS_DocumentLineItemUtility.getQuoteLineItems(testProposal1.Id);
            APTPS_DocumentLineItemUtility.getQuoteLineItems(null);
            APTPS_DocumentLineItemUtility.getQuoteLineItems('a1YL0000000gF8D');
        } catch(QueryException e){
            System.assert(e.getMessage().contains('list has no rows'));
        }
        try {
            APTPS_DocumentLineItemUtility.deleteDocumentLineItems(new List<APTPS_Document_Line_Item__c>{
               [Select Id from APTPS_Document_Line_Item__c limit 1]});
        } catch(Exception e) { } 
       
        Test.stopTest();
              
    }
}