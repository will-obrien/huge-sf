public class HttpCalloutSample {
    // Pass in the endpoint to be used using the string url //
    public static HttpResponse getCalloutResponseContents(String url){
        Http h = new Http(); // instantiate a new http object //
        HttpRequest req = new HttpRequest(); // instantiate a new Http request, spectify the method(GET) as well as the endpoint //
        req.setEndpoint(url); // specifies the endpoint //
        req.setMethod('GET'); // obtain information from the server // POST send information to the server //
        HttpResponse res = h.send(req); // send an httpRequest and returns the response //
        System.debug('*****Body returned in the response: ' + res.getBody());
        return res; // return the httpResponse //
    }
}
