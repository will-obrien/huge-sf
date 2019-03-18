trigger Booking_OnAfterInsert on Booking__c (after insert) {
	//update account's "Working with Since" field when a booking related to the account is created 
	Set<Id> bookingIds = new Set<Id>();
	Map<Id, Datetime> agencies = new Map<Id, Datetime>();
	for(Booking__c b : trigger.new){
		bookingIds.add(b.Id);	
	}
	
	for(Booking__c b: [select Id, CreatedDate, 
                                 Agent__r.Account.Working_with_Since__c, Agent__r.AccountId 
                                 from Booking__c
                                 where Id in :bookingIds]){
		if (b.Agent__r.Account.Working_with_Since__c == null){
			agencies.put(b.Agent__r.AccountId, b.CreatedDate);
		}
	} 	
    
    List<Account> accounts = new List<Account>();
	for(Account a: [select Id, Working_with_Since__c
                             from Account
                             where Id in :agencies.keySet()]){
		a.Working_with_Since__c = agencies.get(a.Id);
		accounts.add(a);
	}                             	
	Update accounts;
}