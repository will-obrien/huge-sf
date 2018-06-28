@isTest
global class MockHttpResponseGenerator_2 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://onlinetools.ups.com/ups.app/xml/XAV', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><item><pubDate>'+'tessttesttest'+ '</pubDate></item></Body></Envelope>');
        res.setStatusCode(200);
        return res;
    }
}