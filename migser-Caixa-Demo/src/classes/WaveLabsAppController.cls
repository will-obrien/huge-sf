global without sharing class WaveLabsAppController {

    global String org{get; set;}
    
    global WaveLabsAppController() {       
        String forwardedHeader = ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To');
        org = (forwardedHeader == null) ? ApexPages.currentPage().getHeaders().get('host') : forwardedHeader;
    }
    
    @RemoteAction
    global static String createRemoteSiteSettings(String instance) {     
        
        String remoteSiteSettingOrg = 'https://' + instance + '.salesforce.com';
        String remoteSiteSettingHeroku = WaveLabsController.URL_HEROKU;  
        //Will be created by VF Javascript
        //String remoteSiteSetting2 = 'https://c.' + instance + '.salesforce.com';
        
        CreateRemoteSiteSetting.createRemoteSiteSettings('WaveLabsApp_Org_URL', remoteSiteSettingOrg);
        CreateRemoteSiteSetting.createRemoteSiteSettings('WaveLabsApp_Jumpstartwave_URL', remoteSiteSettingHeroku);        
        //CreateRemoteSiteSetting.createRemoteSiteSettings('WaveLabsApp_OrgVF_URL', remoteSiteSetting2);
        
        return instance;
    } 
}