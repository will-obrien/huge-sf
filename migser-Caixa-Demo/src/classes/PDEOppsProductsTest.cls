@isTest(seeAllData=true)
private class PDEOppsProductsTest {

     static testMethod void myTestMethod() {
        
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;
        
        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Closed Won';
        objOpporunity.CloseDate = system.Today();
        Insert objOpporunity;
        
        Product2 objProduct = new Product2();
        objProduct.Name = 'Test';
        objProduct.Description = 'Test';
        Insert objProduct;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        PricebookEntry objPBEntry = new PricebookEntry(Pricebook2Id = pb2Standard.Id, Product2Id=objProduct.Id,UnitPrice=500,IsActive=true);
        Insert objPBEntry;
        
        OpportunityLineItem objLineItem = new OpportunityLineItem();
        objLineItem.PriceBookEntryId = objPBEntry.Id;
        objLineItem.OpportunityId = objOpporunity.Id;
        objLineItem.Quantity = 1;
        objLineItem.Unitprice = 500;
        Insert objLineItem;
        
         List<PDEOppsProducts.DropDownRecord> DDR = PDEOppsProducts.getDDR(objAccount.Id);
        
    }
    
    
}