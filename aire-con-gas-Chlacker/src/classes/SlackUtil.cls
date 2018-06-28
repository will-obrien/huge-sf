public with sharing class SlackUtil {
    public static String baseUrl = 'https://slack.com';
    public static String slackTeam = '[YOUR SLACK TEAM]';
    
    public static HttpResponse doHttpRequest(String method, String url, String bodyParams){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(method);
        req.setBody(bodyParams);

        Http http = new Http();
        HttpResponse res = http.send(req);
        return res;
    }
    
    public static String getAuthorizationUrl(String clientId, String redirectUrl, String stateObjId){
        String authorizeUrl = SlackUtil.baseUrl + '/oauth/authorize';
        return authorizeUrl + SlackUtil.buildAuthorizationParams(clientId, redirectUrl, stateObjId);
    }
    
    public static String getOauthAccessUrl(){
        return baseUrl + '/api/oauth.access';
    }
    
    public static String getCreateChannelUrl(){  
        return baseUrl + '/api/channels.create';
    }
    
    
    public static String buildAuthorizationParams(String clientId, String redirectUrl, String stateObjId){
        String urlParams = '?client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
                '&redirect_uri=' + EncodingUtil.urlEncode(redirectUrl, 'UTF-8') +
                '&state=' + EncodingUtil.urlEncode(stateObjId, 'UTF-8') +  
                '&team=' + slackTeam;
        return urlParams;
    }
    
    public static String buildOauthParams(String clientId, String clientSecret, String callbackUrl, String code){
        String bodyParams = 'client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
                    '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8') +
                    '&redirect_uri=' + EncodingUtil.urlEncode(callbackUrl, 'UTF-8') +
                    '&code=' + EncodingUtil.urlEncode(code, 'UTF-8');
        return bodyParams;
    }
    
    public static String buildCreateChannelParams(String token, String channelName){
        String bodyParams = 'token=' + EncodingUtil.urlEncode(token, 'UTF-8') +
                    '&name=' + EncodingUtil.urlEncode(channelName, 'UTF-8');
        return bodyParams;
    }
    
    //Taken from stackexchange
    //http://salesforce.stackexchange.com/questions/43823/how-do-i-generate-a-random-string
    public static String generateRandomString(Integer len) {
    	final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
    	String randStr = '';
    	while (randStr.length() < len) {
       		Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
       		randStr += chars.substring(idx, idx+1);
    	}
    	return randStr;
    } 
}
    
