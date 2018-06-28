/**
 Author:Nithin C H
 Date :9-27-2015
 Description:Class is used for CustomForgot Page for Community.
 */
public with sharing class CustomForgotPasswordController {
    public String username {get; set;}   
    public Boolean DisplayError{get; set;}    
    public CustomForgotPasswordController() {}
    
    public PageReference forgotPassword() {
    if(username==null||username==''){
        DisplayError=true;
         return null;
    }
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.CustomForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if (success) {              
            return pr;
        }
        return null;
    }
}