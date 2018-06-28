public class token {



/*

Refreshing an Access Token

Access tokens have a limited life span and when you receive one you'll also receive an Expiry Time for it and a Refresh Token. 
Once your access token expires it can no longer be used to access the API. 
So you'll need to trigger a refresh. You do this by POSTing the following query string parameters:

'client_id' // your API Key
'client_secret' // your API Secret
'refresh_token' // your refresh token
'grant_type' // this should say refresh_token
To this url:

https://secure.myob.com/oauth2/v1/authorize
*/
public static void refresh() {
//This Method gets a new Authorized Token by presenting the Refresh Token
//    UserTokens__c u = [select Refresh_Token__c from UserTokens__c 
//         where isAuthorized__c = true AND Service_Name__c = :myob.service];

String authorizedStr;
String body='client_id='+myob.ConsumerKey+'&client_secret='+myob.ConsumerSecret+'&grant_type=refresh_token&refresh_token='+usertoken.Refresh_Token;
System.debug(body);
HTTPResponse res;
if (!Test.isRunningTest()) {
    res = token.Callout(myob.RefreshTokenURL,body,'POST','');
    authorizedStr = res.getBody();
    }
else
    { 
    authorizedStr = '{"access_token":"_FcmVa","token_type":"bearer","expires_in":"1200","refresh_token":"7ZsA!Zw","scope":"CompanyFile"}';
    }

System.debug('authstr = '+authorizedStr);
            List<MYOBOAuthResponse> r = 
          (List<MYOBOAuthResponse>)JSON.deserialize('['+authorizedStr+']', List<MYOBOAuthResponse>.class);
          usertoken.Expires_In = r[0].expires_in;
          usertoken.Token_Type = r[0].token_type;
          usertoken.Refresh_Token = r[0].refresh_token;
          usertoken.token = r[0].access_token;
          if (usertoken.token != null) {
                    usertoken.isAuthorized = true;
          }
if (!System.isFuture()) {
//    usertoken.deferredWrite();
    }
    }   
//This Method gets Authorized Token
public static HTTPResponse request(String code, String nonce){
 
String body='client_id='+myob.ConsumerKey+'&redirect_uri='+EncodingUtil.urlEncode(myob.CallBackURL,'UTF-8')+'&client_secret='+myob.ConsumerSecret+'&grant_type=authorization_code'+'&code='+code;
// String body='client_id='+this.clientId+'&client_secret='+this.clientSecret+'&grant_type=authorization_code'+'&code='+code;
if (myob.Scope != null) {
    body=body+'&scope='+myob.Scope;
    }

if (myob.StateParameterRequired) {
   body=body+'&state='+nonce;
// find the nonce that we used in the first leg of the OAuth 
//    UserTokens__c userToken = [select nonce__c from UserTokens__c where isAuthorized__c = true
//and CreatedBy.Name=:userInfo.getName() and OAuth_Service__c = :this.serviceId];
//    body=body+'&state='+state; 
    }   
//String authorizedStr = '{"access_token":"_FcmVa","token_type":"bearer","expires_in":"1200","refresh_token":"7ZsA!Zw","scope":"CompanyFile"}";
//if (!Test.isRunningTest())
HTTPResponse res = Callout(myob.AccessTokenURL,body,'POST','');
return res;

    

}

Static HttpResponse Callout(String endPoint,String body,String method,String urlparams){
/*
This low level method will callout to the specified endpoint with either 
parameters appended to the endpoint URL or the specified body.
*/
String url;
HttpRequest req = new HttpRequest();
req.setMethod(method);
req.setHeader('Content-Length','0');
if (urlparams != null) {
        url=endPoint+'?'+urlparams;   
    }
if (body!=null) {
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody(body);
    }
        
req.setEndpoint(url);
req.setTimeout(20000);
Http http = new Http();

if (!Test.isRunningTest()) {
    HTTPResponse res = http.send(req);
    return res;
    }
else {
    HTTPResponse res = new HTTPResponse();
    res.setbody('{"access_token":"_FcmVa","token_type":"bearer","expires_in":"1200","refresh_token":"7ZsA!Zw","scope":"CompanyFile"}');
    res.setStatusCode(200);
    return res;
    }


}

}
