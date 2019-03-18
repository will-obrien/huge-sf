public with sharing class WaveDashBoardController {

    @AuraEnabled
    public static String getDomainURL(String sitePrefix) {
        
         if (sitePrefix==null){
            
            return System.URL.getSalesforceBaseUrl().getHost();              
        }
            
        return System.URL.getSalesforceBaseUrl().getHost() + sitePrefix;
    }
    
}