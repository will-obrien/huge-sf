public class WaveLabsController {
    private static String URL_LENS_APEX = '/analytics/wave/web/lens.apexp';
    public static String URL_HEROKU = 'https://www.jumpstartwave.com';
    private static String URL_HEROKU_ENCRYPT_ENDPOINT = 'encryptToken';
    
    private String org;
    private String sid;

    public String   getOrg()                           { return org; }
    public void     setOrg(String o)                   { org = o; }    
    public String   getSid()                           { return sid; }
    public void     setSid(String id)                  { sid = id; }
    
    public WaveLabsController() {
        String forwardedHeader = ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To');
        org = 'https://' + ((forwardedHeader == null) ? ApexPages.currentPage().getHeaders().get('host') : forwardedHeader);
        sid = getSessionIdFromLensApex(); 
        
        // Even though URL params are SSL-encrypted over the wire, in case web logs show unencrypted...
        sid = encryptString(sid);   
    }
    
    // Encrypt on Heroku via POST call: log lines shouldn't not contain the unencrypted session id
    private String encryptString(String s) {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse res;
        String resp;
        
        // Get dashboard definition
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');        
        req.setEndpoint(WaveLabsController.URL_HEROKU + '/' + WaveLabsController.URL_HEROKU_ENCRYPT_ENDPOINT);
        req.setBody('{"token": "' + s + '"}');
        
        if(test.isRunningTest()) {
            resp = '123456';
        } else {
            res = http.send(req);
            resp = res.getBody();            
        }
        // This is to identify session IDs that are encrypted. 
        // If you hit wave labs directly, this won't exist.
        String suffix = 'wavelabs';
        return resp + suffix;
    }

    // This is a bit of a hack. Remove once dashboard public API is available
    // lens.apexp contains the OAuth token
    // UserInfo.getSessionId() is not a first-class token in unmanaged packages
    // so it will fail for the /insights... "private" API calls    
    public String getSessionIdFromLensApex() {
        String homeContent;
        PageReference home = new PageReference(org + WaveLabsController.URL_LENS_APEX);

        if(test.isRunningTest()) {
            homeContent = 'Some random string';
        } else {
        	blob homeblob = home.getContent();            
            homeContent = homeblob.toString();
        }
        Matcher m = Pattern.compile('\"OAuth \" [+] \"([\\w!.]+)').matcher(homeContent);
        
        if(m.find()) {
            return m.group(1);
        } else {
            return UserInfo.getSessionId();
        }
    }    
}