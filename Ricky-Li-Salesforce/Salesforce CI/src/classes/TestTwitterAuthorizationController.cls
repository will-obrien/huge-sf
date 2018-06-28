@isTest
private class TestTwitterAuthorizationController {
    
    //This tests false tokens
    public static testMethod void testClearPartialTwitterAuthorizationController() {
     Test.StartTest();   
        User u = new User();
        u.Twitter_isValid__c = false; 
        u.Twitter_OAuth_Token__c = 'a';
        u.Twitter_OAuth_Token_Secret__c = 'a';
        
        ApexPages.StandardController sc = new ApexPages.StandardController(u);
        TwitterAuthorizationController controller = new TwitterAuthorizationController(sc);
        controller.authorize();     
        controller.clearTokens();
        controller.completeAuthorization();
     Test.StopTest();   
    }
    
    //This tests clearAuth
    public static testMethod void testClearTwitterAuthorizationController() {
      Test.StartTest();  
        User u = new User();
        u.Twitter_isValid__c = true; 
        u.Twitter_OAuth_Token__c = 'a';
        u.Twitter_OAuth_Token_Secret__c = 'a';
        u.username = 'pqr@pqr.com';
        u.LastName = 'Test';
        u.Email = 'p@p.com';
        u.alias = 'p';
        u.TimeZoneSidKey='GMT';
        u.LocaleSidKey='en_CA';
        u.ProfileId='00e30000001nP3JAAU';
        u.EmailEncodingKey='ISO-8859-1';
        u.LanguageLocaleKey='en_US';
        u.ManagerId = '00530000005Y2aS';
      System.runAs(u){
        ApexPages.StandardController sc = new ApexPages.StandardController(u);
        TwitterAuthorizationController controller = new TwitterAuthorizationController(sc);
        controller.authorize();     
        controller.clearTokens();
        controller.completeAuthorization();
      }    
     Test.StopTest();   
    }
    
    //This tests if the user is not authorized
    public static testMethod void testAuthorizeTwitterAuthorizationController() {
     Test.StartTest();   
        User u = new User();
        u.Twitter_isValid__c = false; 
        u.Twitter_OAuth_Token__c = '';
        u.Twitter_OAuth_Token_Secret__c = '';
        u.username = 'umo@umo.com';
        u.LastName = 'T';
        u.Email = 'pq@pqe.com';
        u.alias = 'pq';
        u.TimeZoneSidKey='GMT';
        u.LocaleSidKey='en_CA';
        u.ProfileId='00e30000001nP3JAAU';
        u.EmailEncodingKey='ISO-8859-1';
        u.LanguageLocaleKey='en_US';
        u.ManagerId = '00530000005Y2aS';
      System.runAs(u){
        ApexPages.StandardController sc = new ApexPages.StandardController(u);
        TwitterAuthorizationController controller = new TwitterAuthorizationController(sc);
        controller.authorize();     
        controller.clearTokens();
        controller.completeAuthorization();
      }
     Test.StopTest();   
    }
}