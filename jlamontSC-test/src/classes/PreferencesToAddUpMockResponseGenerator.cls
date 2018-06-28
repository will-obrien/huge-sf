global class PreferencesToAddUpMockResponseGenerator implements HttpCalloutMock {
	global String testOption;
	
	public PreferencesToAddUpMockResponseGenerator(String option) {
		this.testOption = option;
	}

	global HttpResponse respond(HttpRequest req) {
		HttpResponse res = new HttpResponse();
		if(req.getEndpoint().contains('login')) {
			res.setBody(
				'{\"status\": \"ok\",\"data\": {\"api_token\": \"jIcgQxqfAKAWwD0kSCqKr8WcK\"}}'
			);
			res.setStatus('OK');
		}
		else if(testOption == 'Good Response') {
			res.setBody(
				'{\"status\": \"ok\",\"data\": {\"profile\": {\"email_opt_in_campaign_updates\": 1, \"email_opt_in_user_recommendations\": 0,\"email_opt_in_fb_friend_recommendations\": 0}}}'
			);
			res.setStatus('OK');
		}
		else if(testOption == 'Invalid User') {
			res.setBody(
				'{\"status\": \"error\",\"message\": \"invalid user\"}'
			);
			res.setStatus('Bad Request');
			res.setStatusCode(400);
		}
		else if(testOption == 'Unauthorized') {
			res.setStatus('Unauthorized');
			res.setStatusCode(401);
		}
		return res;
	}
}