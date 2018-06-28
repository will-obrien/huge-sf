trigger ProjectProduct on Project_Product__c (after insert, after update, after delete) {
	    DeploymentProductTrigger deploymentProduct = new DeploymentProductTrigger();
		if (Trigger.isDelete) {
			deploymentProduct.updateProductName(Trigger.old);
		}
		else deploymentProduct.updateProductName(Trigger.new);


}