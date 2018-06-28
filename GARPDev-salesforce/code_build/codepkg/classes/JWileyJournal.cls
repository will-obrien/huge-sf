public with sharing class JWileyJournal {
    public String response {get; set;}
    public JWileyJournal() {
        //QbApiController api = new QbApiController ('GET', 'QB API' , null, null, 'https://appcenter.intuit.com/api/v1/Account/AppMenu');
        //response = api.execute();
        
		Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.cheenath.com/tutorial/sample1/build.xml');
        req.setMethod('GET');
        HttpResponse res = http.send(req);
    
        // Log the XML content
        System.debug(res.getBody());
        
        response = res.getBody();
    }
}