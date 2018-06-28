/*********************************************************************
Name : TestSetAccountOwnerFromSalesPrimaryOwner
Created On : Feb 23, 2012  
Created By : Lalit Bohra
Description : Test class to check functionality of trigger SetAccountOwnerFromSalesPrimaryOwner on Account object
**********************************************************************/
@isTest
private class TestSetAccountOwnerFromSalesPrimaryOwner {

    static testMethod void UnitTest_SetAccountOwnerFromSalesPrimaryOwner() {
        // TO DO: implement unit test
         User u=createUser();
        list<Account> AccountList= new list<Account>();
        for(Integer icount=0;icount<100;icount++){
            Account acc= new Account();
            acc.Name='Test'+icount;
            AccountList.add(acc);
            acc.SalesPrimaryOwner__c=u.Username; //'testing1@testsite.com';
        }
        insert AccountList;
        list<Account> UpdatedAccountList=[Select Id From Account where OwnerId=:u.Id];
        if(UpdatedAccountList != null && UpdatedAccountList.size()>0){
            system.assert(true);
        }
        else{
            system.assert(false);
        }
    }
    public static User createUser() {
        // need to change these values
        /*List<Profile> profiles = [select Id From Profile where Name = 'System Administrator' limit 1];
        String profileId = profiles.get(0).Id;
        User user = new User();
        user.Email = 'test.dummy.20110405@appirio.com';
        user.CommunityNickname = 'test.dummy.20110405@appirio.com';
        //user.UserName = 'test.dummy.20110405@appirio.com';
        user.UserName = 'testing1@testsite.com';
        user.FirstName = 'Foo';
        user.LastName = 'Bar';
        user.Alias = 'foo';
        user.ProfileId = profileId;
        user.EmailEncodingKey = 'ISO-2022-JP';
        user.LanguageLocaleKey = 'ja';
        user.LocaleSidKey = 'ja_JP';
        user.TimeZoneSidKey = 'Asia/Tokyo';*/
        //user.TESLA_SalesRep_Email__c ='testing1@testsite.com';
        User user = PGITestUtilities.getTestUser();
        user.TESLA_SalesRep_Email__c ='testing@testsite.com';
        user.TESLA_SALESMANAGER_ID__c='testsm1';
        user.User_can_select_Account_Partner_Type__c = true;
        user.Channel__c='Test Channel';
        insert user;
        return user;
    }
}