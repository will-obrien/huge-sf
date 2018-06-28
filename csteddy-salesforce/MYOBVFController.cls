public class MYOBVFController {

public String service { get; set; }
//Services Picklist
String message=null;
private static List<selectOption> VIEW_SERVICES = new SelectOption[]{
    new SelectOption('MYOB','MYOB')
    };
public List<SelectOption> getServiceNames(){
return VIEW_SERVICES;
}
public String getMessage(){
return message;
}

public PageReference finalAuth(){
/*
The VF page with the custom controller of this class (MYOBVFController) will be directed
here when redirected as part of the OAuth 2 flow from MYOB by the action="{!finalAuth}" in the VF page.
The URL parameters will have ?code=xxxxxx and optionally state=yyyyyy
*/

    
    String oauth_code = ApexPages.currentPage().getParameters().get('code');
    String state = ApexPages.currentPage().getParameters().get('state');
    if (oauth_code != null) {
// Insert the provided Oauth Code in Salesforce
    message = OAuthAuthentication.UpdateOAuthCodeUser(oauth_code, state);
// Find Available MYOB Files

        usertoken.MYOB_File_GUID = null;
        HTTPRequest req = MYOBrequest.header('v2','GET','','');
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        if (!Test.isRunningTest()) {
            res  = http.send(req);
        }
        else
        {
        
        res.setBody('[{  "Id": "073def5d-d1cf-4b03-9828-e440aadbbfe0", "Name": "Clearwater Pty Ltd" },'+
        '{  "Id": "099def5d-d1cf-4b03-9828-e440aadbbfe0", "Name": "Greenworx Pty Ltd" }]');
        }
    
    if (res.getStatusCode() == 200 || Test.isRunningTest()) {
        
        String MYOBfileGuid = '';
        String JSONMYOBfiles = res.getBody();
        System.debug(JSONMYOBfiles);

         List<MYOBfile> files = 
          (List<MYOBfile>)JSON.deserialize(JSONMYOBfiles, List<MYOBfile>.class);
        
        for (MYOBfile file : files) {
            if(file.Name == myob.FileName) MYOBfileGuid =file.Id;
            }

 
        system.debug('Myob File Name ' + myob.FileName);
        system.debug('Myob Guid ' + MYOBfileGuid);
        usertoken.MYOB_File_GUID = MYOBfileGuid;
        usertoken.Write();
}   
    }   
    return null;
}
public PageReference doAuthorization(){
//This is the first leg of a 3 Legged authorization
//It requests an authorisation code by directing to the MYOB OAuth endpoint
//with URL parameters


PageReference authPage;
 

// Invoke method to build application specific URL to get Authorization code (OAuth leg 1)
// Pass usertoken Sobject to allow randomly generated state variable/nonce to be saved for subsequent calls
// ?client_id=aaa&redirect_uri=http://xxx.salesforce.com/apex/xxxx&response_type=code [&scope=bbbbbb&state=xxxxx]
   String authURL = OAuth.getUnauthorizedReqToken();
   authPage=new PageReference(authURL);
// Redirect SF user to application page
    authPage.setRedirect(true);

return authPage;
}
}
