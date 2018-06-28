/***************************************
* AutomaticOAuthCtrl.cls
* Receives Automatic temp token, redeems
* it for an oauth token, and
* notifies user of result
***************************************/
public with sharing class AutomaticOAuthCtrl {

	public Boolean authorized {get; private set;}

	// Method called automatically on Page load.
	public void processTempCode() {
		authorized=false;

		// Get the current running user's Automatic auth info from our custom setting
		AutomaticAPI__c a=AutomaticAPI__c.getInstance(UserInfo.getUserId());

		ApexPages.Message failMsg;

		// This is the temporary token that we'll exchange for an oauth token
		String tempCode=ApexPages.currentPage().getParameters().get('code');
		// If it's not there, something's gone wrong, and we need to notify the user
		if (tempCode == null) {
			failMsg=new ApexPages.Message(ApexPages.Severity.FATAL,'Invalid code.');
			ApexPages.addMessage(failMsg);
			return;
		}

		// Here's the state that we sent to the original Automatic OAuth page
		String oAuthState=ApexPages.currentPage().getParameters().get('state');

		// Let's confirm that what we got back is the same as what we sent....
		if (oAuthState != a.state__c) {
			a.state__c=null;
			upsert a;
			// ...and notify the user if it isn't
			failMsg=new ApexPages.Message(ApexPages.Severity.FATAL,'States do not match. Possible attack.');
			ApexPages.addMessage(failMsg);
			return;
		}
		a.state__c=null;

		// Now we turn around and call back out to Automatic's OAuth endpoint to get our final tokens
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        String requestParams='client_id='+a.client_id__c;
        requestParams+='&client_secret='+a.client_secret__c;
        requestParams+='&code='+tempCode;
        requestParams+='&grant_type=authorization_code';

        req.setEndpoint('https://www.automatic.com/oauth/access_token');
        req.setBody(requestParams);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');

        HttpResponse res;
        // Do the callout///
        try {
	        res = h.send(req);
        }
        // ...and notify the user if there was a problem
        catch (CalloutException e) {
			failMsg=new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage());
			ApexPages.addMessage(failMsg);
			return;
        }
        String tokenResponse=res.getBody();
        Integer tokenResponseCode=res.getStatusCode();

        // If we didn't get a success code, let the user know what went wrong
        if (tokenResponseCode > 299) {
        	Map<String, String> responseMap=(Map<String, String>)JSON.deserialize(tokenResponse, Map<String, String>.class);
			failMsg=new ApexPages.Message(ApexPages.Severity.FATAL,responseMap.get('error'));
			ApexPages.addMessage(failMsg);
			return;
		}

		// Otherwise, deserialize the result....
		Map<String, Object> responseMap=(Map<String, Object>)JSON.deserializeUntyped(tokenResponse);

		//... clear out the client secret and id (which we only want stored at the org level)
        a.client_secret__c=null;
        a.client_id__c=null;
        //... set our OAuth token
		a.token__c=(String)responseMap.get('access_token');
		//... our refresh token
		a.refresh__c=(String)responseMap.get('refresh_token');
		//... and this user's Automatic id
		a.automatic_id__c=(String)((Map<String,Object>)responseMap.get('user')).get('id');
		upsert a;

		authorized=true;

	}
}