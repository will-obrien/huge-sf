/*
 Author:Rajesh Tallapaneni
 This is REST Webservice callout which will be uesfull for Priavte Webservices where ConsumerKey and sercert can be passed
 and get the responce.  
*/
public with sharing class REST_AuthenticationDetail_Callout{
    //private final static String ENP_POINT_URL = 'https://login.salesforce.com/services/oauth2/token';
    private final static String ENP_POINT_URL = 'https://ap2.salesforce.com/services/apexrest/rajesh208/rajesh/getAccounts/Session';
    private final static String REQUEST_BODY = 'grant_type=password&client_id={0}&client_secret={1}&username={2}&password={3}';
    private final static String USERNAME = 'sfdcwork1@gmail.com';
    private final static String PASSWORD = 'PASSWORD NEEDS TO BE PROVIDED WITH SECURITY TOKEN';
    private final static String CONSUMER_KEY = '3MVG9Y6d_Btp4xp5aiRm6mpHQS2NqW.yQNQ5Xvndr0.mB0Y2f7q1.7CPUfJ5coDBzUE9s_mX3JoWrSX4lV8_o';
    private final static String CONSUMER_SECRET = '7876310128633254041';
    
    /*To generate Access token Method*/
    public static void getAccessToken(){
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod('POST');          
            Blob headerValue = Blob.valueOf(USERNAME + ':' + PASSWORD);
            String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader); 
            req.setBody(String.format(REQUEST_BODY ,new string[]{CONSUMER_KEY,CONSUMER_SECRET,
                                                                 USERNAME,PASSWORD}));
            req.setTimeout(20000);
            Http http = new Http();
            HttpResponse res = http.send(req);
            system.debug('response is@@'+res);         
        }catch(CallOutException ce){
            throw ce;
        }
    }
    
   
}