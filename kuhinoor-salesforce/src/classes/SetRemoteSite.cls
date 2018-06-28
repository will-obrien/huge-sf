public with sharing class SetRemoteSite{
    
    public static void createRemoteSiteSettings()
    {   
        MetadataServiceForRemoteSite.MetadataPort service = createService();
        MetadataServiceForRemoteSite.RemoteSiteSetting remoteSiteSettings = new MetadataServiceForRemoteSite.RemoteSiteSetting();
        remoteSiteSettings.fullName = 'Test12345';
        remoteSiteSettings.url = 'http://www.google.com';
        remoteSiteSettings.description='ewf';
        remoteSiteSettings.isActive=true;
        remoteSiteSettings.disableProtocolSecurity=false;
        MetadataServiceForRemoteSite.AsyncResult[] results = service.create(new List<MetadataServiceForRemoteSite.Metadata> { remoteSiteSettings });
        MetadataServiceForRemoteSite.AsyncResult[] checkResults = service.checkStatus(new List<string> {string.ValueOf(results[0].Id)});
        system.debug('chk' + checkResults );
    }
     public static MetadataServiceForRemoteSite.MetadataPort createService()
    {
        MetadataServiceForRemoteSite.MetadataPort service = new MetadataServiceForRemoteSite.MetadataPort();
        service.SessionHeader = new MetadataServiceForRemoteSite.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
}