@RestResource(urlMapping='/Case/*')
global with sharing class ApexRESTWebServices {
  
    @HttpGet
    global static Case doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String caseNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Case result = [SELECT Id, Subject FROM Case WHERE CaseNumber = :caseNumber];
        return result;
    }
  
}