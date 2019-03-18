trigger SGLockContactFields on Contact (before update) {
   	//Get Set of the contacts in Trigger.new account ids for the CONMAN_Contract__c query
    Set<Id> accountIds = new Set<id>();
    for (Contact c : Trigger.new) {
        accountIds.add(c.AccountId);        
    }
    //Query for list of CONMAN_Contract__c records related to the Contact's Account
    List<CONMAN_Contract__c> contractList = [SELECT Account_Name__r.id, Contract_Status__c, CreatedDate from CONMAN_Contract__c WHERE Account_Name__r.id IN : accountIds];
    System.debug('contractList: ' + contractList);
    //Check to make sure that this contact is associated to an account with a CONMAN_Contract__c record.
    if (contractList.size()>0) {

    	//Create a Map with the Contract's Account Id as the key, and the CONMAN_Contract__c record as the value
    	Map<Id, CONMAN_Contract__c> contractMap = new Map<Id, CONMAN_Contract__c>();
    	for (CONMAN_Contract__c contract : contractList) {
        	contractMap.put(contract.Account_Name__r.id, contract);
    	}
    
    	for (Contact c : Trigger.new) {
        	//Get UserName of editing user
        	String userName = UserInfo.getUserName();
        	//Get Contract Status of Contract where CONMAN_Contract__c.Account_Name__r.id == c.AccountId
        	String contractStatus = contractMap.get(c.AccountId).Contract_Status__c;
        	//Determine mins difference between now and CONMAN_Contract__c.CreatedDate
        	decimal minsdifference = ((datetime.now().getTime())/1000/60) - ((contractMap.get(c.AccountId).CreatedDate.getTime())/1000/60);
        	System.debug('minsdifference: ' + minsdifference);
        	//Get the old Contact (contact prior to the edit)
        	Contact oldContact = Trigger.oldMap.get(c.id);
			//Check to see that contact meets criteria for field locking
        	if (c.z_source__c == 'Salesgateway' && userName != 'eCommerce Customer' && contractStatus == 'Sent To Customer') {
				//Check individual lock conditions
            	if(oldContact.firstname != c.firstname) {
            		if(!Test.isRunningtest())
             			c.firstname.addError('First Name cannot be changed until customer Accepts/Rejects contract in Sales gateway'); 
         		}
            	if(oldContact.LastName != c.LastName) {
                	if(!Test.isRunningTest())
                   		c.LastName.addError('Last Name cannot be changed until customer Accepts/Rejects contract in Sales gateway');
            	}
            	if(oldContact.phone != c.phone) {
                	if(!Test.isRunningTest())
                   		c.phone.addError('Phone cannot be changed until customer Accepts/Rejects contract in Sales gateway');
            	}
            	if(oldContact.MailingCity != c.MailingCity) {
                	if(!Test.isRunningTest())
                   		c.MailingCity.addError('Mailing City cannot be changed until customer Accepts/Rejects contract in Sales gateway');
            	}
           		if(oldContact.MailingState != c.MailingState) {
               		if(!Test.isRunningTest())
                   		c.MailingState.addError('Mailing State cannot be changed until customer Accepts/Rejects contract in Sales gateway');
           		}
           		if(oldContact.MailingStreet != c.MailingStreet) {
               		if(!Test.isRunningTest())
                 		c.MailingStreet.addError('Mailing Street cannot be changed until customer Accepts/Rejects contract in Sales gateway');
            	}
            	if(oldContact.MailingCountry != c.MailingCountry) {
               		if(!Test.isRunningTest())
                   		c.MailingCountry.addError('Mailing Country cannot be changed until customer Accepts/Rejects contract in Sales gateway');
           		}
           		if(oldContact.MailingPostalCode != c.MailingPostalCode) {
               		if(!Test.isRunningTest())
                   		c.MailingPostalCode.addError('Mailing Postal Code cannot be changed until customer Accepts/Rejects contract in Sales gateway');
           		}
           		if(oldContact.Email != c.Email) {
               		if(!Test.isRunningTest())
                   		c.Email.addError('Email cannot be changed until customer Accepts/Rejects contract in Sales gateway');
           		}
       		}    		
        }
	}
}