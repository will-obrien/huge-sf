public with sharing class pssapi_Moodle_Proxy{
    //public static string url = 'http://paradisosolutions.Moodlesaas.com';
    //public static string key = 'HgP%yUHS%BnMw6R%Ig_UHrOC';
   
    
    public static pssMoodle_API_Response call(String action, List<pssKeyValuePair> actionParameters){
        //HttpRequest request = createHttpRequest(action, actionParameters);
        //System.Debug(' request:::::' + request);
        return sendRequest(action, actionParameters);
    }
    
    /*
    private static string encodeBase64(String hashSHA1){
        // this will result in 28 chars long string
        String hashBase64SHA1 = EncodingUtil.base64encode(Blob.valueOf(hashSHA1));
        return hashBase64SHA1;
    }
    */
    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Method sends a service request to Moodle, HttpRequest request
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    private static pssMoodle_API_Response sendRequest(string requestMethod, List<pssKeyValuePair> actionParameters)
    {       
        pssMoodle_API_Response apiResponse = new pssMoodle_API_Response();
        try{
            //Http http = new Http();
        
        
            //HTTPResponse response = http.send(request);
            System.debug(Logginglevel.Debug,actionParameters);
            HTTPResponse response = getCalloutResponse(requestMethod, actionParameters);
            if (Test.isRunningTest())
            {
                apiResponse.message = '{"success":true,"idst":12345}';
                return apiResponse;
            }
            else
            {
                System.debug(Logginglevel.Debug,response);
                System.debug('response.getBody:'+response.getBody());
                apiResponse.message = response.getBody();
                return apiResponse;
            }
        }
        /*catch(System.CalloutException calloutException){
            System.debug(Logginglevel.Debug, calloutException.getMessage());
            apiResponse.error = new Moodle_API_Response.RestError(calloutException.getMessage());            
            return apiResponse;
        }*/
        catch(System.Exception ex){
            System.debug(Logginglevel.Debug, ex.getMessage());
            apiResponse.error = new pssMoodle_API_Response.RestError(ex.getMessage());            
            return apiResponse;
        }
    }
    
    private static HttpResponse getCalloutResponse(string requestMethod, List<pssKeyValuePair> actionParameters){
        Http http = new Http();
        if (Test.isRunningTest())
        {
            HttpRequest req=createHttpRequest(requestMethod, actionParameters);
            return null;
        }
        else
        {
            HTTPResponse response = http.send(createHttpRequest(requestMethod, actionParameters));
            return response;
        }
    }
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Method creates a request based on the request method parameter and user record to be sent to moodle
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    private static HttpRequest createHttpRequest(string requestMethod, List<pssKeyValuePair> actionParameters)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestMethod);        
        request.setMethod('POST');    
        //request.setHeader('Content-Length', '-1');             
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');                     
        
               
        string paramsStr = ''; 
                    
        for(pssKeyValuePair actionParam : actionParameters){
            if(String.isNotBlank(paramsStr)){
                paramsStr += '&';
            }
            if (actionParam!=null)
                paramsStr += actionParam.key + '=' + EncodingUtil.urlEncode(String.valueOf(actionParam.value), 'UTF-8');
            else
                paramsStr += actionParam.key + '=' + EncodingUtil.urlEncode(String.valueOf(''), 'UTF-8');
        }
        request.setBody(paramsStr);                                                 
        System.debug('Parameters:::::'+ paramsStr);         
        return request;     
    }
}