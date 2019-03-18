@isTest
private class TestTwitterClient {

	static testMethod void testAuthorize() {
		TwitterClient tc = new TwitterClient();
		String returnUrl = tc.authroize();
		System.assertEquals(returnUrl, null);
	}
	
	static testMethod void testCompleteAuthorization() {
		TwitterClient tc = new TwitterClient();
		Boolean result = tc.completeAuthorization('test', '');
		System.assertEquals(result, false);
	}
	
	static testMethod void testClearToken() {
		TwitterClient tc = new TwitterClient();
		tc.clearToken();
	}
	
	static testMethod void testTweet() {
		TwitterClient.tweet('This is a long post that will get divided up into several tweets.  It will also have a mention of @John Salama and a hash tag of #test.  I think we have to make it even longer to trigger the 140 character limit');	
	}
	
	static testMethod void testGetOAuthSettings() {
		TwitterClient tc = new TwitterClient();
		OAuthSettings settings = tc.getOAuthSettings();
		System.assertNotEquals(settings, null);
	}
	
	static testMethod void testGetMessage() {
		TwitterClient tc = new TwitterClient();
		String message = tc.getMessage();
		System.assertEquals(message, null);
	}
}