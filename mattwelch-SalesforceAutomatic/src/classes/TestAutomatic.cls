/***************************************
* TestAutomatic.cls
* Automatic integration unit tests
***************************************/
@isTest
private class TestAutomatic {

	@isTest static void TestAuthFlow() {
		Test.setMock(HttpCalloutMock.class, new TestAutomatic.AutomaticAuthMockGenerator());
		AutomaticAPI__c orgAutoAPI=new AutomaticAPI__c(SetupOwnerId=UserInfo.getOrganizationId(), client_id__c='TestClientId', client_secret__c='TestClientSecret');
		insert orgAutoAPI;

		AutomaticAuthorizeCtrl autoAuthCtrl=new AutomaticAuthorizeCtrl();
		PageReference autoAuthPage=autoAuthCtrl.doRedirect();
		String authState=AutomaticAPI__c.getInstance().State__c;

		PageReference autoOAuthPage=Page.AutomaticOAuth;
		autoOAuthPage.getParameters().put('code','TestTempCode');
		autoOAuthPage.getParameters().put('state',authState);
		Test.setCurrentPage(autoOAuthPage);

		AutomaticOAuthCtrl autoOAuthCtrl=new AutomaticOAuthCtrl();

		Test.startTest();
		autoOAuthCtrl.processTempCode();
		Test.stopTest();

		system.assert(autoOAuthCtrl.authorized);

		AutomaticAPI__c finalAuthValues=AutomaticAPI__c.getInstance();
		system.assertEquals('TestAccessToken',finalAuthValues.token__c);
		system.assertEquals('TestRefreshToken',finalAuthValues.refresh__c);
		system.assertEquals('TestUserId',finalAuthValues.automatic_id__c);
	}

	@isTest static void TestWebhookEndpoint() {
		AutomaticAPI__c orgAutoAPI=new AutomaticAPI__c(SetupOwnerId=UserInfo.getOrganizationId(), client_id__c='TestClientId', client_secret__c='TestClientSecret');
		insert orgAutoAPI;

		AutomaticAPI__c userAutoAPI=new AutomaticAPI__c(SetupOwnerId=UserInfo.getUserId(), token__c='TesetAccessToken', automatic_id__c='TestUserId');
		insert userAutoAPI;

		System.RestContext.request = new RestRequest();
		RestContext.request.requestURI = '/AutomaticWebhook/';

		RestContext.response = new RestResponse();

		String responseString='{"id": "malFormedJSON","badKey"}';

		RestContext.request.requestBody=Blob.valueOf(responseString);
		AutomaticWebhookHandler.postHandler();

		system.assertEquals(500,RestContext.response.statusCode);

		System.RestContext.request = new RestRequest();
		RestContext.request.requestURI = '/AutomaticWebhook/';

		RestContext.response = new RestResponse();


		responseString='{"id": "1c048d25b875","user": {"id": "TestUserId"},"type": "trip:finished","created_at": 1383448450201,"time_zone": "America/Los_Angeles","location": {"lat": 37.757076,"lon": -122.448120,"accuracy_m": 10},"vehicle":{';
		responseString+='"uri": "https://api.automatic.com/v1/vehicles/529e5772e4b00a2ddb562f1f","id": "529e5772e4b00a2ddb562f1f","year": 2001,"make": "Acura","model": "MDX","color": "#d15fed","display_name": "My Speed Demon"';
		responseString+='},"trip":{';
		responseString+='"uri": "https://api.automatic.com/v1/trips/524da549e4b08d1af17f6dca","id": "524da549e4b08d1af17f6dca","start_location": {"name": "Ashbury St, SF, CA","display_name": "Home","lat": 37.7692903,"lon": -122.4465469,"accuracy_m": 5},';
		responseString+='"start_time": 1383448450201,"start_time_zone": "America/Los_Angeles","end_location": {"name": "5th St, SF, CA","display_name": "Work","lat": 37.78270046281092,"lon": -122.4064556183999,"accuracy_m": 97.88124084472656},';
      	responseString+='"end_time": 1383449950201,"end_time_zone": "America/Los_Angeles","path": "uioeFxycjVxDMvAGBjATlJXrLaIZHvCFhCHpCaI^i@@","distance_m": 6573.416666666661,"hard_accels": 0,"hard_brakes": 1,"duration_over_80_s": 0,"duration_over_75_s": 2,"duration_over_70_s": 3,"fuel_cost_usd": 1.0428111627932486,"fuel_volume_gal": 0.2465857561582522,"average_mpg": 16.56434586845349';
		responseString+='}}';
		RestContext.request.requestBody=Blob.valueOf(responseString);
		AutomaticWebhookHandler.postHandler();

		system.assertEquals(200,RestContext.response.statusCode);

		Vehicle__c v=[select id, name, color__c, (select id, start_location_name__c from Trips__r) from Vehicle__c];
		system.assertEquals(1,v.Trips__r.size());


	}

	public class AutomaticAuthMockGenerator implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {

	        System.assertEquals('https://www.automatic.com/oauth/access_token', req.getEndpoint());
	        System.assertEquals('POST', req.getMethod());

	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{"access_token":"TestAccessToken","refresh_token":"TestRefreshToken","user":{"id":"TestUserId"}}');
	        res.setStatusCode(200);
	        return res;
	    }
	}


}