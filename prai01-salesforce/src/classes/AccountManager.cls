@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager{
    
    @HttpGet
    global static Account getAccount(){
         RestRequest request = RestContext.request;
        //grab the caseId from the end of the URL
        /*String accountId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        */
        String accountId = request.requestURI.substringBetween('Accounts/', '/contacts');
        
        Account result = [SELECT Id,Name,(SELECT Id, Name FROM contacts)
                       FROM Account
                       WHERE Id = :accountId];
        return result;        
    }
}