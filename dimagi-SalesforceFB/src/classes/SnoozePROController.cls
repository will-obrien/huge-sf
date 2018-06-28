public class SnoozePROController{
    
    private String OAUTH_CALLBACK_URL='';
    private String clientId='';
    private String clientSecret='';
    private string domainName='';
    
    public String AUTH_URL = 'https://accounts.google.com/o/oauth2/auth';
    public String ACCESS_TOKEN_URL = 'https://accounts.google.com/o/oauth2/token';
    public Boolean isAuthenticated {get; set;}
    public string oauth_token {get;set;}
    
    public string PROMessage{
        get;set;
    }
    
    public string contractId{
        get;set;
    }
    public string noOfDaysStr{
        get;set;
    }
    public string ownerId{
        get;set;
    }
    public SnoozePROController(){
        if(ApexPages.currentPage().getParameters().get('id')!=null){
            contractId=ApexPages.currentPage().getParameters().get('id');
        }
        if(ApexPages.currentPage().getParameters().get('NoOfDays')!=null){
            noOfDaysStr=ApexPages.currentPage().getParameters().get('NoOfDays');
        }
        if(ApexPages.currentPage().getParameters().get('OwnerId')!=null){
            ownerId=ApexPages.currentPage().getParameters().get('OwnerId');
        }
            
        List<PRO_OAuth_Settings__c> googleSettings=PRO_OAuth_Settings__c.getALL().values();
        if(googleSettings!=null && googleSettings.size()>0){
            clientId=googleSettings[0].ClientID__c;
            clientSecret=googleSettings[0].ClientSecret__c;
            domainName=googleSettings[0].Domain_Name__c;
            OAUTH_CALLBACK_URL=googleSettings[0].Snooze_PRO_Callback_URL__C;
        }
        isAuthenticated = false;
    }
     public void initAction() {
           
           oauth_token = ApexPages.currentPage().getParameters().get('oauth_token');
           String oauth_verifier = ApexPages.currentPage().getParameters().get('oauth_verifier');
           string oauth_code = ApexPages.currentPage().getParameters().get('code');
           
           System.debug('Google Code: '+oauth_code);
           if(oauth_code!=null){
               oauth_token=getFromJSON(getAuthorizedReqToken(oauth_code),'access_token');
           }
           
           if(oauth_token!=null){
               isAuthenticated =true;
               SnoozePRO();
           }
    }
    
    public PageReference authenticate() {
            PageReference authPage=null;
       
            oauth_token = ApexPages.currentPage().getParameters().get('oauth_token');
            String oauth_verifier = ApexPages.currentPage().getParameters().get('oauth_verifier');
            string oauth_code = ApexPages.currentPage().getParameters().get('code');
    
            if (oauth_code != null){
               oauth_token=getFromJSON(getAuthorizedReqToken(oauth_code),'access_token');
               if(oauth_token!=null){
                   isAuthenticated =true;
                   
               }
            }
            else{
                
                 String authURL = getUnauthorizedReqToken();
                 authPage=new PageReference(authURL);
                 authPage.setRedirect(false);
                 SnoozePRO();
            }
            return authPage;
        
    }
    public String getUnauthorizedReqToken(){
         
          String vf_url=this.OAUTH_CALLBACK_URL;
          String state = getRandomNonce(); //Random String
          String body='client_id='+this.clientId+'&redirect_uri='+this.OAUTH_CALLBACK_URL+'&state='+state;
          
          String retUrl=this.AUTH_URL+'?'+body+'&response_type=code&scope=profile+email';
          
          if(domainName!='gmail.com'){
              retUrl=retUrl+'&hd='+domainName;
          }
          
          //String retUrl=this.AUTH_URL+'?hd='+domainName+'&'+body+'&response_type=code&scope=profile+email';
          return retUrl;
    }
    public static String getRandomNonce(){
           String allChars='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
           String nonce='';
           for(integer cnt=0; cnt<=9;cnt++)   {
               Integer i = 1+Math.Round(700.0*Math.random()/26);
               if (i<=26)
               {
                  i--;
                  String newStr=allChars.substring(i,i+1);
                  nonce=nonce+newStr;
              }else{
                cnt--;
              }
          }
          return nonce;
    }
    
    public String getAuthorizedReqToken(String code){
         
            String body='client_id='+this.clientId+'&redirect_uri='+this.OAUTH_CALLBACK_URL+'&client_secret='+this.clientSecret+'&code='+code+'&grant_type=authorization_code';
             
            String tokenResponse = basicAuthCallout(this.ACCESS_TOKEN_URL,'',body,'POST');
             
            System.debug('=========================== RESPONSE:'+tokenResponse);
             
            String authReqToken = tokenResponse;
            return authReqToken;
    }
   
    public String basicAuthCallout(String endPoint,String header, String body,String method){
            HttpRequest req = new HttpRequest();
          
            req.setEndpoint(endPoint);
            req.setMethod(method);
            if(method=='POST'){
                 req.setBody(body);
            }
            Http http = new Http();
            System.debug('=========== REQ BODY:'+endPoint);
            HTTPResponse res = http.send(req);
            return res.getBody();
     }
     public string getFromJSON(string response,string fieldName){
        JSONParser parser = JSON.createParser(response);
        
        string accessToken='';
        
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == fieldName)) {
                parser.nextToken();
                accessToken= parser.getText();
            }
        }
        return accessToken;
     }
    
    
    public void SnoozePRO(){
        try{
           
            
            if(contractId!=null){
                if(noOfDaysStr!=null && noOfDaysStr!=''){
                    integer noOfDays=Integer.ValueOf(noOfDaysStr);
                    PROEmailContractSnoozeHelper helper=new PROEmailContractSnoozeHelper();
                    helper.SnoozeContract(contractId,noOfDays);
                    PROMessage='Your PRO snoozed successfully.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your PRO snoozed successfully.'));   
                }
            }
            else if(ownerId!=null){
                if(noOfDaysStr!=null && noOfDaysStr!=''){
                    integer noOfDays=Integer.ValueOf(noOfDaysStr);
                    PROEmailContractSnoozeHelper helper=new PROEmailContractSnoozeHelper();
                    helper.SnoozeContractByOwnerId(ownerId,noOfDays);
                    PROMessage='Your all PRO are snoozed successfully.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your all PRO are snoozed successfully.'));   
                }
            
            }
            
            
        }
        catch(Exception ex){
        
        }
        
    }
    
}