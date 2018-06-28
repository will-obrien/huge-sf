trigger ContractProduct on Contract_Product__c (after delete, after insert, after update) {
	ContractProductTrigger contractProduct = new ContractProductTrigger(); 
    if (Trigger.isDelete) {
    	contractProduct.updateProductName(Trigger.old);
    }
    else 
        contractProduct.updateProductName(Trigger.new);    	
    
}