public without sharing class Case_AssetTriggerHandler {
	
	public static string DUPLICATE_CASE_ASSET_ERROR = 'This Asset is already linked to this Case.  You cannot link a unique Asset to a Case more than once.';
	
	public static void onAfterInsert(map<Id, Case_Asset__c> oldMap, map<Id, Case_Asset__c> newMap)
	{
		validateCaseAsset(newMap.values());
	}
	
	public static void onAfterUpdate(map<Id, Case_Asset__c> oldMap, map<Id, Case_Asset__c> newMap)
	{
		validateCaseAsset(newMap.values());
	}
	
	public static void validateCaseAsset(list<Case_Asset__c> caseAssets)
	{
		set<Id> caseSet = new set<Id>();
		for(Case_Asset__c ca : caseAssets)
		{
			caseSet.add(ca.Case__c);
		}
		
		map<String, Integer> caseAssetCount = new map<String, Integer>();
		
		for(AggregateResult ar : [Select Case__c, Asset__c, count(Id) cnt
		                            from Case_Asset__c
		                           where Case__c in :caseSet
		                        group by Case__c, Asset__c])
		{
			Integer caCount = (Integer)ar.get('cnt');
			String caseId = (String)ar.get('Case__c');
			String assetId = (String)ar.get('Asset__c');
			
			if(caCount > 1)
			  caseAssetCount.put(caseId+'-'+assetId, caCount);
		}	
		
		for(Case_Asset__c ca : caseAssets)
		{
			//=================================================================================
	 		// do not allow the same Asset to be added to multiple CaseAssets for the same Case
			if(caseAssetCount.containsKey(ca.Case__c +'-'+ ca.Asset__c))
			   ca.addError(DUPLICATE_CASE_ASSET_ERROR);
			   
		}
		
	}

}