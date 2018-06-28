public class ChlackerController {
    String isCallback = getUrlParam('callback');
    String redirectToSlack = getUrlParam('slack');
    String apiObjType = getUrlParam('apiObjType');
    String apiObjCol = getUrlParam('apiObjCol');
    String apiObjId = getUrlParam('apiObjId');
    String channelName = getUrlParam('channelName');
    
    public String channelToCreate { get; set; }
    
    private String clientId = '';
    private String clientSecret = '';
    private String callbackUrl = getCurrentPageURL() + '?callback=1';
    private String slackTeam = '[YOUR SLACK TEAM]';
    private String randomStateString = '';
    
    public ChlackerController(){
        Slack_Client_settings__c slackSettings = Slack_Client_settings__c.getInstance(slackTeam);
        clientId = slackSettings.Client_ID__c;
        clientSecret = slackSettings.Client_Secret__c;
        //from Slack API docs:
        //state string used to avoid forgery attacks by passing in a value 
        //that's unique to the user you're authenticating and checking it when auth completes
        randomStateString = SlackUtil.generateRandomString(6);  
    }
    
    public PageReference redirectToSlacker(){        
        PageReference pageRef = null;
        
        if(redirectToSlack != null && redirectToSlack == '1') {
        	channelToCreate = channelName;
            String slackAuthUrl = SlackUtil.getAuthorizationUrl(clientId, callbackUrl, randomStateString);
            pageRef = new PageReference(slackAuthUrl);
            return pageRef;
        } else if(isCallback != null && isCallback == '1') {
            String stateToken = ApexPages.currentPage().getParameters().get('state');
            String code = ApexPages.currentPage().getParameters().get('code');
            if(stateToken != null && stateToken == randomStateString) {
                String oauthAccessUrl = SlackUtil.getOauthAccessUrl();
                String bodyParams = SlackUtil.buildOauthParams(clientId, clientSecret, callbackUrl, code); 
                HttpResponse res = SlackUtil.doHttpRequest('POST', oauthAccessUrl, bodyParams);
                
                //save the token
                String accesstoken = '';
                JSONParser parser = JSON.createParser(res.getBody());
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                        String fieldName = parser.getText();
                        parser.nextToken();
                        if(fieldName == 'access_token') {
                            accesstoken = parser.getText();
                            break;
                        } 
                    }
                }

                //TODO - check if channel has already been created or not
                //create channel
                String createChannelUrl = SlackUtil.getCreateChannelUrl();
                bodyParams = SlackUtil.buildCreateChannelParams(accesstoken, channelToCreate); 
                res = SlackUtil.doHttpRequest('POST', createChannelUrl, bodyParams);
                
                TokenManagerService.upsertToken(clientId, accesstoken);
            }
        }
            
        return null;
    }
    
    private String getCurrentPageURL() {
        String hostVal  = ApexPages.currentPage().getHeaders().get('Host');
        return 'https://' + hostVal + '/apex/chlacker';
    }
    
    private String getNamespacePrefix(){
        ApexClass myClass = [select NamespacePrefix from ApexClass where Name = 'HelloWorld2'];
        return myClass.NamespacePrefix;
    }
    
    private String getUrlParam(String key){
        return ApexPages.currentPage().getParameters().get(key);
    }
    
}