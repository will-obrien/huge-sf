global with sharing class SitePaymentGARPController {
    
    global String sURL {get; set;}
    global String cURL {get; set;}   
    global String fURL {get; set;}   
    
    global SitePaymentGARPController() {
        sURL = '/chargent/redirect?pass=1&url=' + ApexPages.currentPage().getParameters().get('sURL') + '&oppid=' +  ApexPages.currentPage().getParameters().get('oppid');
        cURL = '/chargent/redirect?url=' + ApexPages.currentPage().getParameters().get('cURL') + '&oppid=' +  ApexPages.currentPage().getParameters().get('oppid');
        fURL = '/chargent/redirect?pass=0&url=' + ApexPages.currentPage().getParameters().get('fURL') + '&oppid=' +  ApexPages.currentPage().getParameters().get('oppid');
    }
 }