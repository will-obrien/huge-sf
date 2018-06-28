public without sharing class ConstituentHeaderController {
    public PageReference resetPassword() {
    	System.resetPassword(UserInfo.getUserId(), true);
		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Password reset - please check your email'));
    	return null;
    }
    public boolean getIsHomePage() {
		Pattern thePattern = Pattern.compile('.*Home$');
		
		// Then instantiate a new Matcher object "MyMatcher"
		System.debug('matching:' + System.currentPageReference().getURL());
		Matcher theMatcher = thePattern.matcher(System.currentPageReference().getURL());
		
		// You can use the system static method assert to verify the match
		return theMatcher.matches();    
	}
	public String getLogoutLink() {
		if(UserInfo.getUserType() == 'Standard') {
			return System.Url.getSalesforceBaseUrl().toExternalForm();
		}
		return '/campfire/secur/logout.jsp';
	}
}