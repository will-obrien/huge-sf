public without sharing class SubscriptionTriggerHandler {
	
	public static void onBeforeUpdate(map<Id, Subscription__c> newMap, map<Id, Subscription__c> oldMap)
	{
		setIeSyncStatus(newMap.values(), oldMap);
	}
	
	public static void onBeforeInsert(list<Subscription__c> newList)
	{
		setStartEndSubscriptionDates(newList);
		setIeSyncStatus(newList, null);
	}
	
	public static void onBeforeDelete(map<Id, Subscription__c> oldMap)
	{
		for(Subscription__c s : oldMap.values())
		{
			if( s.Record_Usage__c != null)
				s.addError('This record cannot be deleted because it is integrated with other systems or tied to other critical information within Salesforce.');
				
		}
		
	}
	
	public static void setIeSyncStatus(list<Subscription__c> newlist, map<Id, Subscription__c> oldMap)
	{
		   
		for(Subscription__c a : newList)
		{
			if(a.IE_Subscription__c 
			   && (oldMap == null || oldMap.get(a.Id).IE_Sync_Status__c != 'Pending')
			   && a.IE_Sync_Status__c != 'Pending'
			   && !(TriggerUtility.limitIeServiceIntegration || TriggerUtility.limitIntegrationBatch))
		    {
				a.IE_Sync_Status__c = 'Pending';
		    }
		    
		    if(a.IE_Subscription__c)
		    {
				if(a.Record_Usage__c != null && !a.Record_Usage__c.contains('IE'))
					a.Record_Usage__c +=  ';IE';
				else if(a.Record_Usage__c == null)
					a.Record_Usage__c =  'IE';
		    }
		}
		
	}
	
	public static void setStartEndSubscriptionDates(list<Subscription__c> subscriptions)
	{
		/*
			Asset.Commissioned__c = true
			Asset.Commissioned__c was previously true
			Asset.Subscription__c.StartDate__c = null
			Asset.Subscription__c.Type__c  != 'Daikin'
			
		 */
		 map<Id, Asset> assetMap = new map<Id, Asset>(); 
		 set<Id> assetIds = new set<Id>();
		 for(Subscription__c s : subscriptions)
		 {
		 	if(s.Asset__c != null && s.Type__c  != 'Daikin' && s.Start_Date__c == null)
		 		assetIds.add(s.Asset__c);
		 }
		 
		 //retrieve the associated Assets
		 for(Asset a : [Select Id from Asset where Id in :assetIds and Commissioned__c = true])
		 	assetMap.put(a.Id, a);
		 
		 for(Subscription__c s : subscriptions)
		 {
		 	if(assetMap.containsKey(s.Asset__c))
		 	{
		 		s.Start_Date__c = system.today();
				s.End_Date__c = system.today().addDays( Integer.ValueOf(365 * (s.Term_Years__c==null ? 1 :s.Term_Years__c) ));
				s.Active__c = true;
		 	}
		 		
		 }	
		 
		 
		 
	}

}