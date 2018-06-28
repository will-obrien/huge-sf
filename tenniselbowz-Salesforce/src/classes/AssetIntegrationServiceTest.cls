@isTest
private class AssetIntegrationServiceTest {
	
	static testMethod void testFilter() {
		List<Asset> testAssets = new List<Asset>();

		testAssets.add(new Asset(Status = 'Obsolete', Name='assetName1'));
		testAssets.add(new Asset(Status = 'New', IE_Asset__c = false, Name='assetName2'));
		testAssets.add(new Asset(Status = 'New', IE_Asset__c = true, Name='assetName3'));
		testAssets.add(new Asset(Status = NULL, IE_Asset__c = true, Name='assetName4'));

		TestingUtils.dummyInsert(testAssets);

		Map<Id, Asset> oldMap = new Map<Id, Asset>(testAssets);

		List<Asset> newAssets = testAssets.deepClone(true);

		for (Asset testAsset : newAssets) {
			testAsset.Name += 'modified';
		}

		Test.startTest();
			List<Asset> filteredAssets = AssetIntegrationService.filterAssetsToSync(newAssets, oldMap, new List<String>{'Name'});
		Test.stopTest();

		System.assertEquals(1, filteredAssets.size(), 'Wrong number of assets were filtered');
		System.assertEquals(testAssets[2].Id, filteredAssets[0].Id, 'Wrong asset was filtered');
	}

	static testMethod void testFilterProducts() {
		List<Product2> testProduct2s = new List<Product2>();

		testProduct2s.add(new Product2(ProductCode='1M'));
		testProduct2s.add(new Product2(ProductCode='2M'));
		testProduct2s.add(new Product2(ProductCode='3M'));
		testProduct2s.add(new Product2(ProductCode='4M'));
		testProduct2s.add(new Product2(ProductCode='7M'));

		TestingUtils.dummyInsert(testProduct2s);

		Map<Id, Product2> oldMap = new Map<Id, Product2>(testProduct2s);

		List<Product2> newProds = testProduct2s.deepClone(true);

		newProds[0].ProductCode = '5M';
		newProds[2].ProductCode = '6M';

		Test.startTest();
			List<Id> filteredProducts = AssetIntegrationService.filterProductsWhoseAssetsToSync(newProds, oldMap);
		Test.stopTest();

		System.assertEquals(2, filteredProducts.size(), 'Wrong number of assets were filtered');
	}

	static testMethod void filterAddressChangedTest() {
		List<Address__c> testAddresses = TestingUtils.createAddresses(10, false);
		for (Address__c addr : testAddresses) {
			addr.Address_Line_1__c = '3 Main St';
			addr.Address_Line_2__c = '310';
			addr.Address_Line_3__c = '';
			addr.Address_Line_4__c = '';
			addr.City__c = 'Trenton';
			addr.State_Province__c = 'NJ';
			addr.Country__c = 'USA';
			addr.Postal_Code__c = '12345';			
		}

		TestingUtils.dummyInsert(testAddresses);

		Map<Id, Address__c> testOldMap = new Map<Id, Address__c>(testAddresses.deepClone(true));

		testAddresses[3].Address_Line_1__c = '5 Main St';
		testAddresses[3].Address_Line_2__c = '310';
		testAddresses[3].Address_Line_3__c = '';
		testAddresses[3].Address_Line_4__c = '';
		testAddresses[3].City__c = 'Trenton';
		testAddresses[3].State_Province__c = 'NJ';
		testAddresses[3].Country__c = 'USA';
		testAddresses[3].Postal_Code__c = '12345';

		testAddresses[7].Address_Line_1__c = '3 Main St';
		testAddresses[7].Address_Line_2__c = '310';
		testAddresses[7].Address_Line_3__c = '';
		testAddresses[7].Address_Line_4__c = '';
		testAddresses[7].City__c = 'Trenton';
		testAddresses[7].State_Province__c = 'NYC';
		testAddresses[7].Country__c = 'USA';
		testAddresses[7].Postal_Code__c = '12345';

		Test.startTest();
			List<Id> actualFilteredResult = AssetIntegrationService.filterAddressesWhoseAssetsToSync(testAddresses, testOldMap);
		Test.stopTest();

		System.assertEquals(2, actualFilteredResult.size(), 'There should be two addresses with changed values that passes the filter');
		Set<Id> expectedSet = new Set<Id>{ testAddresses[3].Id, testAddresses[7].Id };
		System.assertEquals(expectedSet, new Set<Id>(actualFilteredResult), 'The expected addresses were not filtered');
	}

}