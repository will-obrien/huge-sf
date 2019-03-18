public with sharing class CreateRemoteSiteSetting {
    
	public static void createRemoteSiteSettings(String fullName, String url){   
	    MetadataService.MetadataPort service = createService();
	    MetadataService.RemoteSiteSetting remoteSiteSettings = new MetadataService.RemoteSiteSetting();
	    remoteSiteSettings.fullName = fullName;
	    remoteSiteSettings.url = url;
	    remoteSiteSettings.description = '';
	    remoteSiteSettings.isActive=true;
	    remoteSiteSettings.disableProtocolSecurity=false;
	    MetadataService.AsyncResult[] results = service.create(new List<MetadataService.Metadata> { remoteSiteSettings });
	    
	    if(!Test.isRunningTest()) {
	    	MetadataService.AsyncResult[] checkResults = service.checkStatus(new List<string> {string.ValueOf(results[0].Id)});
	    } else {
	    	
	    	MetadataService.AsyncResult[] checkResults = service.checkStatus(null);
	    	
	    	MetadataService.CreateResponse_Element cRespElement = new MetadataService.CreateResponse_Element();
	    	MetadataService.AsyncResult asy = new MetadataService.AsyncResult();
			MetadataService.CheckStatus_Element statusEle = new MetadataService.CheckStatus_Element();
			MetadataService.CheckStatusResponse_Element respElement = new MetadataService.CheckStatusResponse_Element();
			MetadataService.PackageTypeMembers pkgMember = new MetadataService.PackageTypeMembers();
			MetadataService.DebuggingHeader_Element headerElement = new MetadataService.DebuggingHeader_element();
			MetadataService.LogInfo logInfo = new MetadataService.LogInfo();
			MetadataService.Metadata mData = new MetadataService.Metadata();
			MetadataService.SessionHeader_Element sElement = new MetadataService.SessionHeader_Element();
			MetadataService.RetrieveResponse_Element retrieveElement = new MetadataService.RetrieveResponse_Element();
			MetadataService.DebuggingInfo_Element debugElement = new MetadataService.DebuggingInfo_Element();
			MetadataService.CallOptions_Element calloptionElement = new MetadataService.CallOptions_Element();
			MetadataService.CheckDeployStatus_Element deploElement = new MetadataService.CheckDeployStatus_Element();
			MetadataService.Create_Element createElement = new MetadataService.Create_Element();
	    }
	}
	
	public static MetadataService.MetadataPort createService(){
	    MetadataService.MetadataPort service = new MetadataService.MetadataPort();
	    service.SessionHeader = new MetadataService.SessionHeader_element();
	    service.SessionHeader.sessionId = UserInfo.getSessionId();
	    return service;
	}
}