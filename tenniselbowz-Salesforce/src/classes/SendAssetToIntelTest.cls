@isTest
private class SendAssetToIntelTest {
	static final String BASEURL = 'https://tsttrendanalyticssoftware.intel.com/daikin/';
	static final String APIKEY = 's2BgmYYpE0+eh1zVlLiSxOdkVMQr8YdK';
	static final String NEW_APIKEY = 's2BgmYYpE0+eh1zVlLiSxOdkVMQr8YdN';
	static final List<String> TEST_MODEL_NUMBERS = new List<String> {'DPS012AHCY4DV', 'MPS015E', 'DPS003A'};
	static final Set<Integer> TEST_EXISTING_ASSETS = new Set<Integer> {112, 230};
	static final Set<String> TEST_EXISTING_SERIALNUMBERS = new Set<String> {'ABC123', 'XYZ456'};
	static final Set<Integer> TEST_EXISTING_OPERATORS = new Set<Integer> {1, 0, 3};
	static final Integer TEST_NEW_ASSET_ID = 121;
	static final String SAMPLE_EXISTING_ASSET = '[{"assetId" : 112,  "serialNumber" : "asdf",  "modelId" : 1234,  "operatorId" : 1,  "description" : "desc",  "name" : "abc" }]';
	static final String SAMPLE_NEW_ASSET = '\'{\'"assetId" : {0},  "serialNumber" : "{1}",  "modelId" : {2},  "operatorId" : {3},  "description" : "{4}",  "name" : "{6}" }';
	static final Integer TEST_NEW_TAG_ID = 1151;
	static final Integer TEST_EXISTING_TAG_ID = 1901;
	static final String SAMPLE_NEW_TAG = '\'{\'"tagId" : {1},  "assetId" : {0},  "attrKey" : "{2}",  "attrValue" : "{3}"}';
	static final Integer TEST_NEW_MODEL_ID = 77;
	static final String SAMPLE_NEW_MODEL = '\'{\' "modelId" : {0}, "modelNumber" : "{1}", "revisionNumber" : 0, "assetTypeCode" : 0 }';
	static final String SAMPLE_MODEL_LIST = '[\'{\'  "modelId" : 1,  "modelNumber" : "{0}",  "revisionNumber" : 1,  "assetTypeCode" : 28022},\'{\'  "modelId" : 13,  "modelNumber" : "{1}",  "revisionNumber" : 1,  "assetTypeCode" : 28023},\'{\'  "modelId" : 17,  "modelNumber" : "{2}",  "revisionNumber" : 1,  "assetTypeCode" : 28025}]';
	static final Integer TEST_ASSET_W_TAGS = 112;
	static final Integer TEST_ASSET_NO_TAGS = 230;
	static final List<String> TEST_TAG_KEYS = new List<String> {'ABC', 'DEF', 'GHI'};
	static final String SAMPLE_TAG_LIST = '[\'{\'  "tagId" : 27,  "assetId" : {0},  "attrKey" : "{1}",  "attrValue" : "dfdf"},\'{\'  "tagId" : 29,  "assetId" : {0},  "attrKey" : "{2}",  "attrValue" : "1234"},\'{\'  "tagId" : 31,  "assetId" : {0},  "attrKey" : "{3}",  "attrValue" : "key2value"}]';
	static final Integer TEST_NEW_OPERATOR_ID = 2;
	static final String SAMPLE_NEW_OPERATOR = '\'{\' "id" : {0}, "code" : "{1}", "name" : somename }';
	static final String SAMPLE_OPERATOR_LIST = '[\'{\' "id" : 0, "code" : "Test1Op", "name" : somename },\'{\' "id" : 1, "code" : "Test2Op", "name" : somename },\'{\' "id" : 3, "code" : "Test3Op", "name" : somename }]';
	static final String LOGIN_NAME = 'Mr Login';
	static final String PASSWORD = 'unsafepassword';



	class HttpCalloutMockImpl implements HttpCalloutMock {
		String validAPIKey;
		String validBaseURL;

		public HttpCalloutMockImpl( String vBaseURL, String vApiKey ) {
			validBaseURL = vBaseURL;
			validAPIKey = vApiKey;
		}

		String constructResponseModel(AssetIntegrationService.AssetModelModel mdl) {
			return String.format(SAMPLE_NEW_MODEL, new List<String>{String.valueOf(mdl.modelId), mdl.modelNumber});
		}

		String constructResponseAsset(AssetIntegrationService.AssetModel mdl) {
			return String.format(SAMPLE_NEW_ASSET, new List<String>{String.valueOf(mdl.assetId), mdl.serialNumber, String.valueOf(mdl.modelId), String.valueOf(mdl.operatorId), mdl.description, mdl.name});
		}

		String constructResponseAssetTag(AssetIntegrationService.AssetTagModel mdl) {
			return String.format(SAMPLE_NEW_TAG, new List<String>{String.valueOf(mdl.assetId), String.valueOf(mdl.tagId), mdl.attrKey, mdl.attrValue});
		}

		public HTTPResponse respond(HTTPRequest req) {
	        HTTPResponse resp = new HTTPResponse();

	        if (req.getEndpoint().contains(validBaseURL)) {
	        	if (req.getEndpoint().contains('/rest/apiKeys/')) {
	        		if (req.getHeader('Login-Name') == LOGIN_NAME && req.getHeader('Password') == PASSWORD) {
	        			resp.setStatusCode(200);
	        			if (req.getEndPoint().contains('create=no')) {
		        			Long expirationTime = Datetime.now().getTime();
		        			resp.setBody('[{"apiKey": "' + APIKEY + '", "expirationTime": ' + expirationTime + '}]');
	        			} else if (req.getEndPoint().contains('create=yes')) {
	        				Long expirationTime = Datetime.now().addDays(10).getTime();
		        			resp.setBody('[{"apiKey": "' + NEW_APIKEY + '", "expirationTime": ' + expirationTime + '}]');
	        			}
        			} else {
        				resp.setStatusCode(401);
        			}
	        	} else if (req.getHeader('API-KEY') == validAPIKey) {
	        		if (req.getMethod() == 'GET') {
		        		resp.setStatusCode(200);
		        		if (req.getEndpoint().contains('/rest/assetModels/')) {
		        			resp.setBody(String.format(SAMPLE_MODEL_LIST, TEST_MODEL_NUMBERS));
		        		}
		        		if (req.getEndpoint().contains('/rest/assets/?serialNumber=')) {
		        			if (TEST_EXISTING_SERIALNUMBERS.contains(req.getEndpoint().substringAfter('/rest/assets/?serialNumber='))){
		        				resp.setStatusCode(200);
		        				resp.setBody(SAMPLE_EXISTING_ASSET);
		        			}
		        			else
		        				resp.setStatusCode(404);
		        		}
		        		if (req.getEndpoint().contains('/rest/assetTags/?assetId=')) {
		        			if (TEST_ASSET_W_TAGS == Integer.valueOf(req.getEndpoint().substringAfter('/rest/assetTags/?assetId='))) {
		        				List<String> strToPlug = new List<String>{ String.valueOf(TEST_ASSET_W_TAGS) };
		        				strToPlug.addAll(TEST_TAG_KEYS);
		        				resp.setBody(String.format(SAMPLE_TAG_LIST, strToPlug));
		        			}
		        			else {		        				
		        				resp.setBody('[]');
		        			}
		        		}
	        		}
		        	else if (req.getMethod() == 'POST') {
		        		if (!String.isEmpty(req.getBody()) && req.getHeader('Content-Type') == 'application/json'){
		        			resp.setStatusCode(201);
		        			if (req.getEndpoint().contains('/rest/assetModels/')) {
		        				try {
		        					AssetIntegrationService.AssetModelModel modelDef = 
			        					(AssetIntegrationService.AssetModelModel) JSON.deserializeStrict(req.getBody(), AssetIntegrationService.AssetModelModel.class);
			        				modelDef.modelId = TEST_NEW_MODEL_ID;
				        			resp.setBody(constructResponseModel(modelDef));
				        		} 
				        		catch (JSONException je) {
				        			resp.setStatusCode(400);
				        		}
		        			}
		        			if (req.getEndpoint().contains('/rest/assets/')) {
		        				try {
		        					AssetIntegrationService.AssetModel assetDef = 
			        					(AssetIntegrationService.AssetModel) JSON.deserializeStrict(req.getBody(), AssetIntegrationService.AssetModel.class);
			        				assetDef.assetId = TEST_NEW_ASSET_ID;
				        			resp.setBody(constructResponseAsset(assetDef));
				        		} 
				        		catch (JSONException je) {
				        			resp.setStatusCode(400);
				        		}
		        			}
		        			if (req.getEndpoint().contains('/rest/assetTags/')) {
		        				try {
		        					AssetIntegrationService.AssetTagModel tagDef = 
			        					(AssetIntegrationService.AssetTagModel) JSON.deserializeStrict(req.getBody(), AssetIntegrationService.AssetTagModel.class);
			        				tagDef.tagId = TEST_NEW_TAG_ID;
				        			resp.setBody(constructResponseAssetTag(tagDef));
				        		} 
				        		catch (JSONException je) {
				        			resp.setStatusCode(400);
				        		}
		        			}
		        		}
		        		else 
		        			resp.setStatusCode(405);
		        	}
		        	else if (req.getMethod() == 'PUT') {
		        		if (!String.isEmpty(req.getBody()) && req.getHeader('Content-Type') == 'application/json'){
		        			resp.setStatusCode(200);
		        			if (req.getEndpoint().contains('/rest/assets/')) {
		        				try {
		        					AssetIntegrationService.AssetModel assetDef = 
			        					(AssetIntegrationService.AssetModel) JSON.deserializeStrict(req.getBody(), AssetIntegrationService.AssetModel.class);
			        				assetDef.assetId = Integer.valueOf(req.getEndpoint().substringAfter('/rest/assets/'));
				        			resp.setBody(constructResponseAsset(assetDef));
				        		} 
				        		catch (JSONException je) {
				        			resp.setStatusCode(400);
				        		}
		        			}
		        			if (req.getEndpoint().contains('/rest/assetTags/')) {
		        				try {
		        					AssetIntegrationService.AssetTagModel tagDef = 
			        					(AssetIntegrationService.AssetTagModel) JSON.deserializeStrict(req.getBody(), AssetIntegrationService.AssetTagModel.class);
			        				tagDef.tagId = Integer.valueOf(req.getEndpoint().substringAfter('/rest/assetTags/'));
				        			resp.setBody(constructResponseAssetTag(tagDef));
				        		} 
				        		catch (JSONException je) {
				        			resp.setStatusCode(400);
				        		}
		        			}
		        		}
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
	
	static testMethod void getKeyValuesFromCodeString_Test() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		ast.Current_Code_String_Breakdown__c = '[{"code_sequence":"1","code_value":"DPS","code_description":"UNIT TYPE;whatever"},{"code_sequence":"2","code_value":"015F","code_description":"UNIT SIZE"},{"code_sequence":"3","code_value":"A","code_description":"VINTAGE"},{"code_sequence":"4","code_value":"S","code_description":"COOLING EFFICIENCY"},{"code_sequence":"5","code_value":"H","code_description":"UNIT STYLE"},{"code_sequence":"6","code_value":"G","code_description":"AUXILARY HEAT"},{"code_sequence":"7","code_value":"2D","code_description":"VOLTAGE/POWER CONNECTION"},{"code_sequence":"8","code_value":"V","code_description":"APPLICATION"},{"code_sequence":"9","code_value":"V","code_description":"AIRFLOW PATTERN"},{"code_sequence":"10","code_value":"A","code_description":"CONTROLS"},{"code_sequence":"11","code_value":"T","code_description":"COMMUNICATION CARDS"},{"code_sequence":"12","code_value":"1DY","code_description":"OUTSIDE AIR"},{"code_sequence":"13","code_value":"V","code_description":"EXHAUST AIR"},{"code_sequence":"14","code_value":"A","code_description":"FILTERS"},{"code_sequence":"15","code_value":"4","code_description":"DX COIL"},{"code_sequence":"16","code_value":"S","code_description":"DRAIN PAN"},{"code_sequence":"17","code_value":"G","code_description":"LINERS"},{"code_sequence":"18","code_value":"M","code_description":"HOT GAS REHEAT"},{"code_sequence":"19","code_value":"Y","code_description":"COIL OPTIONS"},{"code_sequence":"20","code_value":"Y","code_description":"FUTURE1"},{"code_sequence":"21","code_value":"KM","code_description":"SUPPLY FAN MOTOR"},{"code_sequence":"22","code_value":"22DY","code_description":"INDOOR/SUPPLY FAN "},{"code_sequence":"23","code_value":"15","code_description":"INDOOR/SUPPLY FAN RPM"},{"code_sequence":"24","code_value":"018YS","code_description":"ELECTRIC HEAT"},{"code_sequence":"25","code_value":"1","code_description":"LOW AMBIENT CONTROL"},{"code_sequence":"26","code_value":"H","code_description":"ELECTRICAL OPTIONS"},{"code_sequence":"27","code_value":"1","code_description":"SMOKE DETECTORS"},{"code_sequence":"28","code_value":"A","code_description":"OA MONITORING"},{"code_sequence":"29","code_value":"Y","code_description":"UV LIGHTS"},{"code_sequence":"30","code_value":"Y","code_description":"FUTURE"},{"code_sequence":"31","code_value":"A","code_description":"COMPRESSOR ISOLATION VALVES"},{"code_sequence":"32","code_value":"YY","code_description":"HEAT WHEEL"},{"code_sequence":"33","code_value":"YY","code_description":"ENERGY WHEEL CONTROL"},{"code_sequence":"34","code_value":"YY","code_description":"ENERGY WHEEL FILTRATION"},{"code_sequence":"35","code_value":"GM","code_description":"EXHAUST FAN MOTOR"},{"code_sequence":"36","code_value":"14DY","code_description":"EXHAUST FAN "},{"code_sequence":"37","code_value":"AYA","code_description":"UNIT APPROVALS"},{"code_sequence":"38","code_value":"Y","code_description":"OUTDOOR COIL OPTIONS"},{"code_sequence":"39","code_value":"Y","code_description":"FUTURE2"},{"code_sequence":"40","code_value":"A","code_description":"PARTS WARRANTY"},{"code_sequence":"41","code_value":"Q","code_description":"COMPRESSOR WARRANTY"},{"code_sequence":"42","code_value":"Y","code_description":"HEAT EXCHANGER WARRANTY"},{"code_sequence":"43","code_value":"02000","code_description":"SAF CFM"},{"code_sequence":"44","code_value":"025","code_description":"SAF BHP"},{"code_sequence":"45","code_value":"473","code_description":"DISCHARGE AIR TEMPERATURE"},{"code_sequence":"46","code_value":"R1693","code_description":"EAF RPM"},{"code_sequence":"47","code_value":"5","code_description":"EAF BHP"},{"code_sequence":"48","code_value":"Y","code_description":"MISCELLANEOUS"}]';
		insert ast;

		Test.startTest();
			Map<String, String> result = SendAssetToIntel.getKeyValuesFromCodeString(ast);
		Test.stopTest();
	
		System.assertEquals(48, result.size(), 'There should be 48 code values in the test string');
	}
	
	static testMethod void getKeyValuesFromCodeString_BadStringTest() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		ast.Current_Code_String_Breakdown__c = '[{"cence":"1","codalue":"DPS","codetion":"UNIT TY"}]';
		insert ast;
		
		Test.startTest();
			Map<String, String> result = SendAssetToIntel.getKeyValuesFromCodeString(ast);
		Test.stopTest();
	
		System.assertEquals(1, result.size(), 'There should be 1 (null) code values in the test string: ' + result);
		System.assertEquals(NULL, result.values()[0], 'The only code value should be NULL');
	}

	static testmethod void testUpdateApiKey() {
		insert new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL,
													Username__c = LOGIN_NAME,
													Password__c = PASSWORD,
													API_Key__c = APIKEY);

		HttpCalloutMockImpl mock = new HttpCalloutMockImpl(BASEURL, APIKEY);
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, mock);
			Boolean updateApiKey = SendAssetToIntel.updateApiKey();
			Intel_TAS_Integration_Setting__c cs = [
				SELECT Id 
				FROM Intel_TAS_Integration_Setting__c
				LIMIT 1
			];
			cs.API_Key__c = AssetIntegrationService.integrationSetting.API_Key__c;
			update cs;
		Test.stopTest();

		System.assertEquals(Intel_TAS_Integration_Setting__c.getInstance().API_Key__c, NEW_APIKEY, 'API key should have ' +
			'updated.');
		System.assertEquals(AssetIntegrationService.integrationSetting.API_Key__c, NEW_APIKEY, 'API key should have ' +
			'updated.');
		System.assert(updateApiKey, 'Flag for updating API Key should be true.');
	}
	
	static testMethod void getModelId_Test() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		ast.Format_Number__c = '1';
		insert ast;
		ast =[SELECT Id, Intel_ID__c, Product2.ProductCode, Current_Code_String_Breakdown__c, SerialNumber, Format_Number__c, Asset_Address__c, Device_ID__c, Order__r.Vertical_Market__c, Description, Name FROM Asset WHERE Id = :ast.Id];

		AssetIntegrationService.integrationSetting = 
			new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL, API_Key__c = APIKEY);										

		HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, mock);
			Integer actualModelId = SendAssetToIntel.getModelId(ast, TEST_MODEL_NUMBERS[2]);
		Test.stopTest();

		System.assertEquals(17, actualModelId, 'The model Id of the third Test Model Number should be retrieved from the returned JSON');
	}
	
	static testMethod void getModelId_NoMatchingIDTest() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		insert ast;
		ast =[SELECT Id, Intel_ID__c, Product2.ProductCode, SerialNumber, Format_Number__c, Asset_Address__c, Device_ID__c, Order__r.Vertical_Market__c, Description, Name FROM Asset WHERE Id = :ast.Id];

		AssetIntegrationService.integrationSetting = 
			new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL, API_Key__c = APIKEY);										

		HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, mock);
			Integer actualModelId = SendAssetToIntel.getModelId(ast, 'NONEXISTENT');
		Test.stopTest();

		System.assertEquals(NULL, actualModelId, 'The model Id of a non-existent Model Number should be NULL');
	}

	//static testMethod void createModel_Test() {
	//	Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
	//	Product2 prd = new Product2(Name = 'Test Product', ProductCode = 'NEWMODELNUMBER');
	//	insert prd;
	//	Asset ast = TestingUtils.createAssets(1, acc, false)[0];
	//	ast.Product2Id = prd.Id;
	//	insert ast;
	//	ast =[SELECT Id, Intel_ID__c, Product2.ProductCode, SerialNumber, Format_Number__c, Asset_Address__c, Device_ID__c, Order__r.Vertical_Market__c, Description, Name FROM Asset WHERE Id = :ast.Id];

	//	AssetIntegrationService.integrationSetting = 
	//		new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL, API_Key__c = APIKEY);										

	//	HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
	//	Test.startTest();
	//		Test.setMock(HttpCalloutMock.class, mock);
	//		Integer actualNewModelId = SendAssetToIntel.createModel(ast);
	//	Test.stopTest();

	//	System.assertEquals(TEST_NEW_MODEL_ID, actualNewModelId, 'The model Id of the newly created model should equal the one set in the mock class');
	//}
	
	static testMethod void getAssetId_YesTest() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		ast.Intel_ID__c = 112;
		ast.SerialNumber = 'ABC123';
		insert ast;
		ast =[SELECT Id, Intel_ID__c, Product2.ProductCode, SerialNumber, Format_Number__c, Asset_Address__c, Device_ID__c, Order__r.Vertical_Market__c, Description, Name FROM Asset WHERE Id = :ast.Id];

		AssetIntegrationService.integrationSetting = 
			new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL, API_Key__c = APIKEY);										

		HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, mock);
			Integer actualId = SendAssetToIntel.getAssetId(ast);
		Test.stopTest();

		System.assertNotEquals(NULL, actualId, 'The function should return an existing id becuase the assetId queried for is in the test id list');
	}
	
	static testMethod void getAssetId_NoTest() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		ast.Intel_ID__c = 111;
		ast.SerialNumber = 'ABCXYZ';
		insert ast;
		ast =[SELECT Id, Intel_ID__c, Product2.ProductCode, SerialNumber, Format_Number__c, Asset_Address__c, Device_ID__c, Order__r.Vertical_Market__c, Description, Name FROM Asset WHERE Id = :ast.Id];

		AssetIntegrationService.integrationSetting = 
			new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL, API_Key__c = APIKEY);										

		HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, mock);
			Integer actualId = SendAssetToIntel.getAssetId(ast);
		Test.stopTest();

		System.assertEquals(NULL, actualId, 'The function should return Null becuase the assetId queried for is not in the test id list');
	}

	static testMethod void createAsset_Test() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		ast.SerialNumber = '123xyz';
		ast.Description = 'Description1234';
		ast.Name = 'TestNameAsset';
		insert ast;
		ast =[SELECT Id, Intel_ID__c, Product2.ProductCode, SerialNumber, Format_Number__c, Asset_Address__c, Device_ID__c, Order__r.Vertical_Market__c, Description, Name FROM Asset WHERE Id = :ast.Id];

		AssetIntegrationService.integrationSetting = 
			new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL, API_Key__c = APIKEY);										

		HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, mock);
			Integer actualNewAssetId = SendAssetToIntel.createAsset(ast, 12, 'modelName'); // Does not test if modelid 12 exists
		Test.stopTest();

		System.assertEquals(TEST_NEW_ASSET_ID, actualNewAssetId, 'The model Id of the newly created asset should equal the one set in the mock class');
	}

	static testMethod void updateAsset_Test() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		ast.Intel_ID__c = 213;
		ast.SerialNumber = '123xyz';
		ast.Description = 'Description1234';
		ast.Name = 'TestNameAsset';
		insert ast;
		ast =[SELECT Id, Intel_ID__c, Product2.ProductCode, SerialNumber, Format_Number__c, Asset_Address__c, Device_ID__c, Order__r.Vertical_Market__c, Description, Name FROM Asset WHERE Id = :ast.Id];

		AssetIntegrationService.integrationSetting = 
			new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL, API_Key__c = APIKEY);										

		HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, mock);
			Integer actualUpdatedAssetId = SendAssetToIntel.updateAsset(ast, 12, 'modelName'); // Does not test if modelid 12 exists
		Test.stopTest();

		System.assertEquals(213, actualUpdatedAssetId, 'The model Id of the updated model should same as the one sent to the update');
	}
	
	static testMethod void getAssetTags_HasTagsTest() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		ast.Intel_ID__c = TEST_ASSET_W_TAGS;
		insert ast;
		ast =[SELECT Id, Intel_ID__c, Product2.ProductCode, SerialNumber, Format_Number__c, Asset_Address__c, Device_ID__c, Order__r.Vertical_Market__c, Description, Name FROM Asset WHERE Id = :ast.Id];

		AssetIntegrationService.integrationSetting = 
			new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL, API_Key__c = APIKEY);										

		HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, mock);
			Map<String, Integer> actualTagMap = SendAssetToIntel.getAssetTags(ast);
		Test.stopTest();

		System.assertEquals(new Set<String>(TEST_TAG_KEYS), actualTagMap.keySet(), 'Tags of asset should be returned in map form');
	}
	
	static testMethod void getAssetTags_NoTagsTest() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		ast.Intel_ID__c = TEST_ASSET_NO_TAGS;
		insert ast;
		ast =[SELECT Id, Intel_ID__c, Product2.ProductCode, SerialNumber, Format_Number__c, Asset_Address__c, Device_ID__c, Order__r.Vertical_Market__c, Description, Name FROM Asset WHERE Id = :ast.Id];

		AssetIntegrationService.integrationSetting = 
			new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL, API_Key__c = APIKEY);										

		HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, mock);
			Map<String, Integer> actualTagMap = SendAssetToIntel.getAssetTags(ast);
		Test.stopTest();

		System.assert(actualTagMap.isEmpty(), 'Tags of asset should be returned in map form. In this case, an empty map');
	}

	static testMethod void createAssetTag_Test() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		ast.Intel_ID__c = TEST_ASSET_NO_TAGS;
		insert ast;
		ast =[SELECT Id, Intel_ID__c, Product2.ProductCode, SerialNumber, Format_Number__c, Asset_Address__c, Device_ID__c, Order__r.Vertical_Market__c, Description, Name FROM Asset WHERE Id = :ast.Id];

		AssetIntegrationService.integrationSetting = 
			new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL, API_Key__c = APIKEY);										

		HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, mock);
			Integer actualNewAssetTagId = SendAssetToIntel.createAssetTag(ast, 'testKey', 'testVal'); 
		Test.stopTest();

		System.assertEquals(TEST_NEW_TAG_ID, actualNewAssetTagId, 'The tag Id of the newly created asset tag should equal the one set in the mock class');
	}

	static testMethod void updateAssetTag_Test() {
		Account acc = TestingUtils.createAccounts(1, 'Test', true)[0];
		Asset ast = TestingUtils.createAssets(1, acc, false)[0];
		ast.Intel_ID__c = TEST_ASSET_W_TAGS;
		insert ast;
		ast =[SELECT Id, Intel_ID__c, Product2.ProductCode, SerialNumber, Format_Number__c, Asset_Address__c, Device_ID__c, Order__r.Vertical_Market__c, Description, Name FROM Asset WHERE Id = :ast.Id];

		AssetIntegrationService.integrationSetting = 
			new Intel_TAS_Integration_Setting__c(Base_URL__c = BASEURL, API_Key__c = APIKEY);										

		HttpCalloutMockImpl mock = new HttpCalloutMockImpl (BASEURL, APIKEY);
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, mock);
			Integer actualUpdatedAssetTagId = SendAssetToIntel.updateAssetTag(ast, TEST_EXISTING_TAG_ID, 'testKey', 'testVal'); 
		Test.stopTest();

		System.assertEquals(TEST_EXISTING_TAG_ID, actualUpdatedAssetTagId, 'The tag Id of the updated asset tag should equal the one sent to the update');
	}

}