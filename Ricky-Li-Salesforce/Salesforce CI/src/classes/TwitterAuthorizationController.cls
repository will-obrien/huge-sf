public with sharing class TwitterAuthorizationController {

    public String message { get; set; }
    public String userId { get; set; }
    public Boolean authorized { get; set; }
    public Boolean clearAuthorization { get; set;}
    public String url { get; set; }
    public Boolean renderIntro { get; set; }
    public Boolean falseTokens { get; set; }
    User u;
   
    public TwitterAuthorizationController(ApexPages.StandardController stdController) {
        this.userId = UserInfo.getUserId();
       
        u = [SELECT Id, Twitter_isValid__c, Twitter_OAuth_Token__c, Twitter_OAuth_Token_Secret__c
                     FROM User
                     WHERE Id = :UserInfo.getUserId()];
       
        falseTokens = false;
        renderIntro = false;
        authorized = false;
        clearAuthorization = false;
        if(u.Twitter_isValid__c == false && u.Twitter_OAuth_Token__c != null && u.Twitter_OAuth_Token_Secret__c != null)
            falseTokens = true;
       
        if(u.Twitter_isValid__c == true && u.Twitter_OAuth_Token__c != null && u.Twitter_OAuth_Token_Secret__c != null)
            this.clearAuthorization = true;
      
        if(u.Twitter_isValid__c == false && u.Twitter_OAuth_Token__c == null && u.Twitter_OAuth_Token_Secret__c == null){
            this.authorized = true;
            renderIntro = true;
        }   
    }

    public PageReference authorize() {
          
         TwitterClient client = new TwitterClient();    
         String authUrl = client.authroize();  
       
         System.Debug(u.Twitter_isValid__c);
         System.Debug(u.Twitter_OAuth_Token__c);
         System.Debug(u.Twitter_OAuth_Token_Secret__c);
        
         //Proceed here only if the tokens are empty
         if(u.Twitter_isValid__c == false && u.Twitter_OAuth_Token__c == null && u.Twitter_OAuth_Token_Secret__c == null){
             System.debug('Auth URL returned:[' + authUrl + ']');
             if(authUrl==null) {
               this.message = client.getMessage();
               this.renderIntro = false;
             } else {           
               this.url = authUrl;
             }
         }
        return null;
    }
   
    public PageReference clearTokens() {
        TwitterClient client = new TwitterClient();
        client.clearToken();
        this.url = '/' + this.userId + '?noredirect=1';
        this.renderIntro = true;
        return null;
    }
   
    public PageReference completeAuthorization() {
       
        TwitterClient client = new TwitterClient();
        String token = ApexPages.currentPage().getParameters().get('oauth_token');
       
        if(token!=null)
        {
            String verifier = ApexPages.currentPage().getParameters().get('oauth_verifier');
            Boolean success = client.completeAuthorization(token, verifier);
           
            if(success) {
                return new PageReference('/' + this.userId + '?noredirect=1');
            }
            else {
                this.message = client.getMessage();
                return null;
            }
        }
        else {
            client.clearToken();
            message = 'G Nation was not authorized. Missing parameter oauth_token';
            return null;
        }
    }
}