/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {

    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String displayType = System.currentPageReference().getParameters().get('display');
        return Network.forwardToAuthPage(startUrl, displayType);
    }
    
    //Forward to custom auth page
    global PageReference forwardToCustomAuthPage() {       
        PageReference pr = Page.Login;
        for(String key : ApexPages.currentPage().getParameters().keySet()){
            pr.getParameters().put(key, ApexPages.currentPage().getParameters().get(key));
        }
        return pr;
    }
}