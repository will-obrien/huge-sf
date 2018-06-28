/**
 * Test the update of Contract Product_Text__c field with the names of the Contract Products
 *
 * @author  Virginia Fernández
 * @date    04/11/2013
 */
@isTest
private class ContractProductTriggerTest {

    static testMethod void insertContractProductTest() {
        
        DContract__c contract = new DContract__c();
        contract.Name = 'Test';
        insert contract;
        
        Product2 product = new Product2();
        product.Name = 'Product1';
        insert product;
        
        Product2 product2 = new Product2();
        product2.Name = 'Product2';
        insert product2;
        
        List<Contract_Product__c> contractProducts = new List<Contract_Product__c>();
        Contract_Product__c contractProduct1 = new Contract_Product__c();
        contractProduct1.Contract__c = contract.Id;
        contractProduct1.Product__c = product.Id;
        contractProducts.add(contractProduct1);
        
        Contract_Product__c contractProduct2 = new Contract_Product__c();
        contractProduct2.Contract__c = contract.Id;
        contractProduct2.Product__c = product2.Id;
        contractProducts.add(contractProduct2);
        
        Test.startTest();
        
        insert contractProducts;
        
        contract = [select Id, Product_Text__c from DContract__c where id =: contract.Id];
        
        System.assert(contract.Product_Text__c != null &&
                      contract.Product_Text__c.indexOf('Product2') != -1 &&
                      contract.Product_Text__c.indexOf('Product1') != -1);
        
        Test.stopTest();   
    }
    
    static testMethod void updateContractProductTest() {
        
        DContract__c contract = new DContract__c();
        contract.Name = 'Test';
        insert contract;
        
        Product2 product = new Product2();
        product.Name = 'Product1';
        insert product;
        
        Product2 product2 = new Product2();
        product2.Name = 'Product2';
        insert product2;
        
        Contract_Product__c contractProduct = new Contract_Product__c();
        contractProduct.Contract__c = contract.Id;
        contractProduct.Product__c = product.Id;
        insert contractProduct;
        
        Test.startTest();
        
        contract = [select Id, Product_Text__c from DContract__c where id =: contract.Id];
        System.assertEquals(contract.Product_Text__c, 'Product1');
        
        contractProduct.Product__c = product2.Id;
        update contractProduct;
        
        contract = [select Id, Product_Text__c from DContract__c where id =: contract.Id];
        System.assertEquals(contract.Product_Text__c, 'Product2');
        
        Test.stopTest();   
    }
    
    static testMethod void deleteContractProductTest() {
        
        DContract__c contract = new DContract__c();
        contract.Name = 'Test';
        insert contract;
        
        Product2 product = new Product2();
        product.Name = 'Product1';
        insert product;
        
        Product2 product2 = new Product2();
        product2.Name = 'Product2';
        insert product2;
        
        Contract_Product__c contractProduct1 = new Contract_Product__c();
        contractProduct1.Contract__c = contract.Id;
        contractProduct1.Product__c = product.Id;
        insert contractProduct1;
        
        Contract_Product__c contractProduct2 = new Contract_Product__c();
        contractProduct2.Contract__c = contract.Id;
        contractProduct2.Product__c = product2.Id;
        insert contractProduct2;
        
        Test.startTest();
        
        contract = [select Id, Product_Text__c from DContract__c where id =: contract.Id];
        System.assert(contract.Product_Text__c != null &&
              contract.Product_Text__c.indexOf('Product2') != -1 &&
              contract.Product_Text__c.indexOf('Product1') != -1);

        delete contractProduct2;
        
        contract = [select Id, Product_Text__c from DContract__c where id =: contract.Id];
        System.assertEquals(contract.Product_Text__c, 'Product1');
        
        Test.stopTest();   
    }
}