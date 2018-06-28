public class MYOBrequest{
/*
 Create HTTP request object and set the required headers for the MYOB API
*/    
    public static HTTPRequest header(String apiVersion, String method, String body, String suffix  ) {
        
        HTTPRequest req= new HTTPRequest();
        String ep = myob.APIendPoint;
//        ep = 'https://api-myob-com-cnvl6ftqeary.runscope.net/accountright/';  //Debug trace via Runscope
        if (usertoken.MYOB_File_GUID != null && usertoken.MYOB_File_GUID != '') ep += usertoken.MYOB_File_GUID;
        if (suffix != null && suffix != '') ep += suffix;
        req.setEndpoint(ep);
        req.setMethod(method);
        req.setHeader('Content-Length','0');
        req.setHeader('Content-Type','application/json');    //needed for MYOB endpoints after OAuth stuff
        req.setHeader('Authorization','Bearer '+usertoken.Token);
        // Need username | password of actual file for all API calls for a specific file (GUID)
        String username_password = myob.Username+':';
        if (myob.Password != null) username_password += myob.Password;
    
        Blob headerValue = Blob.valueOf(username_password);
        String username_password_Base64 = EncodingUtil.base64Encode(headerValue);
        req.setHeader('x-myobapi-cftoken',username_password_Base64);
        req.setHeader('x-myobapi-key',myob.ConsumerKey); //[dev_key]
        req.setHeader('x-myobapi-version',apiVersion);
        req.setHeader('Accept-Encoding','gzip,deflate');
        system.debug('Callout to MYOB '+req.toString());
        if (body != null && body != '') req.setBody(body);
        req.setTimeout(20000);
        return req;
}
}
