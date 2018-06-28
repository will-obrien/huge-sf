@isTest
private class TestOAuth {
	
	static OAuthSettings getSettings() {
		OAuthSettings settings = new OAuthSettings();
		settings.consumerKey = 'xvamfPHmVci3nVfMW4VAXw';
		settings.consumerSecret = 'htjlgP0r3hc0UN971WqcJe8n3hFeWMc5fllGlbZo';
		settings.requestTokenURL = 'https://api.twitter.com/oauth/request_token';
		settings.authorizeURL = 'https://api.twitter.com/oauth/authorize';
		settings.accessTokenURL = 'https://api.twitter.com/oauth/access_token';
		
		User u  = [SELECT Id, Twitter_isValid__c, Twitter_OAuth_Token__c, Twitter_OAuth_Token_Secret__c
		             FROM User 
		             WHERE Id = :UserInfo.getUserId()];

		settings.isValid = u.Twitter_isValid__c;
		settings.token = u.Twitter_OAuth_Token__c;
		settings.tokenSecret = u.Twitter_OAuth_Token_Secret__c;	
		
		return settings;	
	}
	
	static testMethod void testNewAuthorization() {
		OAuth auth = new OAuth();
		OAuthSettings settings = getSettings();		
		String url = auth.newAuthorization(settings, '');
		System.assertEquals(url, null);
	}
	
	static testMethod void testSign() {
		OAuthSettings settings = getSettings();
		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		req.setEndpoint(settings.accessTokenURL);
		req.setBody('');
		OAuth auth = new OAuth();
		auth.sign(req, settings);
	}
	
	static testMethod void testCompleteAuthorization() {
		OAuthSettings settings = getSettings();
		settings.verifier = '';
		settings.token = 'test';
		settings.tokenSecret  = 'test';
		
		Map<String, String> rp = new Map<String, String>();
		OAuth auth = new OAuth();
		Boolean response = auth.completeAuthorization(settings, rp);
		System.assertEquals(response, false);
		
	}
	
	static testMethod void testProcessCompleteAuthResponseFail() {
		OAuth auth = new OAuth();
		OAuthSettings settings = getSettings();
		Map<String, String> rp = new Map<String, String>();
		HttpResponse res = new HttpResponse();
		res.setStatusCode(500);
		boolean result = auth.processCompleteAuthResponse(res, settings, rp);
		System.assertEquals(result, false);
	}

	static testMethod void testProcessCompleteAuthResponsePass() {
		OAuth auth = new OAuth();
		OAuthSettings settings = getSettings();
		Map<String, String> rp = new Map<String, String>();
		HttpResponse res = new HttpResponse();
		res.setStatusCode(200);
		res.setBody('oauth_token=test&oauth_token_secret=test');
		boolean result = auth.processCompleteAuthResponse(res, settings, rp);
		System.assertEquals(result, true);
	}
		
	static testMethod void testBuildRequest() {
		OAuth auth = new OAuth();
		HttpRequest req = auth.buildRequest('localhost', 'GET');
		System.assertEquals(req.getMethod(), 'GET');
	}
	
	static testMethod void testProcessNewAuthResponseFail() {
		OAuth auth = new OAuth();
		OAuthSettings settings = getSettings();
		HttpResponse res = new HttpResponse();
		res.setStatusCode(500);
		String result = auth.processNewAuthResponse(res, settings);
		System.assertEquals(result, null);		
	}

	static testMethod void testProcessNewAuthResponsePass() {
		OAuth auth = new OAuth();
		OAuthSettings settings = getSettings();
		HttpResponse res = new HttpResponse();
		res.setStatusCode(200);
		res.setBody('oauth_token=test&oauth_token_secret=test');
		String result = auth.processNewAuthResponse(res, settings);
		System.assertNotEquals(result, null);		
	}	
}