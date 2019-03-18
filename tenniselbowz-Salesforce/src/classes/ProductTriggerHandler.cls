public without sharing class ProductTriggerHandler {
//This class is called by the trigger and the purpose of this code is to prevent Productname update by the Salesforce UserInterface user.-*/
    public static void onBeforeUpdate(map<Id, Product2> newMap, map<Id, Product2> oldMap){
		for(Product2 UpdateToOldName: newMap.values()){				//Iterating through each new value in the map
			//if old map in not mull and check if the new product name is different from new product name i.e, if the product name is modified by the User Interface. Then execute through the if condition
            if(oldMap!=null && oldMap.get(UpdateToOldName.Id).Name!=UpdateToOldName.name && UserInfo.getProfileId().substring(0,15) == '00eC0000001GSlm')
				UpdateToOldName.name = oldMap.get(UpdateToOldName.Id).name;			//Here we're updating the product name to old name

		}
 
    }

    public static void onAfterUpdate(map<Id, Product2> newMap, map<Id, Product2> oldMap){
		List<Id> prodIds = AssetIntegrationService.filterProductsWhoseAssetsToSync(newMap.values(), oldMap);

		String qry = 'SELECT Id, Status, IE_Asset__c';
		if (!AssetIntegrationService.filterFields.isEmpty())
 			qry += ', ' + String.join(AssetIntegrationService.filterFields, ', ');
 		qry += ' FROM Asset WHERE Product2Id in :prodIds';

 		List<Asset> assetsToSync = (List<Asset>)Database.query(qry);

 		AssetTriggerHandler.doIntelSync(new Map<Id, Asset>(assetsToSync), NULL);
    }
}