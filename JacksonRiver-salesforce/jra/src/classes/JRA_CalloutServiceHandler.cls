public class JRA_CalloutServiceHandler {
/*
PNC June 2015
Class to handle callouts to JRA API to get access token and zipcode data
Only supports callout for one zip code at a time, so when invokved from batch, so
need to keep callouts below current limits (100 callouts, 120 seconds)
*/

public String sErrorMessage;
public String sAccess;
public String sFinalResponse;
private String sEndpoint;
public Boolean bUpdateSetting;
private jrsbd__JRA_Advocacy_Endpoint_Settings__c ServiceSettings;

public JRA_CalloutServiceHandler() {
//Default to Sandbox
sEndpoint = 'Sandbox';

//Determine current endpoint from custom setting
if (JR_Advocacy_Settings__c.getvalues('APIEndpoint') != NULL) {
    if (String.IsEmpty(JR_Advocacy_Settings__c.getvalues('APIEndpoint').String_Value__c) == FALSE) {
        sEndpoint = JR_Advocacy_Settings__c.getvalues('APIEndpoint').String_Value__c;
    }
}

//Get endpoint details (URL, Creds) from endpoint
ServiceSettings =  jrsbd__JRA_Advocacy_Endpoint_Settings__c.getvalues(sEndpoint);
sEndpoint = ServiceSettings.jrsbd__Endpoint__c;
}

/*
This stores a new access token in the endpoint custom setting, so we don't need to retrieve until expired
Because we can't make DML calls after callouts, we provide this method that can be called at end of process along with other DML
*/
public void updateToken() {
    ServiceSettings.jrsbd__Current_Access_Token__c = sAccess;
    ServiceSettings.jrsbd__Access_Expiration_Date_Time__c = system.now().addMinutes(59);
    update ServiceSettings;
}

//Access tokens last 60 mins, so check if current one has expired
public void getAccessToken() {

if (ServiceSettings.jrsbd__Current_Access_Token__c != NULL) {
    if (ServiceSettings.jrsbd__Access_Expiration_Date_Time__c > system.now() ) {
        sAccess = ServiceSettings.jrsbd__Current_Access_Token__c;
    }
}
//If no token, expired, get a new one
if (sAccess == NULL) {
    retrieveNewToken();
}


}

//Get new accesst oken using creds
private void retrieveNewToken() {

HttpRequest req = new HttpRequest();

String s1 = sendpoint + '/oauth/access-token';
//Set body of callout to be creds and grant type
String s2 = 'client_id=' + ServiceSettings.jrsbd__Client_Id__c;
s2 += '&client_secret=' + ServiceSettings.jrsbd__Client_Secret__c;
s2 += '&grant_type=client_credentials';

req.setEndpoint(s1);
                
req.setMethod('POST');
//Note - we have to set Header to Form Encoded to get token, not JSON 
req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
req.setBody(s2);

String sFinalResponse;
Http http = new Http();
     HTTPResponse res = http.send(req);
     sFinalResponse = res.getBody();
    
    if (res.getStatusCode() == 200) {
        //Prase returned JSON
        retrieveAccessCode(sFinalResponse);
        //mark setting as needing updating when final DML calls are made
        bUpdateSetting = TRUE;
    }
    else {//try again in case of failure
        res = http.send(req);
        sFinalResponse = res.getBody();
            if (res.getStatusCode() == 200) {
                retrieveAccessCode(sFinalResponse);
                bUpdateSetting = TRUE;
            }
            else {
                sErrorMessage = res.getStatus();
                
            }
        
    }

}

private void retrieveAccessCode(String sFinalResponse) {
system.debug(sFinalResponse);
//Returned JSON is simple key/value response so we can just use basic deserialize process
Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(sFinalResponse);
//system.debug(m);
sAccess = (string)m.get('access_token');
}


public Boolean retrieveData(String sZipCode) {
//First check we have a token
if (sAccess == NULL) {
    getAccessToken();
}
//Assume success!
Boolean bSuccess = FALSE;

    HttpRequest req = new HttpRequest();
         //Set final endpint from URL in setting
         String sFinalEndpoint = sEndPoint + '/targets/legislators?zip=' + sZipCode;
         req.setEndpoint(sFinalEndpoint);
         req.setMethod('GET');
         req.setTimeout(20000);
         //Add access token to header
         String authorizationHeader = 'Bearer ' + sAccess;
         req.setHeader('Authorization', authorizationHeader);
         //This time, it is a JSON response
         req.setHeader('Content-Type', 'application/json');
              
         Http http = new Http();
try {    
     HTTPResponse res = http.send(req);
         if (res.getstatuscode() == 200) {
             sFinalResponse = res.getBody();
             //system.debug(sFinalResponse);
             bSuccess = TRUE;
          }
          else if (res.getstatuscode() == 401) {//bad token
              sErrorMessage = 'Bad Token';
              bSuccess = FALSE;
          }
          else if (res.getStatusCode() == 500) {
              sErrorMessage = 'Bad Response';
              bSuccess = FALSE;
          }
            
}
Catch (Exception Ex) {     
    //system.debug(sErrorMessage);
    //Error will be handled by calling class
    sErrorMessage = ex.getmessage();     
} 
return bSuccess;
}


}