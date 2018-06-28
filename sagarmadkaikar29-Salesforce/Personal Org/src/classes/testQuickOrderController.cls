@isTest
    private class testQuickOrderController {
    static testMethod void testQuickOrderController() {
        Account aTest1 = new Account(Name='test account',Location__Longitude__s=-122.396382, Location__Latitude__s=37.793728);
        Account aTest2 = new Account(Name='test account');
        insert aTest1; insert aTest2;
        
        Warehouse__c wareTest1 = new Warehouse__c(Name='ware test 1', Street_Address__c='640 Brannan St',City__c='San Francsico', Location__Latitude__s=37.783900,Location__Longitude__s=-122.389332);
        Warehouse__c wareTest2 = new Warehouse__c(Name='ware test 2', Street_Address__c='160 Brannan St',City__c='San Francsico',Location__Latitude__s=37.775794, Location__Longitude__s=-122.399579);
        insert wareTest1; insert wareTest2;
        
        Merchandise__c merchTest1 = new Merchandise__c(Name='test iPhone',Price__c=600,Quantity__c=5,Condition__c='New',Warehouse__c=wareTest1.Id);
        Merchandise__c merchTest2 = new Merchandise__c(Name='test MacBook',Price__c=1000,Quantity__c=10,Condition__c='New',Warehouse__c=wareTest2.Id);
        insert merchTest1; insert merchTest2;
        
        QuickOrderController.findWarehouses(aTest1.Id, 'iPhone', '50');
        QuickOrderController.findWarehouses(aTest1.Id, 'Macbook', '10');
        
        Line_Item__c testQuickOrder = QuickOrderController.createQuickOrder(aTest1.Id, merchTest1.Id);
        String testOrderSerialized = JSON.serialize(testQuickOrder);
        QuickOrderController.insertQuickOrder(testOrderSerialized, '100', aTest1.Id);
        
        Invoice__c testInv = new Invoice__c(Account__c=aTest1.Id,Status__c='Open');
        insert testInv;
        QuickOrderController.goBack(testInv.Id);
        
        System.assertEquals(true,WarehouseDataInstall.getHasData());
    }
}