@isTest
private class IntelTASMethodsLibraryTest {
    static final String BASEURL = 'https://tsttrendanalyticssoftware.intel.com/daikin/';
    static final String APIKEY = 's2BgmYYpE0+eh1zVlLiSxOdkVMQr8YdK';

    class HttpCalloutMockImpl implements HttpCalloutMock {
        String validAPIKey;
        String validBaseURL;

        public HttpCalloutMockImpl( String vBaseURL, String vApiKey ) {
            validBaseURL = vBaseURL;
            validAPIKey = vApiKey;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse resp = new HTTPResponse();

            if (req.getEndpoint().contains(validBaseURL)) {
                if (req.getHeader('API-KEY') == validAPIKey) {
                    if (req.getMethod() == 'GET') {
                        resp.setStatusCode(200);
                    }
                    else if (req.getMethod() == 'POST') {
                        if (!String.isEmpty(req.getBody()) && req.getHeader('Content-Type') == 'application/json')
                            resp.setStatusCode(201);
                        else 
                            resp.setStatusCode(405);
                    }
                    else if (req.getMethod() == 'PUT') {
                        if (!String.isEmpty(req.getBody()) && req.getHeader('Content-Type') == 'application/json')
                            resp.setStatusCode(200);
                        else 
                            resp.setStatusCode(405);
                    } 
                    else {
                        resp.setStatusCode(405);
                    }
                } else {
                    resp.setStatusCode(401);
                }
            } else {
                resp.setStatusCode(404);
            }
            return resp;
        }
    }
    
    static testMethod void getAllAssetModelsTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAllAssetModels(BASEURL, APIKEY);
        Test.stopTest();

        System.assertEquals(200, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAllAssetModelsTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAllAssetModels(BASEURL, APIKEY+'xyz');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAllOperatorsTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAllOperators(BASEURL, APIKEY);
        Test.stopTest();

        System.assertEquals(200, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAllOperatorsTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAllOperators(BASEURL, APIKEY+'xyz');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void createAssetModelTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.createAssetModel(BASEURL, APIKEY, 'N1234P','0', '123');
        Test.stopTest();

        System.assertEquals(201, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void createAssetModelTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.createAssetModel(BASEURL, APIKEY+'xyz', 'N1234P','0', '123');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }

    static testMethod void registerNewAssetTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.registerNewAsset(BASEURL, APIKEY, 'sn1', '123', 'modelName', '456', 'desc1', 'name1');
        Test.stopTest();

        System.assertEquals(201, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void registerNewAssetTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.registerNewAsset(BASEURL, APIKEY+'xyz', 'sn1', '123', 'modelName', '456',
                'desc1', 'name1');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void updateAssetTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.updateAsset(BASEURL, APIKEY, '789', 'sn1', '123', 'modelName', '456', 'desc1', 'name1');
        Test.stopTest();

        System.assertEquals(200, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void updateAssetTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.updateAsset(BASEURL, APIKEY+'xyz', '789', 'sn1', 'modelName', '123', '456',
                'desc1', 'name1');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAssetByIdTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAssetById(BASEURL, APIKEY, '789');
        Test.stopTest();

        System.assertEquals(200, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAssetByIdTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAssetById(BASEURL, APIKEY+'xyz', '789');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAssetBySerialNumberTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAssetBySerialNumber(BASEURL, APIKEY, '789');
        Test.stopTest();

        System.assertEquals(200, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAssetBySerialNumberTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAssetBySerialNumber(BASEURL, APIKEY+'xyz', '789');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAllAssetsTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAllAssets(BASEURL, APIKEY);
        Test.stopTest();

        System.assertEquals(200, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAllAssetsTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAllAssets(BASEURL, APIKEY+'xyz');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAssetsByModelIdsTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAssetsByModelIds(BASEURL, APIKEY, new List<String>{'1234'});
        Test.stopTest();

        System.assertEquals(200, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAssetsByModelIdsTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAssetsByModelIds(BASEURL, APIKEY+'xyz', new List<String>{'1234'});
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAssetsByOperatorIdsTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAssetsByOperatorIds(BASEURL, APIKEY, '1234');
        Test.stopTest();

        System.assertEquals(200, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAssetsByOperatorIdsTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAssetsByOperatorIds(BASEURL, APIKEY+'xyz', '1234');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAssetTagsByAssetIdTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAssetTagsByAssetId(BASEURL, APIKEY, '1234');
        Test.stopTest();

        System.assertEquals(200, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void getAssetTagsByAssetIdTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.getAssetTagsByAssetId(BASEURL, APIKEY+'xyz', '1234');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void createAssetTagTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.createAssetTag(BASEURL, APIKEY, '1234', 'key1', 'val1');
        Test.stopTest();

        System.assertEquals(201, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void createAssetTagTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.createAssetTag(BASEURL, APIKEY+'xyz', '1234', 'key1', 'val1');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void updateAssetTagTest_Success() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.updateAssetTag(BASEURL, APIKEY, '1234', '343', 'key1', 'val1');
        Test.stopTest();

        System.assertEquals(200, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
    static testMethod void updateAssetTagTest_Fail() {
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock );
            IntelTASResponseObject result = IntelTASMethodsLibrary.updateAssetTag(BASEURL, APIKEY+'xyz', '1234', '343', 'key1', 'val1');
        Test.stopTest();

        System.assertEquals(401, result.getResponseCode(), 'If the endpoint is valid and header has the correct API, the mock class should return 200');
    }
    
}