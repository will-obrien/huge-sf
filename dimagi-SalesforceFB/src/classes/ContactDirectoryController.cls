public class ContactDirectoryController{
    
    private String OAUTH_CALLBACK_URL='https://dimagi--dsandbox--c.cs20.visual.force.com/apex/ContactDirectory';
    //private String OAUTH_CALLBACK_URL='http://dimagi.force.com/ContactDirectory';
    private String clientId='';
    private String clientSecret='';
    private string domainName='';
    
    public String AUTH_URL = 'https://accounts.google.com/o/oauth2/auth';
    public String ACCESS_TOKEN_URL = 'https://accounts.google.com/o/oauth2/token';
    public Boolean isAuthenticated {get; set;}
    public string oauth_token {get;set;}
    
    public string EmpSearchName{get;set;}
    public string showMessage{get;set;}
    
    public string ContractSearchName{get;set;}
    
    
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
                 
            }
            return authPage;
        
    }
    
    public void SearchEmp(){
         string search='%'+EmpSearchName+'%';
         EmpList=[select id,Name,Email_Address__c,Skype_ID__c,Direct_Manager__c,Direct_Manager_Lookup__c,Direct_Manager_Lookup__r.Name,
                 Business_Unit__c,Sub_Unit__c,Entity__c,Personal_Phone_Number__c,Title__c,
                 Languages_Spoken__c,Language_1_Proficiency__c,
                 Language_Spoken_2__c,Language_2_Proficiency__c,
                 Language_Spoken_3__c,Language_3_Proficiency__c,
                 Language_Spoken_4__c,Language_4_Proficiency__c,
                 Language_Spoken_5__c,Language_5_Proficiency__c,
                 Language_Spoken_6__c,Language_6_Proficiency__c
                 from SFDC_Employee__c where Employee_Status__c='Active' and Name like :search];
    
    }
    public void SearchContract(){
         string search='%'+ContractSearchName+'%';
         ContractList=[select id,Prime_Contracting_Business_Unit__c,Name,Prime_Contracting_Business_Unit__r.Name,
                      Safety_Contact__c,Contract_End_Date__c
                      from DContract__c where Status__c in('Draft','Active') and Name like :search];
    
    }
    
    
    public ContactDirectoryController(){
        
        List<PRO_OAuth_Settings__c> googleSettings=PRO_OAuth_Settings__c.getALL().values();
        if(googleSettings!=null && googleSettings.size()>0){
            clientId=googleSettings[0].ClientID__c;
            clientSecret=googleSettings[0].ClientSecret__c;
            domainName=googleSettings[0].Domain_Name__c;
            OAUTH_CALLBACK_URL=googleSettings[0].Contact_Directory_Callback_URL__C;
        }
        isAuthenticated = false;
        
         EmpList=[select id,Name,Email_Address__c,Skype_ID__c,Direct_Manager_Lookup__c,Direct_Manager_Lookup__r.Name,
                 Business_Unit__c,Sub_Unit__c,Entity__c,Personal_Phone_Number__c,Title__c,
                 Languages_Spoken__c,Language_1_Proficiency__c,
                 Language_Spoken_2__c,Language_2_Proficiency__c,
                 Language_Spoken_3__c,Language_3_Proficiency__c,
                 Language_Spoken_4__c,Language_4_Proficiency__c,
                 Language_Spoken_5__c,Language_5_Proficiency__c,
                 Language_Spoken_6__c,Language_6_Proficiency__c
                 from SFDC_Employee__c where Employee_Status__c='Active'];
                 
        ContractList=[select id,Prime_Contracting_Business_Unit__c,Name,Prime_Contracting_Business_Unit__r.Name,
                      Safety_Contact__c,Contract_End_Date__c
                      from DContract__c where Status__c in('Draft','Active')];
          if(ContractList.size() > 0)
          {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,' If any information is incorrect please contact people-ops@dimagi.com'));
          }
                      
    }
    public List<DContract__c> ContractList{
        get;set;
    }    
    public List<SFDC_Employee__c> EmpList{
        get;set;
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

}