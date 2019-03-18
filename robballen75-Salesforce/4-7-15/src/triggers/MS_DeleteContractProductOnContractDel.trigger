// *********************************************************************************** 
//  MS_DeleteContractProductOnContractDel
//  
//  This trigger ensures that all contract_products associated with contracts are 
//  deleted when the parent contract is deleted.
//   
//  History:
//  4/2/10 Robb Allen - Created
// ***********************************************************************************


trigger MS_DeleteContractProductOnContractDel on Contract (before delete) {

Set <string> ContractIds = new Set<string>();
	for (contract myContracts : Trigger.old) 
		{
			ContractIds.add(myContracts.id);
			system.debug('ALERT: adding contract to set with ID of:' + myContracts.id);
		}

		contract_product__c[] existingCPs = [select id from contract_product__c where contract__c in :ContractIds];
				//for (contract_product__c existingCPs : [select id from contract_product__c where contract__c in :ContractIds]){ 
				//system.debug('ALERT:deleting cp:' + existingCPs.id);
				//delete existingCPs;
				
			//	}
		//system.debug('ALERT-Deleting ContractProducts for a contract detlete.');
	
		delete existingCPs;
	

}