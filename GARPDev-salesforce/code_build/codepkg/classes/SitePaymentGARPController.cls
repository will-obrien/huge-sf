global with sharing class SitePaymentGARPController {
    
    global String sURL {get; set;}
    global String cURL {get; set;}   
    global String fURL {get; set;}   
    
    global SitePaymentGARPController() {
        sURL = 'https://build-garpbuild.cs16.force.com/redirect?pass=1&url=' + ApexPages.currentPage().getParameters().get('sURL');
        cURL = 'https://build-garpbuild.cs16.force.com/redirect?url=' + ApexPages.currentPage().getParameters().get('cURL');
        fURL = 'https://build-garpbuild.cs16.force.com/redirect?pass=0&url=' + ApexPages.currentPage().getParameters().get('fURL');
    }
 }