public class MYOB {
public static String service;
public static String Scope;
public static String APIendpoint;
public static String AccessTokenURL;
public static String AuthorizationURL;
public static String CallBackURL;
public static String ConsumerKey;
public static String RefreshTokenURL;
public static String ConsumerSecret;
public static Boolean StateParameterRequired;
public static String Username, Password;
public static String FileName;

// Class initialisation block (executed on first class variable reference
static {
// Get OAuth settings from Salesforce Custom Settings object
List <OAuth__c> o = OAuth__c.getall().values();

for (OAuth__c s:o) {
 if (s.Name == 'MYOB') {
   service = s.Name;
   APIendpoint = s.API_endpoint__c;
   AccessTokenURL = s.Access_Token_URL__c;
   AuthorizationURL = s.Authorization_URL__c;
   CallBackURL = s.CallBack_URL__c;
   RefreshTokenURL = s.Refresh_Token_URL__c;
   Scope = s.Scope__c;
   ConsumerKey = s.Consumer_Key__c;
   ConsumerSecret = s.Consumer_Secret__c;
   StateParameterRequired = s.State_parameter_required__c;
   Username = s.username__c;
   Password = s.password__c;
   FileName = s.MYOB_File_Name__c;
   
   }
  }
  
}   
}
