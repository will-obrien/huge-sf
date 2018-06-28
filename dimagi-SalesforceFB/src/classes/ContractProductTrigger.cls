/**
 * Updates Contract Product_Text__c field with the names of the Contract Products
 *
 * @author  Virginia Fernández
 * @date    04/11/2013
 */
public with sharing class ContractProductTrigger {

    public void updateProductName(Contract_Product__c[] contractProducts) {
        List<Id> contractsIds = new List<Id>();
    	
    	for (Contract_Product__c product : contractProducts) {
    	   	contractsIds.add(product.Contract__c);
    	}
    	
        List<DContract__c> contracts = [select Id, Product_Text__c,
                                               (select Product__c from Products__r)
                                        from DContract__c 
                                        where id in :contractsIds];
                                        
        List<Id> productsIds = new List<Id>();
        
        for (DContract__c contract : contracts) {
        	for (Contract_Product__c contractProduct: contract.Products__r) {
        		productsIds.add(contractProduct.Product__c);
        	}
        }
        
        List<Product2> products = [select Id, Name from Product2 where id in :productsIds];
        
        Map<Id, String> productNameById = new Map<Id, String>();
        
        for (Product2 product : products) {
            productNameById.put(product.Id, product.Name);
        }
        
        for (DContract__c contract: contracts) {
        	List<Contract_Product__c> contrProds = contract.Products__r;
        	contract.Product_Text__c = '';
        	
        	for (Contract_Product__c contrProd : contrProds) {
        		if (!contract.Product_Text__c.equals('') && !contract.Product_Text__c.endsWith('; ')) {
        		  contract.Product_Text__c += '; ';
        		}
        		contract.Product_Text__c += productNameById.get(contrProd.Product__c);
        	}
        }
        
        update contracts;
    	
    }
    
}