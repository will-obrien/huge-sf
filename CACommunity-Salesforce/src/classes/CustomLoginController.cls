/**
 Author:Nithin C H
 Date :9-27-2015
 Description:Class is used for Custom Login Page for community
 */
global with sharing class CustomLoginController {
    global String username{get;set;}
    global String password{get;set;}
    global CustomLoginController () {}
    global boolean isLoginFailed{get;set;}
    global PageReference forwardToCustomAuthPage() {
    
        return new PageReference( '/CustomLogin');
    }
    global PageReference login() {

        PageReference ref=Site.login(username, password, null);
        
        if(ref==null)
           {
            isLoginFailed=true;
            return null;
           }  
           else
           {
           return ref;
           
           }  
    }

}