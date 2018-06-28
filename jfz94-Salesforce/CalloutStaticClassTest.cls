@isTest
public class CalloutStaticClassTest {
    @isTest static void testCalloutWithStaticResources(){
        // use StaticResourceCalloutMock built-in class to specify fake response and include response body in a static resource //
      	StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('staticResourceTest'); // set name of the static Resource //
        mock.setStatusCode(200);
        mock.setHeader('Content-Type','application/json');
        
        // Set the mock callout mode //
       	Test.setMock(HttpCalloutMock.class, mock); // send this fake response  //
        
        // Call the method that performs the callout //
        // metode que te la req //
        HttpResponse res = CalloutStaticClass.getInfoFromExternalService('http://api.salesforce.com/foo/bar');
        // verify response received contains values returned by the mock response //
        // This is the content of the static resource //
        System.assertEquals('{"hah":"fooled you"}', res.getBody());
		System.assertEquals(200,res.getStatusCode());
		System.assertEquals('application/json', res.getHeader('Content-Type'));
    }
}
