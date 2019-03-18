public with sharing class AssetIntegrationService {
	final static String API_KEY = 's2BgmYYpE0+eh1zVlLiSxOdkVMQr8YdK';

	public static Map<String, Integer> modelNameToNumber;

	public static Intel_TAS_Integration_Setting__c integrationSetting {
		get {
			if (integrationSetting == NULL) 
				integrationSetting = Intel_TAS_Integration_Setting__c.getInstance();
			return integrationSetting;
		} set;
	}
	
	public static List<String> filterFields {
		get {
			if (filterFields == NULL) {
				filterFields = new List<String>();
				for (Schema.FieldSetMember entry : SObjectType.Asset.FieldSets.Intel_Integration_Fields.getFields())
					filterFields.add(entry.getFieldPath());
			}
			return filterFields;
		}  set;
	}

	public static Map<String, String> fieldMapping {
		get {
			if (fieldMapping == NULL) {
				fieldMapping = new Map<String, String>();
				for (Intel_TAS_Integration_Field_Map__c setting : Intel_TAS_Integration_Field_Map__c.getAll().values()) {
					fieldMapping.put(setting.Name, setting.Map_To_Key__c);
				}
			}
			return fieldMapping;
		}  set;
	}

	public class AssetModelModel {
		public Integer modelId;
		public String modelNumber;
		public Integer revisionNumber;
		public Integer assetTypeCode;
	}

	public class AssetModel {
		public Integer assetId;
		public String serialNumber;
		public Integer modelId;
		public Integer operatorId;
		public String description;
		public String name;
	}

	public class AssetTagModel {
		public Integer tagId;
		public Integer assetId;
		public String attrKey;
		public String attrValue;
	}

	public class OperatorModel {
		public Integer id;
		public String code;
		public String name;
	}

	/* Status != obsolete */
	/* IE_Asset__c == true */
	public static List<Asset> filterAssetsToSync(List<Asset> newAssets, Map<Id, Asset> oldAssets, List<String> fieldSet) {
		List<Asset> assetsToSync = new List<Asset>();

		if (oldAssets == NULL) {
			for (Asset newAsset : newAssets) {
				if (newAsset.Status != NULL && !newAsset.Status.equalsIgnoreCase('Obsolete') && newAsset.IE_Asset__c != NULL && newAsset.IE_Asset__c) 
					assetsToSync.add(newAsset);
			}
			return assetsToSync;
		}

		for (Asset newAsset : newAssets) {
			if (newAsset.Status != NULL && !newAsset.Status.equalsIgnoreCase('Obsolete') && newAsset.IE_Asset__c != NULL && newAsset.IE_Asset__c) {
				for (String field : fieldSet) {
					if (newAsset.get(field) != oldAssets.get(newAsset.Id).get(field)) {
						assetsToSync.add(newAsset);
						break;
					}
				}
			}
		}

		return assetsToSync;
	}

	public static List<Id> filterProductsWhoseAssetsToSync(List<Product2> newProducts, Map<Id, Product2> oldProducts) {
		List<Id> prodIDs = new List<Id>();
		for (Product2 pr : newProducts) {
			if (pr.ProductCode != oldProducts.get(pr.Id).ProductCode) 
				prodIDs.add(pr.Id);
		}
		return prodIDs;
	}

	public static List<Id> filterAddressesWhoseAssetsToSync(List<Address__c> newAddresses, Map<Id, Address__c> oldAddresses) {
		List<Id> addrId = new List<Id>();
		for (Address__c addr : newAddresses) {
			if (addressChanged(addr, oldAddresses.get(addr.Id)))
				addrId.add(addr.Id);
		}
		return addrId;
	}

	public static List<Id> filterOrdersWhoseAssetsToSync(List<Order__c> newOrders, Map<Id, Order__c> oldOrders, List<String> fieldSet) {
		List<Id> orderIds = new List<Id>();
		for (Order__c order : newOrders) {
			for (String field : fieldSet) {
				if (order.get(field) != oldOrders.get(order.Id).get(field)) {
					orderIds.add(order.Id);	
					break;
				}
			}
		}
		return orderIds;
	}

    private static Boolean addressChanged(Address__c addr1, Address__c addr2) {
        return addr1.Address_Line_1__c != addr2.Address_Line_1__c 
                || addr1.Address_Line_2__c != addr2.Address_Line_2__c 
                || addr1.Address_Line_3__c != addr2.Address_Line_3__c 
                || addr1.Address_Line_4__c != addr2.Address_Line_4__c
                || addr1.City__c != addr2.City__c
                || addr1.State_Province__c != addr2.State_Province__c
                || addr1.Country__c != addr2.Country__c
                || addr1.Postal_Code__c != addr2.Postal_Code__c;
    }
}