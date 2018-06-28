@isTest
private class CalloutClassTest {

    static testMethod void testCallout() 
    {
        // TO DO: implement unit test
        Test.setMock(HttpCalloutMock.class,new MockHttpResponseGenerator());
        
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType=='application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo","bar"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        
    }
}