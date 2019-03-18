public with sharing class OrderTriggerHandler {
	public static void onAfterUpdate(map<Id, Order__c> newMap, map<Id, Order__c> oldMap)
	{
		doIntelSync(newMap, oldMap);
	}

    public static void doIntelSync(map<Id, Order__c> newMap, map<Id, Order__c> oldMap) {
        List<Id> ordersChanged = AssetIntegrationService.filterOrdersWhoseAssetsToSync(newMap.values(), oldMap, new List<String>{'Vertical_Market__c'});
        List<Asset> assetsToSync = [ SELECT Id FROM Asset WHERE Order__c in :ordersChanged ];
        for (Asset ast : assetsToSync) {
            ID jobID = System.enqueueJob(new SendAssetToIntel(ast.Id));
            System.debug('jobbbbb: ' + jobID);
        }
    }
}