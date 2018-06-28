public class DropboxController
{
    //Fetched from URL
    String code ;
    
    public DropboxController()
    {
        code = ApexPages.currentPage().getParameters().get('code') ;
        //Get the access token once we have code
        if(code != '' && code != null)
        {
            AccessToken() ;
        }
    }
    
    public PageReference DropAuth()
    {
        //Authenticating
        PageReference pg = new PageReference('https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=zrtqto39gysifaq&redirect_uri=https://c.ap1.visual.force.com/apex/lightingprefix__DropboxPage&state=Mytesting') ;
        return pg ;
    }
    
    public void AccessToken()
    {
        //Getting access token from dropbox
        String tokenuri = 'https://api.dropbox.com/1/oauth2/token?grant_type=authorization_code&code='+code+'&redirect_uri=https://c.ap1.visual.force.com/apex/lightingprefix__DropboxPage'; 
        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenuri);
        req.setMethod('POST');
        req.setTimeout(60*1000);
          
        Blob headerValue = Blob.valueOf('zrtqto39gysifaq' + ':' + 'nax4getvm9v3suq');
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        
        System.debug(' You can parse the response to get the access token ::: ' + resp);
   }
}