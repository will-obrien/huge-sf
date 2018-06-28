@isTest(SeeAllData=true)
global class MockSessionIdValidHttpResponse implements HttpCalloutMock {
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req) {
	// Optionally, only send a mock response for a specific endpoint
	// and method.
	JHA_Form_App_Config_Settings__c tempUri = JHA_Form_App_Config_Settings__c.getInstance('TEMP_URI');
	JHA_Form_App_Config_Settings__c authWebServiceEndpoint = JHA_Form_App_Config_Settings__c.getInstance('AUTH_WEB_SERVICE_ENDPOINT');
	
	System.assertEquals(authWebServiceEndpoint.App_Config_Setting__c, req.getEndpoint());
	System.assertEquals('POST', req.getMethod());
	
	// Create a fake response depending on the request
	HttpResponse res = new HttpResponse();
	res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	
	String responseString = null;
	if (req.getBody().contains('ValidateSession')) {
		responseString = '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
          '<soap:Body>' +
            '<ValidateSessionResponse xmlns="' + tempUri.App_Config_Setting__c + '">' +
              '<ValidateSessionResult>true</ValidateSessionResult>' +
            '</ValidateSessionResponse>' +
          '</soap:Body>' +
        '</soap:Envelope>';
	}
	else if (req.getBody().contains('GetUserInfoBySessionId')) {
		responseString = '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
          '<soap:Body>' +
            '<GetUserInfoBySessionIdResponse xmlns="' + tempUri.App_Config_Setting__c + '">' +
              '<GetUserInfoBySessionIdResult>' +
              	'<FirstName>Joe</FirstName>' +
              	'<LastName>Blow</LastName>' +
              	'<LoginId>blowj1</LoginId>' +
              	'<Email>joe.blow@xyz.com</Email>' +
              '</GetUserInfoBySessionIdResult>' +
            '</GetUserInfoBySessionIdResponse>' +
          '</soap:Body>' +
        '</soap:Envelope>';
	}

    res.setHeader('Content-Length',String.valueOf(responseString.length()));
	res.setBody(responseString);
	
	return res;
	}
}