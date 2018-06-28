public class SendTeamEmailConfirmationCtl {
    
    Id recordid = System.currentPageReference().getParameters().get('id');
    
	public PageReference previous() {
		String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
		return new PageReference(baseURL + '/' + recordid);
	}

}