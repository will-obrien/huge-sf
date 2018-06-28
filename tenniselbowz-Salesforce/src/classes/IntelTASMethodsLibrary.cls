public with sharing class IntelTASMethodsLibrary {
	private static final String CONTENT_TYPE = 'application/json';

	public static IntelTASResponseObject getCurrentApiKey(String baseUrl, String loginName, String password,
			Boolean create) {

		String action = '/rest/apiKeys/?gzip=false&create=';
		if (create) {
			action += 'yes';
		} else {
			action += 'no';
		}

		return IntelTASRESTCaller.doGetWithLogin(baseUrl, action, loginName, password);
	}

	public static IntelTASResponseObject getAllAssetModels(String baseUrl, String apiKey) {
		IntelTASRESTCaller restGetCaller = new IntelTASRESTCaller(baseUrl, apiKey, '/rest/assetModels/');
		return restGetCaller.doGet();
	}

	public static IntelTASResponseObject getAllOperators(String baseUrl, String apiKey) {
		IntelTASRESTCaller restGetCaller = new IntelTASRESTCaller(baseUrl, apiKey, '/rest/operators/');
		return restGetCaller.doGet();
	}

	public static IntelTASResponseObject createAssetModel(String baseUrl, String apiKey, String modulNum, String assetTypeCode,
			String revNumber) {

		String action = '/rest/assetModels/';
		assetTypeCode = (assetTypeCode == NULL || String.isEmpty(assetTypeCode)) ? '0' : assetTypeCode;
		String parameter = '{"modelNumber":' + '"' + modulNum + '"';
		if (assetTypeCode != NULL && !String.isEmpty(assetTypeCode))
			parameter += ',' + '"assetTypeCode":' + assetTypeCode;
		if (revNumber != NULL && !String.isEmpty(revNumber))
			parameter += ',' + '"revisionNumber":' + revNumber;
		parameter += ' }';
		IntelTASRESTCaller restpostCaller = new IntelTASRESTCaller(baseUrl, apiKey, action);
		return restpostCaller.doPost(parameter, CONTENT_TYPE);
	}

	public static IntelTASResponseObject registerNewAsset(String baseUrl, String apiKey, String newSerialNumber,
			String modelId, String modelName, String operatorId, String description, String name) {

		String action = '/rest/assets/';

		String parameter = '{' +
							'"serialNumber":' + '"' + newSerialNumber + '"' + ',' + 
						    '"modelId":' + modelId + ',' + 
						    '"operatorId":' + operatorId + ',' +
						    '"description":' + '"' + description + '"' + ',' + 
						    '"name":' + '"' + newSerialNumber + '_' + modelName + '"' +
						   '}';

		IntelTASRESTCaller restpostCaller = new IntelTASRESTCaller(baseUrl, apiKey, action);
		return restpostCaller.doPost(parameter, CONTENT_TYPE);
	}

	public static IntelTASResponseObject updateAsset(String baseUrl, String apiKey, String assetId,
			String newSerialNumber, String modelId, String modelName, String operatorId, String description, String name) {

		String action = '/rest/assets/' + assetId;

		String parameter = '{' + 
							'"serialNumber":' + '"' + newSerialNumber + '"' + ',' +
							'"modelId":' + modelId + ',' +
							'"operatorId":' + operatorId + ',' +
							'"description":' + '"' + description + '"' + ',' +
							'"name":' + '"' + newSerialNumber + '_' + modelName + '"' +
						   '}';
						   
		IntelTASRESTCaller restputCaller = new IntelTASRESTCaller(baseUrl, apiKey, action);
		return restputCaller.doPut(parameter, CONTENT_TYPE);
	}

	public static IntelTASResponseObject getAssetById(String baseUrl, String apiKey, String assetId) {
		String action = '/rest/assets/' + assetId;

		IntelTASRESTCaller restGetCaller = new IntelTASRESTCaller(baseUrl, apiKey, action);
		return restGetCaller.doGet();
	}

	public static IntelTASResponseObject getAssetBySerialNumber(String baseUrl, String apiKey, String serialNumber) {
		String action = '/rest/assets/?serialNumber=' + serialNumber;

		IntelTASRESTCaller restGetCaller = new IntelTASRESTCaller(baseUrl, apiKey, action);
		return restGetCaller.doGet();
	}

	public static IntelTASResponseObject getAllAssets(String baseUrl, String apiKey) {
		IntelTASRESTCaller restGetCaller = new IntelTASRESTCaller(baseUrl, apiKey, '/rest/assets/');
		return restGetCaller.doGet();
	}

	public static IntelTASResponseObject getAssetsByModelIds(String baseUrl, String apiKey, List<String> modelIds) {
		String action = '/rest/assets/?modelIds='+String.join(modelIds, ',');

		IntelTASRESTCaller restGetCaller = new IntelTASRESTCaller(baseUrl, apiKey, action);
		return restGetCaller.doGet();
	}

	public static IntelTASResponseObject getAssetsByOperatorIds(String baseUrl, String apiKey, String operatorId) {
		String action = '/rest/assets/?operatorId='+operatorId;
		
		IntelTASRESTCaller restGetCaller = new IntelTASRESTCaller(baseUrl, apiKey, action);
		return restGetCaller.doGet();
	}

	// Asset Tag functions
	public static IntelTASResponseObject getAssetTagsByAssetId(String baseUrl, String apiKey, String assetId) {
		String action = '/rest/assetTags/?assetId=' + assetId;

		IntelTASRESTCaller restGetCaller = new IntelTASRESTCaller(baseUrl, apiKey, action);
		return restGetCaller.doGet();
	}

	public static IntelTASResponseObject createAssetTag(String baseUrl, String apiKey, String assetId, String tagKey,
			String tagValue) {

		String action = '/rest/assetTags/';

		String parameter = '{"assetId":' + assetId 
			+ ',' + '"attrKey":' + '"' + tagKey + '"' + ',' + '"attrValue":' + '"'
			+ tagValue + '"}';

		IntelTASRESTCaller restpostCaller = new IntelTASRESTCaller(baseUrl, apiKey, action);
		return restpostCaller.doPost(parameter, CONTENT_TYPE);
	}

	public static IntelTASResponseObject updateAssetTag(String baseUrl, String apiKey, String assetId, String tagId,
			String tagKey, String tagValue) {

		String action = '/rest/assetTags/'+tagId;

		String parameter = '{"assetId":' + assetId 
			+ ',' + '"attrKey":' + '"' + tagKey + '"' + ',' + '"attrValue":' + '"'
			+ tagValue + '"}';

		IntelTASRESTCaller restputCaller = new IntelTASRESTCaller(baseUrl, apiKey, action);
		return restputCaller.doPut(parameter, CONTENT_TYPE);
	}
}