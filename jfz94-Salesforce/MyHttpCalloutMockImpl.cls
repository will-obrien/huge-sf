/*
 * implementació per a la interficie HttpCalloutMock per especificar la resposta enviada en el metode respond
	el cual Apex executa per a donar una resposta al callout.
	Aquesta clase pot ser tant global com public.
*/ 
global class MyHttpCalloutMockImpl implements HttpCalloutMock {
    global HttpResponse respond(HTTPRequest req){
        System.assertEquals('http://api.salesforce.com/foo/bar',req.getEndpoint()); // recupera la url del servidor extern per a la solicitud //
        System.assertEquals('GET', req.getMethod()); // recupera el tipus de metode usat per HttpRequest //
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        // return response
    	return res;
    }
}
