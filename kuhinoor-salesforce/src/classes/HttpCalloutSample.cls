public class HttpCalloutSample {
    // Pass in the endpoint to be used using the string url
   
    public String getContent(String url) {
        // Instantiate a new http object
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://ap1.salesforce.com/services/Soap/class/lightingprefix/helloService');
        req.setMethod('GET');
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        System.debug('***********************'+res.getBody());
        return res.getBody();
    }
}