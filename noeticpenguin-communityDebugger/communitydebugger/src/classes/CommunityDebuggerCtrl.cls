public with sharing class CommunityDebuggerCtrl {
	public String failingPageResponse { get; set; }

	String toLoad {get; private set;}
	Map<String, String> params {get; private set;}
	String queryString = '?';

	public CommunityDebuggerCtrl() {
		params = ApexPages.currentPage().getParameters();
		toLoad = (String) params.get('page');
		params.remove('page');

		for (String key : params.keyset()) {
			queryString = key + '=' + params.get(key);
		}
	}

	public void fetchFailingPage() {
		try {
			// Make a call to failing sites page here
			PageReference fail = new PageReference('/' + toLoad + queryString);
			failingPageResponse = fail.getContent().toString();
		} catch (Exception e) {
			failingPageResponse = e.getTypeName() + ' : ' + e.getMessage() + ' : ' + e.getStackTraceString();
		}
	}
}