@isTest
private class DaikinToolsAssetServiceTest {
    
    static DaikinToolsAssetService.AssetUpdateRequest testRequest;
    static Map<String, DaikinToolsAssetService.Asset_Object> serialNumberToAsset;
    static Map<String, DaikinToolsAssetService.Product_Object> modelNumberToProduct;
    
    static void setupRequest(){
        testRequest = new DaikinToolsAssetService.AssetUpdateRequest();
        testRequest.assets = new List<DaikinToolsAssetService.Asset_Object>();
        
        serialNumberToAsset = new Map<String, DaikinToolsAssetService.Asset_Object>();
        modelNumberToProduct = new Map<String, DaikinToolsAssetService.Product_Object>();
        
        Account assetAccount = TestingUtils.createAccounts(1, '', false)[0];
        assetAccount.name = DaikinToolsAssetService.FUTURE_ASSET_OWNER_ACCOUNT;
        insert assetAccount;
        
        for(integer i =0; i< 10; i++) { 
            DaikinToolsAssetService.Asset_Object assetReq = new DaikinToolsAssetService.Asset_Object();
            assetReq.SerialNumber = 'Serial' + i;
            assetReq.CodeValues = 'Values' + i;
            assetReq.CodeStringFormat = 'Format' + i;
            assetReq.JobName = 'Asset Test' + i;
            assetReq.UnitTag = 'UnitTag' + i;
            assetReq.SalesOrderNumber = 'SalesOrderNumber' + i;
            
            DaikinToolsAssetService.Product_Object productReq = new DaikinToolsAssetService.Product_Object();
            productReq.Manufacturer = 'Manufacturer' + i;
            productReq.Model = 'Model' + i;
            productReq.Description = 'Description' + i;
            productReq.TRCGroup = 'TRCGroup' + i;
            assetReq.Product = productReq;
            
            testRequest.assets.add(assetReq);
            
            modelNumberToProduct.put(productReq.Model, productReq);
            serialNumberToAsset.put(assetReq.serialNumber, assetReq);
        }
        
    }
    
    static testMethod void doPostTest_NoMatchingProducts() {
        setupRequest();
        
        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );
        
        Test.startTest();
            DaikinToolsAssetService.doPost();
        Test.stopTest();
        
        List<Asset> queriedAssets = [Select id, SerialNumber, Code_String_Breakdown__c, Name, 
                              Format_Number__c, Tag__c, SO_Number__c, Job_Name__c 
                              From Asset Where SerialNumber IN: serialNumberToAsset.keyset() ];
        System.AssertEquals(10, queriedAssets.size(), 'An incorrect number of assets created.');
        for(Asset queriedObject : queriedAssets ){
            DaikinToolsAssetService.Asset_Object requestObject  = serialNumberToAsset.get(queriedObject.SerialNumber);
            
            System.AssertEquals(requestObject.SerialNumber, queriedObject.SerialNumber, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.CodeValues, queriedObject.Code_String_Breakdown__c, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.CodeStringFormat, queriedObject.Format_Number__c, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.UnitTag, queriedObject.Tag__c, 'An incorrect SerialNumber set on the asset.');
            
            
        }
        
        List<Product2> queriedProducts = [Select ProductCode, Vendor_Supplier__c, TRC_Group__c, Name
                                     From Product2 Where ProductCode IN: modelNumberToProduct.keyset() ];
        System.AssertEquals(10, queriedProducts.size(), 'An incorrect number of products created.');
        
        for(Product2 queriedObject : queriedProducts ){
            DaikinToolsAssetService.Product_Object requestObject  = modelNumberToProduct.get(queriedObject.ProductCode);
            
            System.AssertEquals(requestObject.Model, queriedObject.ProductCode, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.Manufacturer, queriedObject.Vendor_Supplier__c, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.Model, queriedObject.Name, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.TRCGroup, queriedObject.TRC_Group__c, 'An incorrect SerialNumber set on the asset.');
          
        }
    }
    
    static testMethod void doPostTest_MatchingProducts() {
        setupRequest();
        
        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );
        
        List<Product2> products = new List<Product2>();
        for( DaikinToolsAssetService.Product_Object prodObj : modelNumberToProduct.values() ){
            Product2 newProduct = new Product2(Name = prodObj.model, ProductCode = prodObj.model, Vendor_Supplier__c = prodObj.Manufacturer, TRC_Group__c = prodObj.trcGroup);
            products.add(newProduct);
        }
        
        insert products; 
                
        Test.startTest();
            DaikinToolsAssetService.doPost();
        Test.stopTest();
        
        List<Asset> queriedAssets = [Select id, Name, SerialNumber, Code_String_Breakdown__c, 
                                     Format_Number__c, Tag__c, SO_Number__c, Job_Name__c 
                                     From Asset Where SerialNumber IN: serialNumberToAsset.keyset() ];
        System.AssertEquals(10, queriedAssets.size(), 'An incorrect number of assets created.');
        for(Asset queriedObject : queriedAssets ){
            DaikinToolsAssetService.Asset_Object requestObject  = serialNumberToAsset.get(queriedObject.SerialNumber);
            
            System.AssertEquals(requestObject.SerialNumber, queriedObject.SerialNumber, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.CodeValues, queriedObject.Code_String_Breakdown__c, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.CodeStringFormat, queriedObject.Format_Number__c, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.UnitTag, queriedObject.Tag__c, 'An incorrect SerialNumber set on the asset.');
            
            
        }
        
        List<Product2> queriedProducts = [Select ProductCode, Vendor_Supplier__c, TRC_Group__c, Name From Product2 ];
        
        System.AssertEquals(10, queriedProducts.size(), 'An incorrect number of products created.');
        System.AssertEquals(Pluck.ids(products), Pluck.ids(queriedProducts), 'An incorrect list of products have been queried.');
        
        for(Product2 queriedObject : queriedProducts ){
            DaikinToolsAssetService.Product_Object requestObject  = modelNumberToProduct.get(queriedObject.ProductCode);
            
            System.AssertEquals(requestObject.Model, queriedObject.ProductCode, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.Manufacturer, queriedObject.Vendor_Supplier__c, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.Model, queriedObject.Name, 'An incorrect SerialNumber set on the asset.');
            System.AssertEquals(requestObject.TRCGroup, queriedObject.TRC_Group__c, 'An incorrect SerialNumber set on the asset.');
          
        }
    }
    
}