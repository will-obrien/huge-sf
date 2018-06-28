public with sharing class IntelTASRESTCaller {
	private String baseUrl;
	private String apiKey;
	private String restAction;

	public IntelTASRESTCaller(String baseUrl, String apiKey, String restAction) {
		this.baseUrl = baseUrl;
		this.apiKey = apiKey;
		this.restAction = restAction;
	}

	public static IntelTASResponseObject doGetWithLogin(String baseUrl, String restAction, String loginName,
			String password) {
		IntelTASResponseObject responseObject = new IntelTASResponseObject();
		try {
		    HttpRequest request = new HttpRequest();
		    request.setMethod('GET');
		    request.setEndpoint(baseUrl + restAction);
		    request.setHeader('Login-Name', loginName);
		    request.setHeader('Password', password);

		    Http connection = new Http();
		    HttpResponse response = connection.send(request);
		    String requestToString = 'GET ' + baseUrl + restAction;
		    requestToString += '\nHeaders';
		    requestToString += '\n--------';
		    requestToString += '\nLogin-Name: ' + loginName;
		    requestToString += '\nPassword: ' + password;
		    requestToString += '\nBody';
		    requestToString += '\n-----';
		    requestToString += '\n[none]';

		    responseObject.setRequestData(requestToString);
		    responseObject.setResponseCode(response.getStatusCode());
		    responseObject.setResponseMessage(response.getHeader('error_message'));
		    responseObject.setResponseData('');
		    if (response.getStatusCode() == 200) {
		        responseObject.setResponseData(response.getBody());
		    }
		} catch(CalloutException e) {
			System.debug(LoggingLevel.ERROR, e);
			// THROW
		}

		return responseObject;
	}

	public IntelTASResponseObject doGet() {
		IntelTASResponseObject responseObject = new IntelTASResponseObject();
		try {
			HttpRequest request = new HttpRequest();
			request.setMethod('GET');
			request.setHeader('API-KEY', apiKey);
			request.setEndpoint(baseUrl + restAction);
			Http connection = new Http();
			HttpResponse hResponse = connection.send(request);
			String requestToString = 'GET ' + baseUrl + restAction;
			requestToString += '\nHeaders';
			requestToString += '\n--------';
			requestToString += '\nAPI-KEY: ' + apiKey;
			requestToString += '\nBody';
			requestToString += '\n-----';
			requestToString += '\n[none]';

			responseObject.setRequestData(requestToString);
			responseObject.setResponseCode(hResponse.getStatusCode());
			responseObject.setResponseMessage(hResponse.getHeader('error_message'));
			responseObject.setResponseData('');
			if (hResponse.getStatusCode() == 200) {
				responseObject.setResponseData(hResponse.getBody());
			}
		}
		catch (CalloutException ex) {
			System.debug(LoggingLevel.ERROR, ex);
			// THROW
		}

		return responseObject;
	}

	// JSON parameters only
	public IntelTASResponseObject doPost(String parameter, String contentType) {
		IntelTASResponseObject responseObject = new IntelTASResponseObject();
		try {
			HttpRequest request = new HttpRequest();
			request.setMethod('POST');
			request.setHeader('API-KEY', apiKey);
			request.setHeader('Content-Type', contentType);
			System.debug('POST-- body: ' + parameter);
			request.setBody(parameter); 
			request.setEndpoint(baseUrl + restAction);
			Http connection = new Http();
			HttpResponse hResponse = connection.send(request);
			String requestToString = 'POST ' + baseUrl + restAction;
			requestToString += '\nHeaders';
			requestToString += '\n--------';
			requestToString += '\nAPI-KEY: ' + apiKey;
			requestToString += '\nContent-Type: ' + contentType;
			requestToString += '\nBody';
			requestToString += '\n-----';
			requestToString += '\n' + parameter;

			responseObject.setRequestData(requestToString);
			responseObject.setResponseCode(hResponse.getStatusCode());
			responseObject.setResponseMessage(hResponse.getHeader('error_message'));
			responseObject.setResponseData('');
			if (hResponse.getStatusCode() == 201) {
				responseObject.setResponseData(hResponse.getBody());
			}
		}
		catch (CalloutException ex) {
			System.debug(LoggingLevel.ERROR, ex);			
		}

		return responseObject;
	}

	// JSON parameters only
	public IntelTASResponseObject doPut(String parameter, String contentType) {
		IntelTASResponseObject responseObject = new IntelTASResponseObject();
		try {
			HttpRequest request = new HttpRequest();
			request.setMethod('PUT');
			request.setHeader('API-KEY', apiKey);
			request.setHeader('Content-Type', contentType);
			request.setBody(parameter); 
			request.setEndpoint(baseUrl + restAction);
			Http connection = new Http();
			HttpResponse hResponse = connection.send(request);
			String requestToString = 'PUT ' + baseUrl + restAction;
			requestToString += '\nHeaders';
			requestToString += '\n--------';
			requestToString += '\nAPI-KEY: ' + apiKey;
			requestToString += '\nContent-Type: ' + contentType;
			requestToString += '\nBody';
			requestToString += '\n-----';
			requestToString += '\n' + parameter;

			responseObject.setRequestData(requestToString);
			responseObject.setResponseCode(hResponse.getStatusCode());
			responseObject.setResponseMessage(hResponse.getHeader('error_message'));
			responseObject.setResponseData('');
			if (hResponse.getStatusCode() == 200) {
				responseObject.setResponseData(hResponse.getBody());
			}
		}
		catch (CalloutException ex) {
			System.debug(LoggingLevel.ERROR, ex);			
		}

		return responseObject;
	}

	public String getBaseUrl() {
		return baseUrl;
	}

	public void setBaseUrl(String baseUrl) {
		this.baseUrl = baseUrl;
	}

	public String getApiKey() {
		return apiKey;
	}

	public void setApiKey(String apiKey) {
		this.apiKey = apiKey;
	}

	public String getRestAction() {
		return restAction;
	}

}

//https://tsttrendanalyticssoftware.intel.com/daikin/rest/assetTags/?assetId=139&gzip=false