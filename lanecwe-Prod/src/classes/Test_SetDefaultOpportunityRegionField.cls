/*********************************************************************
Name : Test_SetDefaultOpportunityRegionField 
Created On : dec 20, 2011  
Created By : Dileep Singhal
Description : Test class on  Trigger on Account (SetAccountDefaultRegion), Opportunity (SetDefaultOpportunityRegionField) 
**********************************************************************/

@isTest
private class Test_SetDefaultOpportunityRegionField {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        User u=createUser();
        system.runAs(u){
            list<Account> AccountList = new list<Account>();
            list<Opportunity> OpportunityList = new list<Opportunity>();
            Account acc1= new Account();
            acc1.Name='Test Acc1';
            acc1.ChannelType__c='Reseller';
            AccountList.add(acc1);
            //insert acc1;
            
            Account acc= new Account();
            acc.Name='Test Acc';
            acc.ChannelType__c='Reseller';
            //insert acc;
            AccountList.add(acc);
            insert AccountList; 
            
            Opportunity opp1 = new Opportunity();
            opp1.Name = 'test1';
            opp1.AccountId = acc1.Id;
            opp1.CloseDate = system.today();
            opp1.StageName = 'Proposal/Price Quote';
            opp1.CurrencyIsoCode = 'USD';
            //insert opp1;
            OpportunityList.add(opp1);
            Opportunity opp = new Opportunity();
            opp.Name = 'test';
            opp.AccountId = acc.Id;
            opp.CloseDate = system.today();
            
            opp.StageName = 'Proposal/Price Quote';
            opp.CurrencyIsoCode = 'USD';
            OpportunityList.add(opp);
            insert OpportunityList;
            //insert opp;
            Opportunity UpOpty = [select Owner_Region__c from Opportunity where Id = :opp.Id];
            Account UpAcc = [select Owner_Region__c, OwnerId from Account where Id = :acc.Id];
            
           // System.debug('------------ UpAcc : '+ UpAcc);
          //  System.debug('------------ u : '+u);
           // System.debug('------------ Userinfo.getUserId() : '+Userinfo.getUserId());
            
            //system.assertEquals(UpOpty.Owner_Region__c, [Select Region__c from User where Id =:Userinfo.getUserId()].Region__c);
            system.assertEquals(UpAcc.Owner_Region__c, [Select Region__c from User where Id =:Userinfo.getUserId()].Region__c);
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
        user.Override_Validation_Rules__c =true ;
        user.LastName = 'Bar';
        user.Alias = 'foo';
        user.ProfileId = profileId;
        user.EmailEncodingKey = 'ISO-2022-JP';
        user.LanguageLocaleKey = 'ja';
        user.LocaleSidKey = 'ja_JP';
        user.TimeZoneSidKey = 'Asia/Tokyo';
        user.TESLA_SalesRep_Email__c ='testing1@testsite.com';
        user.TESLA_SALESMANAGER_ID__c='testsm1';
        user.Region__c='test region';
        user.Channel__c = 'testchannel';
        insert user;
        return user;
    }
}