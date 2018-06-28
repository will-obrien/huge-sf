/*********************************************************************
Name : Test_SetDefaultCaseUserField 
Created On : March 3rd, 2012 
Created By : Appirio
Description : Test class on  Trigger on SetDefaultCaseUserField 
**********************************************************************/

@isTest
private class Test_SetDefaultCaseUserField {

    static testMethod void myUnitTest() {
     
        User u=createUser();
        system.runAs(u){
            list<Account> CompanyAccountList=new list<Account>(); 
            Account apacAcc= new Account();
            apacAcc.Name='TestapacAcc';
            CompanyAccountList.add(apacAcc);
            insert CompanyAccountList;
            Case objCase= new Case();
            objCase.Type='Other';
            objCase.Origin='Email';
            objCase.Status='New';
            objCase.Priority='Medium';
            objCase.Subject='Test Subject';
            objCase.Submitted_By_Contact_Email__c=u.Username; //test12.dummy.20110405@appirio.com';
            test.startTest();
            insert objCase;
            test.stopTest();
            Case UpCase = [select Submitted_By_User__c,Owner_Region__c,Channel__c, Location__c,Supervisor__c from Case where Id = :objCase.Id];            
            list<User> UserList= [Select Id, Region__c,Channel__c,Manager.Name,Location__c From User where Id=:u.Id limit 1];
            system.assertEquals(UpCase.Owner_Region__c,UserList.get(0).Region__c);
            system.assertEquals(UpCase.Channel__c, UserList.get(0).Channel__c);
            system.assertEquals(UpCase.Location__c, UserList.get(0).Location__c);
            system.assertEquals(UpCase.Supervisor__c, UserList.get(0).Manager.Name);
            system.assertEquals(UpCase.Submitted_By_User__c, UserList.get(0).Id);
        }
    } 
          public static User createUser() {
        // need to change these values
        /*List<Profile> profiles = [select Id From Profile where Name = 'System Administrator' limit 1];
        String profileId = profiles.get(0).Id;
        User user = new User();
        user.Email = 'test.dummy.20110405@appirio.com';
        user.CommunityNickname = 'test.dummy.20110405@appirio.com';
        user.UserName = 'test12.dummy.20110405@appirio.com';
        user.FirstName = 'Foo';
        user.LastName = 'Bar';
        user.Alias = 'foo';
        user.ProfileId = profileId;
        user.EmailEncodingKey = 'ISO-2022-JP';
        user.LanguageLocaleKey = 'ja';
        user.LocaleSidKey = 'ja_JP';
        user.TimeZoneSidKey = 'Asia/Tokyo';*/
        User user = PGITestUtilities.getTestUser();
        user.TESLA_SalesRep_Email__c ='testing1@testsite.com';
        user.TESLA_SALESMANAGER_ID__c='testsm1';
        user.Region__c='';
        user.Channel__c = '';
        insert user;
        return user;
    }
}