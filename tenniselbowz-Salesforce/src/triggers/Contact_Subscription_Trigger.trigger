trigger Contact_Subscription_Trigger on Contact_Subscription__c (after insert, after update) {

	if(TriggerUtility.limitIeServiceIntegration || TriggerUtility.limitIntegrationBatch){
				
			return;
	} 
		
	
	list<Contact> ieContacts = new list<Contact>();
	set<Id> ContactIds = new set<Id>();
	
	for(Contact_Subscription__c aa : trigger.new)
	{
		ContactIds.add(aa.Contact__c);
	}
	
	for(Contact a : [Select Id from Contact where Ie_Contact__c = true and IE_Sync_Status__c != 'Pending' and Id in :ContactIds])
	{
		a.IE_Sync_Status__c = 'Pending';
		ieContacts.add(a);
	}
	
	if(ieContacts.size() > 0)
		update ieContacts;
}