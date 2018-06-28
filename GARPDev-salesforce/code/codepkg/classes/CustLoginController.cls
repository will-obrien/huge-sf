global with sharing class CustLoginController {
    global String username {get; set;}
    global String password {get; set;}
    global CustLoginController () {}
    global PageReference login() {
        
        //username = 'alberto.garciaindv13@garp.com';
        //password = 'sfdc2013AG';
        
        username =  ApexPages.currentPage().getParameters().get('username');
        password = ApexPages.currentPage().getParameters().get('password');
        
        return Site.login(username, password, null); 
    } 
}