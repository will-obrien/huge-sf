@RestResource(urlMapping='/AssetIntegrationService')
global with sharing class DaikinToolsAssetService {
    
    public static final string FUTURE_ASSET_OWNER_ACCOUNT = 'FUTURE ASSET OWNER ACCOUNT';
    public static Account assetAccount{
        get{
            if(assetAccount == null){
                assetAccount = new Account();
                List<Account> accounts = [Select id from Account where Name =: FUTURE_ASSET_OWNER_ACCOUNT limit 1];
                if(!accounts.isempty()){
                    assetAccount = accounts[0];
                }
            }
            return assetAccount;
        }set;
    }
    
    @HttpPost
    global static void doPost()
    {
        
        AssetUpdateRequest theRequest = (AssetUpdateRequest)JSON.deserializeStrict(RestContext.request.requestBody.toString(), AssetUpdateRequest.class);
        
        Asset_Response theResponse = new Asset_Response();
        theResponse.errors = new List<Response_Error>();
        theResponse.assets = new List<Response_Asset>();
   
        
        
        Set<String> productModelNumbers = new Set<String>();
        Set<String> productVendorNumbers = new Set<String>();
        List<Asset> assetsToInsert = new List<Asset>();
        
        Map<String, List<Asset>> vendorModelToAssetMap = new Map<String, List<Asset>>();
        
        for(Asset_Object assetRequestObj :  theRequest.assets){
            Asset assetObj = new Asset();
            assetObj.SerialNumber = assetRequestObj.SerialNumber;
            assetObj.Code_String_Breakdown__c = assetRequestObj.CodeValues;
            assetObj.Format_Number__c = assetRequestObj.CodeStringFormat;
            assetObj.Tag__c = assetRequestObj.UnitTag;
            assetObj.accountid = assetAccount.id;
            
            if(assetRequestObj.product != null) { 
                String vendorModel = assetRequestObj.product.Manufacturer + '-' + assetRequestObj.product.Model;
                assetObj.name = assetRequestObj.product.Model;
                assetObj.product2= new Product2(TRC_Group__C = assetRequestObj.product.TRCgroup);
                
                if(vendorModelToAssetMap.containsKey(vendorModel)){
                    vendorModelToAssetMap.get(vendorModel).add(assetObj);
                } else {
                    vendorModelToAssetMap.put(vendorModel, new List<Asset>{assetObj});
                }
            }
        }
        
        List<Product2> products = [Select id, Vendor_And_Model_Number__c from Product2 where Vendor_And_Model_Number__c IN : vendorModelToAssetMap.keyset() ];
        Map<String, List<Product2>> vendorModelToProductMap = GroupBy.strings('Vendor_And_Model_Number__c', products );
        
        List<Product2> productsToInsert = new List<Product2>();
        
        for (String vendorAndModel : vendorModelToAssetMap.keyset()){
            if(!vendorModelToProductMap.containsKey(vendorAndModel) && (String.isNotBlank(vendorAndModel)) ){
                List<String> vendorAndModelStrings = vendorAndModel.split('-');
                List<Asset> assets = vendorModelToAssetMap.get(vendorAndModel);
                if(vendorAndModelStrings.size() == 2 && (!assets.isEmpty()) ){
                    
                    Product2 newProduct = new Product2(Vendor_Supplier__c = vendorAndModelStrings[0], Name = vendorAndModelStrings[1], ProductCode = vendorAndModelStrings[1]);
                    newProduct.TRC_GRoup__c = assets[0].product2.TRC_Group__c;
                    productsToInsert.add(newProduct);
                    vendorModelToProductMap.put(vendorAndModel, new List<Product2>{newProduct});
                }
            }
        }
        try{
            insert productsToInsert;
        } catch (DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                Response_Error error = new Response_Error();
                error.ErrorMessages = e.getDmlMessage(i);
                error.ErrorCode = 'Insert_Error';
                theResponse.errors.add(error);
            }            
        }
        
        for(String vendorAndModel : vendorModelToAssetMap.keyset()){
            List<Asset> assets = vendorModelToAssetMap.get(vendorAndModel);
            if(vendorModelToProductMap.containsKey(vendorAndModel)){
                Product2 matchingProduct = vendorModelToProductMap.get(vendorAndModel)[0];
                for(Asset ast : assets){
                    ast.product2 = null;
                    ast.product2id = matchingProduct.id;
                    assetsToInsert.add(ast);
                }
            }
        }
        try{
            insert assetsToInsert;
            for(Asset ast : assetsToInsert ){
                Response_Asset responseAsset = new Response_Asset();
                responseAsset.SFDCID = ast.id;
                responseAsset.SerialNumber = ast.SerialNumber;
                theResponse.assets.add(responseAsset);
            }
        } catch (DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                Response_Error error = new Response_Error();
                error.ErrorMessages = e.getDmlMessage(i);
                error.ErrorCode = 'Insert_Error';
                theResponse.errors.add(error);
            }            
        }
        
        RestContext.response.responseBody = Blob.valueOf( JSON.serialize(theResponse) );
        RestContext.response.addHeader( 'Content-Type', 'application/json' );
    }
    
  
    
    public class AssetUpdateRequest{
        public List<Asset_Object> assets;
    }
    
    public class Asset_Object{
        public String SerialNumber;
        public String CodeValues;
        public String CodeStringFormat;
        public String UnitTag;
        public String SalesOrderNumber;
        public String JobName;
        public Product_Object Product;
        
    }
    public class Product_Object{
        public string Manufacturer;
        public string Model;
        public string Description;
        public string TRCGroup;
    }
    
    public class Asset_Response{
        public List<Response_Error> errors;
        public List<Response_Asset> assets;
    }
    public class Response_Asset{
        public string SFDCID;
        public string SerialNumber;
    }
    
    public class Response_Error
    {
        public String ErrorMessages;
        public String ErrorCode;
    }
    
    
}