/*********************************************************************
Name : TestSetImplementationOwnerOnOpportunity
Created On : Dec 6, 2012  
Created By :  JP
Description : Test class to check functionality of trigger SetImplementationOwnerOnOpportunity on Implementation Service object
**********************************************************************/
@isTest(SeeAllData=true)
private class TestSetImplementationOwnerOnOpportunity{
    static testMethod void UnitTest_SetImplementationOwnerOnOpportunity() {
    
     User u=createUser();   
     Implementation_Services__c ImpSer= new Implementation_Services__c();
     
            Account acc= new Account();
            acc.Name='TestAccountSetImplementationOwnerOnOpportunity';
            insert acc;
            
         Opportunity opp1 = new Opportunity();
          opp1.Name = 'test1';
          opp1.AccountId = acc.Id;
          opp1.CloseDate = system.today();
          opp1.StageName = 'Qualification';
          opp1.CurrencyIsoCode = 'USD';
          insert opp1;
        
         Product2 standardProduct = PGITestUtilities.getStdProduct();
         insert standardProduct;
         PricebookEntry standardPbe = PGITestUtilities.CreatePriceBookEntryForProduct(standardProduct);
         insert standardPbe;
         OpportunityLineItem oli = PGITestUtilities.getOpportunityLineItemDetails(opp1.Id, standardPbe.Id);
         insert oli; 
     
        ImpSer.IST_Status__c='Open';
        ImpSer.Related_Opportunity__c=opp1.id;
        ImpSer.Implementation_Type__c ='Small Business <2K MMR';      
        ImpSer.Implementation_Owner__c = u.Id;
      
        
          test.startTest();
            insert ImpSer;
            test.stopTest();
      
        }
    
     public static User createUser() {
        // need to change these values
        /*List<Profile> profiles = [select Id From Profile where Name = 'System Administrator' limit 1];
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