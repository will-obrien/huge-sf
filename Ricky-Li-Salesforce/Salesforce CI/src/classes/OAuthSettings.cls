public with sharing class OAuthSettings {

	public String consumerKey { get; set; }
	public String consumerSecret { get; set; }
	public String requestTokenURL { get; set; }
	public String authorizeURL { get; set; }
	public String accessTokenURL { get; set; }
	public String callbackURL { get; set; }
	public String token { get; set; }
	public String tokenSecret { get; set; }
	public String verifier { get; set; }
	public Boolean isValid { get; set; }
}