public class OAuthAuthentication {
    

    public static String UpdateOAuthCodeUser(String oauth_code,String state){
/*
        //Now call auth service to get authorized tokens 
        //If ?code= parameter has been specified then it is a Oauth callback to the Redirect URI
        //If not then do nothing other than return
*/        
        String message = '';
        if (oauth_code != null){
            oauth_code = EncodingUtil.urlEncode(oauth_code,'UTF-8');

        
            if (myob.StateParameterRequired = false) state =null;
            HTTPResponse res = token.request(oauth_code,state);
            if (res.getStatusCode() != 200) {
                message='Authorization Failed...'+res.getStatusCode()+' '+res.getStatus();
                system.debug('Response '+ res.getStatusCode()+' '+res.getStatus());
                system.debug(res.getBody());
            }
            else
            {
                String authorizedStr = res.getBody();
                System.debug('authstr = '+authorizedStr);
            List<MYOBOAuthResponse> r = 
          (List<MYOBOAuthResponse>)JSON.deserialize('['+authorizedStr+']', List<MYOBOAuthResponse>.class);

          userToken.Expires_In = r[0].expires_in;
          userToken.Token_Type = r[0].token_type;
          userToken.Refresh_Token = r[0].refresh_token;
          userToken.token = r[0].access_token;
          if (userToken.token != null) {
                    userToken.isAuthorized = true;
          message='Authorization Successful..'+'Access Token:'+UserToken.token;
          } 

            }
        
            // update the user token and other information for future use.

//            usertoken.write();        
        }
        return message;         
            
    }

}
