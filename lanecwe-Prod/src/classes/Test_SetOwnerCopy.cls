/*********************************************************************
Name : Test_SetOwnerCopy
Created On : Oct 04, 2012  
Created By : JP
Description : Test class for trigger SetOwnerCopy
**********************************************************************/
@isTest
private class Test_SetOwnerCopy {


static testMethod void myUnitTest() {
   
User u=createUser();   

  Lead objLead= new Lead();
            objLead.Company='Test Company1';
            objLead.LastName='Test Lead1';
            objLead.Status='Open';
            objLead.CurrencyIsoCode='USD';
            objLead.IM_USER_ID__c='TestUser Id';
            ObjLead.Email='Test@testsite.com';
            ObjLead.Ignore_Assignment_Rule__c=true;
            ObjLead.TESLA_SALESMANAGER_ID__c='testsm1'; 
            
             test.startTest();
            insert objLead;
            test.stopTest();  
   
}
 public static User createUser() {
        // need to change these values
        List<Profile> profiles = [select Id From Profile where Name = 'System Administrator' limit 1];
        String profileId = profiles.get(0).Id;
        User user = new User();
        user.Email = 'test@pgi.com';
        user.CommunityNickname = 'test@pgi.com';
        user.UserName = 'test@pgi.com.fulldata30';
        user.FirstName = 'Foo';
        user.LastName = 'Bar';
        user.Alias = 'foo';
        user.ProfileId = profileId;
        user.EmailEncodingKey = 'ISO-2022-JP';
        user.LanguageLocaleKey = 'ja';
        user.LocaleSidKey = 'ja_JP';
        user.TimeZoneSidKey = 'Asia/Tokyo';
        user.TESLA_SalesRep_Email__c ='testing1@testsite.com';
        user.TESLA_SALESMANAGER_ID__c='testsm1';
        user.Region__c='NA';
        user.Channel__c = 'System Admin';
        insert user;
        return user;
    }



}