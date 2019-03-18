trigger SGLockOpportunityFields on Opportunity (before update) {
    //Get Set of the Opportunities in Trigger.new account ids for the CONMAN_Contract__c query
    Set<Id> accountIds = new Set<id>();
    for (Opportunity o : Trigger.new) {
        accountIds.add(o.AccountId);        
    }
    
    //Query for list of CONMAN_Contract__c records related to the Contact's Account
    List<CONMAN_Contract__c> contractList = [SELECT Account_Name__r.id, Contract_Status__c, CreatedDate from CONMAN_Contract__c WHERE Account_Name__r.id IN : accountIds];

    //Check to make sure that this contact is associated to an account with a CONMAN_Contract__c record.
    if (contractList.size()>0) {

    	//Create a Map with the Contract's Account Id as the key, and the CONMAN_Contract__c record as the value
    	Map<Id, CONMAN_Contract__c> contractMap = new Map<Id, CONMAN_Contract__c>();
    	for (CONMAN_Contract__c contract : contractList) {
        	contractMap.put(contract.Account_Name__r.id, contract);
    	}
        
        for (Opportunity o : Trigger.new) {
        	//Get UserName of editing user
        	String userName = UserInfo.getUserName();
        	//Get Contract Status of Contract where CONMAN_Contract__c.Account_Name__r.id == c.AccountId
        	String contractStatus = contractMap.get(o.AccountId).Contract_Status__c;
        	//Determine mins difference between now and CONMAN_Contract__c.CreatedDate
        	decimal minsdifference = ((datetime.now().getTime())/1000/60) - ((contractMap.get(o.AccountId).CreatedDate.getTime())/1000/60);
        	System.debug('minsdifference: ' + minsdifference);
        	//Get the old Contact (contact prior to the edit)
        	Opportunity oldOpportunity = Trigger.oldMap.get(o.id);
			//Check to see that contact meets criteria for field locking
        	if (o.z_source__c == 'Salesgateway' && userName != 'eCommerce Customer' && contractStatus == 'Sent To Customer') {
         	//Check individual lock conditions
            	//Opportunity name
         		if(oldOpportunity.name != o.name) {
                    if(!Test.isRunningtest())
           				o.name.addError('Opportunity Name cannot be changed until customer Accepts/Rejects contract in Sales gateway'); 
         		} 
        	}
        }
    }
}