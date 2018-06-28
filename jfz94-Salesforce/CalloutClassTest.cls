@isTest
private class CalloutClassTest {
    @isTest static void testCallout(){
        Test.setMock(HttpCalloutMock.class, new MyHttpCalloutMockImpl()); // Set mock callout class
        // Call method to test //
        /* 
         * This causes a fake response to be sent
		 * from the class that implements HttpCalloutMock 
		*/
        HttpResponse res = HttpCalloutSample.getCalloutResponseContents('http://api.salesforce.com/foo/bar'); // cridem al metode que te la solicitud http //
        // Verify response received contains fake values //
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar"}';
        System.assertEquals(actualValue,expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
}
