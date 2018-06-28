public class ConstituentLoginController {
	public String username{get; set;}
	public String password {get; set;}
	private String baseUrl;
	public Boolean errors {get; set;} 
	
	public pageReference doLogin()
	{
		errors = false;
		PageReference ref = Site.login(username,password,null);
		if(ref == null) {
			errors = true;
			return null;
		}
		return ref;
	}
    public String getBaseUrl() {
    	if(baseUrl == null) {
    		Id networkId = [select Id from Network where Name = 'campfire'].Id;
	        String loginUrl = Network.getLoginUrl(networkId);
			baseUrl = loginUrl.substring(0, loginUrl.lastIndexOf('/'));
    	}
        return baseUrl;
    }
}