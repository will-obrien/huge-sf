public with sharing class TwitterClient {

    public static final String hashTag = '#tm';
    private static final String tweetURL = 'https://api.twitter.com/1.1/statuses/update.json';
    private static final String tweetBlobURL = 'https://api.twitter.com/1.1/statuses/update_with_media.json';
    private static final String consumerKey = 'xvamfPHmVci3nVfMW4VAXw';
    private static final String consumerSecret = 'htjlgP0r3hc0UN971WqcJe8n3hFeWMc5fllGlbZo';
    private static final String requestTokenURL = 'https://api.twitter.com/oauth/request_token';
    private static final String authorizeURL = 'https://api.twitter.com/oauth/authorize';
    private static final String accessTokenURL = 'https://api.twitter.com/oauth/access_token';

    private OAuthSettings oAuthSettings = new OAuthSettings();
    private OAuth auth = new OAuth();
    private User user;

    public class ChatterMention {
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String userId { get; set;}
        public String userName { get; set; }
        public String twitterHandle { get; set; }
    }

    public TwitterClient() {
        
        /*Need to load the user up with the relevant fields*/               
        this.user = [SELECT Id, Twitter_isValid__c, Twitter_OAuth_Token__c, Twitter_OAuth_Token_Secret__c
                     FROM User 
                     WHERE Id = :UserInfo.getUserId()];
        
        System.debug('Creating Twitter Client');
        
        /*Set up twitter specific oAuth settings*/
        
        oAuthSettings.consumerKey = consumerKey;
        oAuthSettings.consumerSecret = consumerSecret;
        oAuthSettings.requestTokenURL = requestTokenURL;
        oAuthSettings.authorizeURL = authorizeURL;
        oAuthSettings.accessTokenURL = accessTokenURL;

        System.debug('Finished setting Twitter specific settings');
        
        /*Pull the current twitter OAuth settings of the user*/      
        oAuthSettings.isValid = this.user.Twitter_isValid__c;
        oAuthSettings.token = this.user.Twitter_OAuth_Token__c;
        oAuthSettings.tokenSecret = this.user.Twitter_OAuth_Token_Secret__c;
        
        System.debug('Finished setting user specific Twitter settings');
    }

    public OAuthSettings getOAuthSettings() {
        return this.oAuthSettings;
    }

    public String getMessage() {
        return this.auth.message;
    }
    
    public String authroize() {
        String returnURL = this.auth.newAuthorization(oAuthSettings, Page.CompleteTwitterAuth.getUrl());
        this.saveUser();
        
        return returnURL;
    }
    
    public Boolean completeAuthorization(String token, String verifier) {
        oAuthSettings.token = token;
        oAuthSettings.verifier = verifier;
        
        Map<String, String> returnParameters = new Map<String, String>();
        Boolean success = this.auth.completeAuthorization(oAuthSettings, returnParameters);
        
        if(!success) {
            this.clearToken();
        }
        else {
            this.user.Twitter_Handle__c = returnParameters.get('screen_name');      
            this.saveUser();
        }
        
        return success;
    }

    public void clearToken() {
        oAuthSettings.token = null;
        oAuthSettings.tokenSecret = null;
        oAuthSettings.isValid = false;
        
        this.saveUser();
    }

    /*@future(callout=true)
    public static void tweet(String origPost, Blob picture, String fileName) {
        try {

            OAuth auth = new OAuth();
            
            //Need to do this instead of relying on the instance variables
            //as this method can be called from a trigger which must be
            //async and thus static
            User u = [SELECT Id, Twitter_isValid__c, Twitter_OAuth_Token__c, Twitter_OAuth_Token_Secret__c
                     FROM User 
                     WHERE Id = :UserInfo.getUserId()];
        
            OAuthSettings settings = new OAuthSettings();
            settings.consumerKey = consumerKey;
            settings.consumerSecret = consumerSecret;
            settings.requestTokenURL = requestTokenURL;
            settings.authorizeURL = authorizeURL;
            settings.accessTokenURL = accessTokenURL;
            settings.isValid = u.Twitter_isValid__c;
            settings.token = u.Twitter_OAuth_Token__c;
            settings.tokenSecret = u.Twitter_OAuth_Token_Secret__c;         

            String boundry = 'R50hrfBj5JYyfR3vF3wR96GPCC9Fd2q2pVMERvEaOE3D8LZTgLLbRpNwXek3';

            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(tweetBlobURL);
            req.setHeader('Content-Type','multipart/form-data; boundry=' + boundry);
            
            origPost = TwitterClient.replaceChatterMetions(origPost);
            List<String> posts = TwitterClient.divideLargePosts(origPost);
            
            for(String post : posts) {
                //Build Multipart tweet         
                String body = '--' + boundry + '\r\n';
                body+= 'Content-Disposition: form-data; name="status"';
                body+='\r\r';
                body+= EncodingUtil.urlEncode(post, 'UTF-8');
                body+= '\r--' + boundry + '\r'; 
                body+= 'Content-Type: application/octet-stream\r';
                body+= 'Content-Transfer-Encoding: Base64\r';
                body+= 'Content-Disposition: form-data; name="media[]"; filename="' + fileName + '"\r';
                body+= EncodingUtil.base64Encode(picture);
                body+= '\r--' + boundry + '--';
                
                req.setBody(body);      
                System.debug('Request Body: ' + body);
                                        
                auth.sign(req, settings);
                
                System.debug('Sending request...');
                HttpResponse res = h.send(req);
                System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');
                System.debug('Received Twitter JSON: ' + res.getBody());
            }
    
        }
        catch(Exception e) {
            System.debug(e);
        }
    }
*/

    @future(callout=true)
    public static void tweet(String origPost) {
        try {

            OAuth auth = new OAuth();
            
            /*Need to do this instead of relying on the instance variables
            as this method can be called from a trigger which must be
            async and thus static*/
            User u = [SELECT Id, Twitter_isValid__c, Twitter_OAuth_Token__c, Twitter_OAuth_Token_Secret__c
                     FROM User 
                     WHERE Id = :UserInfo.getUserId()];
        
            OAuthSettings settings = new OAuthSettings();
            settings.consumerKey = consumerKey;
            settings.consumerSecret = consumerSecret;
            settings.requestTokenURL = requestTokenURL;
            settings.authorizeURL = authorizeURL;
            settings.accessTokenURL = accessTokenURL;
            settings.isValid = u.Twitter_isValid__c;
            settings.token = u.Twitter_OAuth_Token__c;
            settings.tokenSecret = u.Twitter_OAuth_Token_Secret__c;         


            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(tweetURL);
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            
            origPost = TwitterClient.replaceChatterMetions(origPost);
            List<String> posts = TwitterClient.divideLargePosts(origPost);
            
            for(String post : posts) {
                /*Build Tweet*/
                String postParams = 'status=';
                postParams += EncodingUtil.urlEncode(post, 'UTF-8');
                postParams += '&trim_user=true';
                postParams += '&include_entities=true';
            
                req.setBody(postParams);    
                auth.sign(req, settings);
                
                System.debug('Sending request...');
                HttpResponse res = h.send(req);
                System.debug('Received response ('+res.getStatusCode()+' '+res.getStatus()+')');
                System.debug('Received Twitter JSON: ' + res.getBody());
            }
    
        }
        catch(Exception e) {
            System.debug(e);
        }
    }
    
    private void saveUser() {
        this.user.Twitter_isValid__c = oAuthSettings.isValid;
        this.user.Twitter_OAuth_Token__c = oAuthSettings.token;
        this.user.Twitter_OAuth_Token_Secret__c = oAuthSettings.tokenSecret;
        
        update this.user;
    }
    
    /*Replaces Chatter mentions with twitter mentions.  
      If the twitter handle is not set, then it removes the
      Chatter reference completely.
    */
    private static String replaceChatterMetions(String origPost) {
        
        if(!origPost.contains('@')) {
            return origPost;
        }
        
        /*Unfortunately there's no clean way to get metions in
          a post out, especially since the API doesn't provide
          the mention name in between the square brackets.  Need
          to split up by words and then search for any word starting
          with an @, assume it's their first name and then assume
          the following word is their last name.  Very hacky!
        */
            
        List<ChatterMention> mentions = new List<ChatterMention>();
        List<String> words = origPost.split(' ');
        Boolean haveFirst = false;
        ChatterMention mention;
        
        for(String word : words) {
            
            if(haveFirst) {
                mention.lastName = word;
                mentions.add(mention);
                haveFirst = false;
            }
            
            if(word.startsWith('@')) {
                mention = new ChatterMention();
                mention.firstName = word.substring(1);
                haveFirst = true;
            }           
        }

        if(mentions.size()<1) {
            System.debug('ERROR: We know there is an @ character, but we have no mentions parsed');
            return origPost.replace('@', '');
        }
        
        String newPost = origPost;
                
        for(ChatterMention cm : mentions) {
            List<User> users = [SELECT Id, FirstName, LastName, Twitter_Handle__c
                                FROM User 
                                WHERE FirstName = :cm.firstName
                                AND LastName LIKE :cm.lastName + '%'];
            
            //Either didn't find the user or found multiples, so remove the @ character so we don't get unintended results on twitter             
            if(users.size()!=1) {
                newPost = origPost.replace('@' + cm.firstName + ' ' + cm.lastName, cm.firstName + ' ' + cm.lastName);
                System.debug('Could not find unique user for mention [@' + cm.firstName + ' ' + cm.lastName);
                continue;
            }
            
            User foundUser = users.get(0);
            cm.twitterHandle = foundUser.Twitter_Handle__c;
            cm.userName = foundUser.FirstName + ' ' + foundUser.LastName;
            cm.userId = foundUser.Id;
            
            if(cm.twitterHandle!=null) {
                cm.twitterHandle = cm.twitterHandle.trim();
                if(!cm.twitterHandle.startsWith('@')) {
                    cm.twitterHandle = '@' + cm.twitterHandle;
                }
            }
                        
            System.debug('Found User Id [' + cm.userId + '] for mention [@' + cm.firstName + ' ' + cm.lastName);

            //We have an invalid twitter handle.  Remove the @ to avoid unwanted behaviour with twitter
            if(cm.twitterHandle==null || cm.twitterHandle.length()<2) {
                newPost = newPost.replace('@' + cm.firstName + ' ' + cm.lastName, cm.firstName + ' ' + cm.lastName);
                System.debug('Found invalid twitter handle [' + cm.twitterHandle + '] for mention [@' + cm.firstName + ' ' + cm.lastName);
                continue;
            }
            
            //If we're here, we have a valid twitter handle and we should be able to swap the chatter mention
            newPost = newPost.replace('@' + cm.userName, cm.twitterHandle);
        }
        
        
        return newPost;
    }
    
    /*Divides posts that are larger than 140 characters into
      several tweets and prepends (x/y) to each tweet
    */
    private static List<String> divideLargePosts(String origPost) {     
        List<String> posts = new List<String>();
        
        if(origPost.length() <= 140) {
            posts.add(origPost);
        }
        else {
            List<String> prePosts = new List<String>();
                                    
            //split up all the words 
            List<String> words = origPost.split(' ');
            String prePost = '';
            
            //Build up each post, but leave room for the "(1/3)""           
            for(String word : words) {
                if((prePost + word).length() > 134) {
                    prePosts.add(prePost.trim());
                    prePost = '';
                }
                
                prePost += ' ' + word;
            }
            
            //Add the last post
            prePosts.add(prePost);
            
            //Add the counts
            Integer i = 1;
            Integer total = prePosts.size();
            
            System.debug('Generating ' + String.valueOf(total) + 'tweets');
            
            for(String post : prePosts) {
                String finalPost = '(' + String.valueOf(i) + '/' + String.valueOf(total) + ') ' + post;
                posts.add(finalPost);
                i++;
            }
        }       
                
        return posts;
    }   
}