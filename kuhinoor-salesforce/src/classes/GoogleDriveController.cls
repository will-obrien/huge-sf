public class GoogleDriveController
{
    //Fetched from URL
    // private String code ;
    public blob file { get; set; }
   // public String type{get; set;}
    public String filetype{get;set;}
    public  String filename{get; set;}
    private String accesstoken ;
    public   blob image{get;set;} 
    
    private String code ;
    private string key = '942778399147-ikpkogki7rghr6scotte71pkbfhutpd5.apps.googleusercontent.com' ;
    private string secret = 'jxRHtFYXcLLRC6yFVYnrYIdk';
    private string redirect_uri = 'https://lightingprefix.ap1.visual.force.com/apex/GoogleDrivePage' ;
    Public String  myresponse{get;set;}
    Public String resp{get;set;}
   // https://lightingprefix.ap1.visual.force.com/apex/GoogleDrivePage
    
    public GoogleDriveController()
    {
        code = ApexPages.currentPage().getParameters().get('code') ;
        //Get the access token once we have code
        if(code != '' && code != null)
        {
            AccessToken();
        }
    }
    
    public PageReference DriveAuth()
    {
        //Authenticating
        PageReference pg = new PageReference(GoogleDriveAuthUri (key , redirect_uri)) ;
        return pg ;
    }
    
    public String GoogleDriveAuthUri(String Clientkey,String redirect_uri)
    {
        String key = EncodingUtil.urlEncode(Clientkey,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = 'https://accounts.google.com/o/oauth2/auth?'+
        'client_id='+key+
        '&response_type=code'+
        '&scope=https://www.googleapis.com/auth/drive'+
        '&redirect_uri='+uri+
        '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&'+
        '&login_hint=kuhinoor.alam@ibirdsservices.com&'+
        'access_type=offline';
        return authuri;
    }
    
    
    public void AccessToken()
    {
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+code+'&client_id='+key+'&client_secret='+secret+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);

        Http h = new Http();
     
        HttpResponse res = h.send(req);
        resp = res.getBody();
        
        System.debug(' You can parse the response to get the access token ::: ' + resp);
   }
   
   //------------upload files-------------------
     public  void UploadFile()
    {
  
    }
   
   public  void accessFiles(){
           
   } 
}