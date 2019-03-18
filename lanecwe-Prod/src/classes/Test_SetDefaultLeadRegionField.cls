/*********************************************************************
Name : Test_SetDefaultLeadRegionField 
Created On : dec 20, 2011  
Created By : Dileep Singhal
Description : Test class on  Trigger on Lead UpdateExistingLeadsAndContacts 
**********************************************************************/

@isTest
private class Test_SetDefaultLeadRegionField {

    static testMethod void myUnitTest() {
     
        User u=createUser();
        system.runAs(u){
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
            Lead UpLead = [select Owner_Region__c,Channel__c, Location__c,Supervisor__c from Lead where Id = :objLead.Id];            
            list<User> UserList= [Select Id, Region__c,Channel__c,Manager.Name,Location__c From User where Id=:u.Id limit 1];
            //system.assertEquals(UpLead.Owner_Region__c,UserList.get(0).Region__c);
            //system.assertEquals(UpLead.Channel__c, UserList.get(0).Channel__c);
            //system.assertEquals(UpLead.Location__c, UserList.get(0).Location__c);
            //system.assertEquals(UpLead.Supervisor__c, UserList.get(0).Manager.Name);
        }
    } 
          public static User createUser() {
        
        /*List<Profile> profiles = [select Id From Profile where Name = 'System Administrator' limit 1];
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
        user.TimeZoneSidKey = 'Asia/Tokyo';*/
        User user = PGITestUtilities.getTestUser();
        user.TESLA_SalesRep_Email__c ='testing1@testsite.com';
        user.TESLA_SALESMANAGER_ID__c='testsm1';
        user.Region__c='NA';
        user.Channel__c = 'System Admin';
        insert user;
        return user;
    }
}