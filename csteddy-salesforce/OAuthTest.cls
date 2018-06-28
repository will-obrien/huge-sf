@istest (seeAllData=true)
public class OAuthTest {

public static testmethod void testOAuthSettings() {

String scope = myob.scope;

UserTokens__c userToken = new UserTokens__c(Name='MYOB',Service_Name__c = 'MYOB',isAuthorized__c = false,nonce__c = null);
   upsert userToken Service_Name__c;

   String authURL = OAuth.getUnauthorizedReqToken();
   String message = OAuthAuthentication.UpdateOAuthCodeUser('dummy code', userToken.nonce__c);
   
    token.refresh();
}
}
