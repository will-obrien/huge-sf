global class FindDupContacts implements Database.Batchable<sObject> {
	static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	static Id accountOrganizationTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();

    global Database.QueryLocator start(Database.BatchableContext BC){
    	List<PotentialDupContact__c> dupList = new List<PotentialDupContact__c>([
    		SELECT Id FROM PotentialDupContact__c
    	]);
    	delete dupList;
    	
        return Database.getQueryLocator([
            SELECT Id FROM Account WHERE RecordTypeId in (:accountHouseholdTypeId, :accountOrganizationTypeId)
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Id> accountList = new List<Id>();
        for(sObject obj : scope) {
            Account account = (Account) obj;
            accountList.add(account.Id);
        }
        List<PotentialDupContact__c> dupList = new List<PotentialDupContact__c>();
        
        List<Contact> contactList = new List<Contact> ([
        	SELECT Id, AccountId, FirstName, LastName
        	FROM Contact
        	WHERE AccountId in :accountList
        	ORDER BY AccountId
        ]);

        String firstName;
        String lastName;
        Id acctId, lastContactId; 
        
        for(Contact ct : contactList) {
        	if(ct.AccountId == acctId) {
        		if(ct.FirstName == firstName && ct.LastName == lastName) {
        			PotentialDupContact__c dup = new PotentialDupContact__c(
        				Account__c = ct.AccountId,
        				Contact1__c = lastContactId,
        				Contact2__c = ct.Id
        			);
        			dupList.add(dup);
        		}
        	}
    		firstName = ct.FirstName;
    		lastName = ct.LastName;
        	acctId = ct.AccountId;
        	lastContactId = ct.Id;
        }
        insert dupList;
    }    	

    global void finish(Database.BatchableContext BC){
    }
}