global class OAuth {
    private String nonce;
    private String timestamp;
    private String signature;
    private Map<String,String> parameters = new Map<String,String>();
    public String message { get; set; }

    public String processNewAuthResponse(HttpResponse res, OAuthSettings settings) {
        System.debug('Response from request token request: ('+res.getStatusCode()+')' + res.getBody());
        
        if(res.getStatusCode()>299) {
            message = 'Failed getting a request token. HTTP Code = '+res.getStatusCode() + '. Message: '+res.getStatus()+'. Response Body: '+res.getBody();
            return null;
        }       
        Map<String,String> rp = getUrlParams(res.getBody());
        settings.token = rp.get('oauth_token');
        settings.tokenSecret = rp.get('oauth_token_secret');
        settings.isValid = false;
        System.debug('Got request token: '+ settings.token +'('+rp.get('oauth_token')+')');
        if(settings.authorizeURL.contains('?')) {
            return settings.authorizeURL+'&oauth_token='+EncodingUtil.urlDecode(settings.token,'UTF-8')+'&oauth_consumer_key='+settings.consumerKey;
        } else {
            return settings.authorizeURL+'?oauth_token='+EncodingUtil.urlDecode(settings.token,'UTF-8')+'&oauth_consumer_key='+settings.consumerKey;
        }               
    }

    /**
     * Looks up service name and starts a new authorization process returns the authorization URL that the user should be redirected to. If null is returned, the request failed. The message property will contain
     * the reason.
     */ 
    public String newAuthorization(OAuthSettings settings, String completeAuthUrl) {
        if(settings.callbackURL==null) {    
            if(ApexPages.currentPage()==null || ApexPages.currentPage().getHeaders().get('Host')==null) {
                message = 'No callback page was set and it couldn\'t be generated from Apex context';
                System.debug(message);
                return null;
            }
            settings.callbackURL = EncodingUtil.urlEncode('https://'+ApexPages.currentPage().getHeaders().get('Host') + completeAuthUrl,'UTF-8');
        }
        HttpRequest req = this.buildRequest(settings.requestTokenURL, 'GET');
        System.debug('Request body set to: '+req.getBody());
        Http h = new Http();
        this.sign(req, settings);       
        return this.processNewAuthResponse(h.send(req), settings);
    }

    public HttpRequest buildRequest(String endpoint, String method) {
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(endpoint);      
        return req;
    }

    public boolean processCompleteAuthResponse(HttpResponse res, OAuthSettings settings, Map<String, String> rp) {      
        System.debug('Response from request token request: ('+res.getStatusCode()+')'+res.getBody());
        if(res.getStatusCode()>299) {
            message = 'Failed getting an access token. HTTP Code = '+res.getStatusCode()+'. Message: '+res.getStatus()+'. Response Body: '+res.getBody();
            return false;
        }
        String resParams = res.getBody();
        for(String s : resParams.split('&')) {
            List<String> kv = s.split('=');
            rp.put(kv[0],kv[1]);
            System.debug('Access token response param: '+kv[0]+'='+kv[1]);
        }
        settings.token = rp.get('oauth_token');
        settings.tokenSecret = rp.get('oauth_token_secret');
        settings.isValid = true;
        return true;
    }

    public boolean completeAuthorization(OAuthSettings settings, Map<String, String> rp) {
        System.debug('Completing authorization for request token '+ settings.token +' with verifier '+ settings.verifier);
        String verifier = settings.verifier;
        if(verifier!=null) { 
            verifier = EncodingUtil.urlEncode(settings.verifier,'UTF-8');
        }
        HttpRequest req = this.buildRequest(settings.accessTokenURL, 'POST');
        req.setBody('');
        this.sign(req, settings);
        if(!Test.isRunningTest()) {
            return this.processCompleteAuthResponse(new Http().send(req), settings, rp); 
        }
        else {
            return false;
        }       
    }

    private void refreshParameters(OAuthSettings settings) {
        parameters.clear();
        parameters.put('oauth_consumer_key', settings.consumerKey);
        if(settings.token!=null) {
            parameters.put('oauth_token',settings.token);
        }
        if(settings.verifier!=null) {
            parameters.put('oauth_verifier',settings.verifier);
        }
        parameters.put('oauth_signature_method','HMAC-SHA1');
        parameters.put('oauth_timestamp',timestamp);
        parameters.put('oauth_nonce',nonce);
        parameters.put('oauth_callback',settings.callbackURL);
    }

    private Map<String,String> getUrlParams(String value) {
        Map<String,String> res = new Map<String,String>();
        if(value==null || value=='') {
            return res;
        }
        for(String s : value.split('&')) {
            System.debug('getUrlParams: '+s);
            List<String> kv = s.split('=');
            if(kv.size()>1) {
              // RFC 5849 section 3.4.1.3.1 and 3.4.1.3.2 specify that parameter names 
              // and values are decoded then encoded before being sorted and concatenated
              // Section 3.6 specifies that space must be encoded as %20 and not +
              String encName = EncodingUtil.urlEncode(EncodingUtil.urlDecode(kv[0], 'UTF-8'), 'UTF-8').replace('+','%20');
              String encValue = EncodingUtil.urlEncode(EncodingUtil.urlDecode(kv[1], 'UTF-8'), 'UTF-8').replace('+','%20');
              System.debug('getUrlParams:  -> '+encName+','+encValue);
              res.put(encName,encValue);
            }
        }
        return res;
    }

    private String createBaseString(Map<String,String> oauthParams, HttpRequest req) {
        Map<String,String> p = oauthParams.clone();
        if(req.getMethod().equalsIgnoreCase('post') && req.getBody()!=null && req.getHeader('Content-Type')=='application/x-www-form-urlencoded') {
            p.putAll(getUrlParams(req.getBody()));
        }
        String host = req.getEndpoint();
        Integer n = host.indexOf('?');
        if(n>-1) {
            p.putAll(getUrlParams(host.substring(n+1)));
            host = host.substring(0,n);
        }
        List<String> keys = new List<String>();
        keys.addAll(p.keySet());
        keys.sort();
        String s = keys.get(0)+'='+p.get(keys.get(0));
        for(Integer i=1;i<keys.size();i++) {
            s = s + '&' + keys.get(i)+'='+p.get(keys.get(i));
        }
        // According to OAuth spec, host string should be lowercased, but Google and LinkedIn both expect that case is preserved.
        return req.getMethod().toUpperCase()+ '&' + EncodingUtil.urlEncode(host, 'UTF-8') + '&' + EncodingUtil.urlEncode(s, 'UTF-8');
    }

    public void sign(HttpRequest req, OAuthSettings settings) {
        nonce = String.valueOf(Crypto.getRandomLong());
        timestamp = String.valueOf(DateTime.now().getTime()/1000);
        refreshParameters(settings);
        String s = createBaseString(parameters, req);
        System.debug('Signature base string: '+s);
        Blob sig = Crypto.generateMac('HmacSHA1', Blob.valueOf(s), Blob.valueOf(settings.consumerSecret +'&'+ (settings.tokenSecret!=null ? settings.tokenSecret : '')));
        signature = EncodingUtil.urlEncode(EncodingUtil.base64encode(sig), 'UTF-8');
        System.debug('Signature: '+signature);
        String header = 'OAuth ';
        for (String key : parameters.keySet()) {
            header = header + key + '="'+parameters.get(key)+'", ';
        }
        header = header + 'oauth_signature="'+signature+'"';
        System.debug('Authorization: '+header);
        req.setHeader('Authorization',header);
    }   
}