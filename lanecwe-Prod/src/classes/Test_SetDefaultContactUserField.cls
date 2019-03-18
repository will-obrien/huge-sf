/*********************************************************************
Name : Test_SetDefaultContactUserField 
Created On : Feb 29, 2012 
Created By : Dileep Singhal
Description : Test class on  Trigger on SetDefaultContactUserField 
**********************************************************************/

@isTest
private class Test_SetDefaultContactUserField {

    static testMethod void myUnitTest() {
     
        User u=createUser();
        system.runAs(u){
            list<Account> CompanyAccountList=new list<Account>(); 
            Account apacAcc= new Account();
            apacAcc.Name='TestapacAcc';
            CompanyAccountList.add(apacAcc);
            insert CompanyAccountList;
            Contact objContact= new Contact();
            objContact.LastName='John';
            objContact.IM_USER_ID__c='TestUser Id';
            objContact.Email='Test@testsite.com';
            objContact.AccountId=apacAcc.Id;
            test.startTest();
            insert objContact;
            test.stopTest();
            Contact UpContact = [select Owner_Region__c,Channel__c, Location__c,Supervisor__c from Contact where Id = :objContact.Id];            
            list<User> UserList= [Select Id, Region__c,Channel__c,Manager.Name,Location__c From User where Id=:u.Id limit 1];
            system.assertEquals(UpContact.Owner_Region__c,UserList.get(0).Region__c);
            system.assertEquals(UpContact.Channel__c, UserList.get(0).Channel__c);
            system.assertEquals(UpContact.Location__c, UserList.get(0).Location__c);
            system.assertEquals(UpContact.Supervisor__c, UserList.get(0).Manager.Name);
        }
    } 
          public static User createUser() {
        // need to change these values
        List<Profile> profiles = [select Id From Profile where Name = 'System Administrator' limit 1];
        String profileId = profiles.get(0).Id;
        User user = new User();
        user.Email = 'test.dummy.20110405@appirio.com';
        user.CommunityNickname = 'test.dummy.20110405@appirio.com';
        user.UserName = 'test.dummy.20110405@pgi.com';
        user.FirstName = 'Foo';
        user.LastName = 'Bar';
        user.Alias = 'foo';
        user.ProfileId = profileId;
        user.EmailEncodingKey = 'ISO-2022-JP';
        user.LanguageLocaleKey = 'ja';
        user.LocaleSidKey = 'ja_JP';
        user.TimeZoneSidKey = 'Asia/Tokyo';
        /*User user = PGITestUtilities.getTestUser();*/
        user.TESLA_SalesRep_Email__c ='testing1@testsite.com';
        user.TESLA_SALESMANAGER_ID__c='testsm1';
        user.Region__c='test region';
        user.Channel__c = 'testchannel';
        insert user;
        return user;
    }
}