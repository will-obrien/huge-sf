@RestResource(urlMapping='/auth/*')
 
global with sharing class auth {

    @HttpPost
    global static authResponse echoMyType(String username, String password) {
        
        authResponse ar = new authResponse();
       
        system.debug('* * * Login ...'+  username + ':' + password);   
        
        PageReference pr = Site.login(username, password, null);     
        
        system.debug('* * * PageReference ...'+  pr);
        
        //ar.resp = pr.getUrl();
        
        return ar;
    }

    global class authResponse {

        global String resp { get; set; }      

    }
    
}