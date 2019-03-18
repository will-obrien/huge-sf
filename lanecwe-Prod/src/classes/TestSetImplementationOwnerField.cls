/*********************************************************************
Name : TestSetImplementationOwnerField
Created On : Dec 6, 2012  
Created By :  JP
Description : Test class to check functionality of trigger SetImplementationOwnerField on Opportunity  object
**********************************************************************/
@isTest(SeeAllData=true)
private class TestSetImplementationOwnerField{
    static testMethod void UnitTest_SetImplementationOwnerField() {
    test.startTest();
     User u=createUser();  
     List<Id> oppIds = new List<Id>();
     List<Id> ImpSerRecordIds= new List<Id>(); 

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
     
        Implementation_Services__c imp= new Implementation_Services__c();
        imp.Related_Opportunity__c = opp1.Id;
        imp.Implementation_Owner__c = u.Id;
        imp.IST_Status__c = 'Plan';
        imp.CheckboxForWFRule__c = false;
        imp.Implementation_Type__c = 'Partner <5K MMR';
         insert imp; 
         
          /*Implementation_Services__c imp1= new Implementation_Services__c();
        imp1.Related_Opportunity__c = opp1.Id;
        imp1.Implementation_Owner__c = u.Id;
        imp1.IST_Status__c = 'Plan';
        imp1.CheckboxForWFRule__c = false;
        imp1.Implementation_Type__c = 'Partner <5K MMR';
         insert imp1;*/ 
     
        Opportunity opp2 = new Opportunity();
          opp2.Name = 'test1';
          opp2.AccountId = acc.Id;
          opp2.CloseDate = system.today();
          opp2.StageName = 'Qualification';
          opp2.CurrencyIsoCode = 'USD';
          opp2.Related_Implementation_Record__c=imp.id;
           insert opp2;
        
         OpportunityLineItem oli2 = PGITestUtilities.getOpportunityLineItemDetails(opp2.Id, standardPbe.Id);
     	 insert oli2;
           
         /*Opportunity opp3 = new Opportunity();
         opp3.Name = 'test1';
         opp3.AccountId = acc.Id;
         opp3.CloseDate = system.today();
         opp3.StageName = 'Qualification';
         opp3.CurrencyIsoCode = 'USD';
         opp3.Related_Implementation_Record__c=imp1.id;
         insert opp3 ;
           
         OpportunityLineItem oli3 = PGITestUtilities.getOpportunityLineItemDetails(opp3.Id, standardPbe.Id);
     	 insert oli3;*/
            
  ImpSerRecordIds.add(imp.id);
  //ImpSerRecordIds.add(imp1.id);
  
    //oppIds.add(opp3.id ); 
    oppIds.add(opp2.id); 
        
        
       
        
          
    ClassForSetImplementationOwnerField.UpdateOwnerField(oppIds,ImpSerRecordIds);
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