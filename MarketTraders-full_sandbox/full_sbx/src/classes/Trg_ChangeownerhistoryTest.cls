@ISTest(SeeAllData=true)
public class Trg_ChangeownerhistoryTest{
    
    public static testmethod void Trgr_InsertOpportunityHistoryTest(){        
        User u;
        User u1;
        Account acc = new Account();
        acc.name = 'test Account';
        insert acc;        
         
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];        
        System.runAs ( thisUser ){
            Profile p = [SELECT Id FROM Profile WHERE Name ='MTI SF Automation'];
            UserRole r = [Select id from userrole where name ='Software Development'];
            u = new User();
            u.Alias = 'standt';
            u.Email = 'standarduser@testorg.com';
            u.EmailEncodingKey = 'UTF-8';
            u.LastName = 'TestingHS';
            u.LanguageLocaleKey = 'en_US';
            u.LocaleSidKey = 'en_US';
            u.ProfileId = p.Id;
            u.TimeZoneSidKey = 'America/Los_Angeles';
            u.UserName = 'testHS@testorg.com';
            u.isActive = true;
            insert u;
        }
        
        User thisUser1 = [ select Id from User where Id = :UserInfo.getUserId() ];        
        System.runAs ( thisUser1 ){
            Profile p1 = [SELECT Id FROM Profile WHERE Name ='MTI SF Automation'];
            UserRole r = [Select id from userrole where name ='Software Development'];
            u1 = new User();
            u1.Alias = 'standt';
            u1.Email = 'standarduser@testorg.com';
            u1.EmailEncodingKey = 'UTF-8';
            u1.LastName = 'TestingHS1';
            u1.LanguageLocaleKey = 'en_US';
            u1.LocaleSidKey = 'en_US';
            u1.ProfileId = p1.Id;
            u1.TimeZoneSidKey = 'America/Los_Angeles';
            u1.UserName = 'testHS1@testorg.com';
            u1.isActive = true;
            insert u1;
        }
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test Opportunity';
        opp.AccountId = acc.id;
        opp.Product__c = 'UTP OnDemand';
        opp.CloseDate = date.today();
        opp.StageName = 'Closed Lost';
        opp.ownerid = u.id;

        insert opp;
        
        Test.startTest();
        System.runAs(u) {
            opp.ownerid = u1.id;
            update opp;
        }
        Test.stopTest();
    }

}