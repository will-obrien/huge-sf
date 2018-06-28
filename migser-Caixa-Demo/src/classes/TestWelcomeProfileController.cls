@isTest(Seealldata=true) 
public class TestWelcomeProfileController {
    static testMethod void test() {
    Test.startTest();
        WelcomeProfile welcomeCon = new WelcomeProfile();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='welomeprofilesuser1@testorg.com');
        insert u;
        String userid = u.id;
        //to avoid the error Static methods cannot be invoked through an object instance: call 
        //the method from the controller WelcomeProfile as opposed ot an instance which would be welcomeCon
        WelcomeProfile.getHierarchy(userid);    
        WelcomeProfile.getProfileUser(u.id);
    Test.stopTest();    
    }
}