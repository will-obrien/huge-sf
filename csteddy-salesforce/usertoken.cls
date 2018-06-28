public class usertoken {

public static UserTokens__c u;
public static String name; 
public static Boolean isAuthorized;    
public static String token;   
public static String code;
public static String nonce;   
public static String token_type;  
public static String expires_in;  
public static String refresh_token;   
public static String service;    
public static String MYOB_File_GUID;

// Class initialisation block (executed on first class variable reference)
static {

// If there is an existing UserToken custom object then populate static variables from it

try {
        u = [SELECT name,isAuthorized__c, token__c, nonce__c, refresh_token__c, Service_Name__c, MYOB_File_GUID__c FROM UserTokens__c WHERE name = :myob.service];
        name = u.name;
        isAuthorized = u.isAuthorized__c;
        token = u.token__c;
        nonce = u.nonce__c;
        refresh_token = u.refresh_token__c;
        service = u.Service_Name__c;
        MYOB_File_GUID = u.MYOB_File_GUID__c;
     
        
        
            }
    catch (QueryException e) {
    // Create new place marker usertoken object
    name = myob.service;
    service = myob.service;
    isAuthorized = false; 
    nonce = '';
    u = new UserTokens__c(Name=myob.service,Service_Name__c = myob.service,isAuthorized__c = false,nonce__c = '');
}
}

public static void write() {
u.token__c = token;
u.isAuthorized__c = isAuthorized;
u.refresh_token__c = refresh_token;
u.MYOB_File_GUID__c =  MYOB_File_GUID;
u.token_type__c = token_type;  
u.expires_in__c = expires_in;       
u.nonce__c = nonce;
//        service = u.Service_Name__c;
try {
    upsert u Service_Name__c;
    }
catch (CalloutException e) {
    system.debug('Not possible to write usertoken cache to storage at this time');
    }
}
@future
public static void deferredWrite() {
u.token__c = token;
u.isAuthorized__c = isAuthorized;
u.refresh_token__c = refresh_token;
u.MYOB_File_GUID__c =  MYOB_File_GUID;
u.token_type__c = token_type;  
u.expires_in__c = expires_in;       
u.nonce__c = nonce;
upsert u Service_Name__c;
}
}
