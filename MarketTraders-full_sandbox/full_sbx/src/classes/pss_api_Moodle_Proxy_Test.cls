@isTest
private class pss_api_Moodle_Proxy_Test{
    static testMethod void testCall(){        
        Test.startTest();
        List<pssKeyValuePair> parameterList = new List<pssKeyValuePair>();
        parameterList.add(new pssKeyValuePair('updated_from','2013-12-22'));
        parameterList.add(new pssKeyValuePair('count',10));
        pssMoodle_API_Response apiresponse = pssapi_Moodle_Proxy.call('test/test', parameterList);
        
        try
        {
            pssMoodle_Api_Response m = new pssMoodle_Api_Response();
            m.error=new pssMoodle_Api_Response.RestError('asd');           
            List<pssKeyValuePair> parameterList1;
            parameterList1.add(new pssKeyValuePair('count',10));            
        }
        catch(Exception ex)
        {
            
        }
        
        System.assertEquals(apiResponse.message, '{"success":true,"idst":12345}');
        
        
        Test.stopTest();
    }
    
    
}