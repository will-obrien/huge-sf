/*
SummarizeGiftCampaignsTest

This class tests two programs:

SummarizeGiftCampaigns
SummarizeAllGiftCampaigns

Each program is run once for Donation Form Campaigns
and once for Promotion Campaigns

Mark Maslow - January 2016
*/
@isTest
private class SummarizeGiftCampaignsTest {
    static Id promotionId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Promotion').getRecordTypeId();
    static Id donationFormId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Donation Form').getRecordTypeId();
    static Id accountHouseholdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id opportunityDonationTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();

    static Account account1;
    static rC_Giving__GAU__c givingGAU;
    static Campaign formCampaign, formCampaign2, promotionCampaign, promotionCampaign2;
    static Opportunity opp1, opp2, opp3, opp4;

    static testMethod void summarizeFormCampaigns() {
        setupTest();
        Test.startTest();
        Database.executeBatch(new SummarizeGiftCampaigns('Donation Form'));
        Test.stopTest();
        
        Campaign camp = [
            select 
                First_Form_Giving_Date__c,
                Last_Form_Giving_Date__c,
                Total_Form_Giving_Count__c,
                Total_Form_Giving_Amount__c
            from Campaign
            where Id = :formCampaign.Id
        ];
        System.assertEquals(system.today(), camp.First_Form_Giving_Date__c);
        System.assertEquals(system.today().addDays(3), camp.Last_Form_Giving_Date__c);
        System.assertEquals(2, camp.Total_Form_Giving_Count__c);
        System.assertEquals(1500, camp.Total_Form_Giving_Amount__c);
    }
    
    static testMethod void summarizePromotionCampaigns() {
        setupTest();
        Test.startTest();
        Database.executeBatch(new SummarizeGiftCampaigns('Promotion'));
        Test.stopTest();
        
        Campaign camp = [
            select 
                First_Source_Giving_Date__c,
                Last_Source_Giving_Date__c,
                Total_Source_Giving_Count__c,
                Total_Source_Giving_Amount__c
            from Campaign
            where Id = :promotionCampaign.Id
        ];
        System.assertEquals(system.today(), camp.First_Source_Giving_Date__c);
        System.assertEquals(system.today().addDays(3), camp.Last_Source_Giving_Date__c);
        System.assertEquals(2, camp.Total_Source_Giving_Count__c);
        System.assertEquals(1500, camp.Total_Source_Giving_Amount__c);
    }
    
    static testMethod void summarizeAllFormCampaigns() {
        setupTest();
        Test.startTest();
        Database.executeBatch(new SummarizeAllGiftCampaigns('Donation Form'));
        Test.stopTest();
        
        Campaign camp = [
            select 
                First_Form_Giving_Date__c,
                Last_Form_Giving_Date__c,
                Total_Form_Giving_Count__c,
                Total_Form_Giving_Amount__c
            from Campaign
            where Id = :formCampaign.Id
        ];
        System.assertEquals(system.today(), camp.First_Form_Giving_Date__c);
        System.assertEquals(system.today().addDays(3), camp.Last_Form_Giving_Date__c);
        System.assertEquals(2, camp.Total_Form_Giving_Count__c);
        System.assertEquals(1500, camp.Total_Form_Giving_Amount__c);
    }
    
    static testMethod void summarizeAllPromotionCampaigns() {
        setupTest();
        Test.startTest();
        Database.executeBatch(new SummarizeAllGiftCampaigns('Promotion'));
        Test.stopTest();
        
        Campaign camp = [
            select 
                First_Source_Giving_Date__c,
                Last_Source_Giving_Date__c,
                Total_Source_Giving_Count__c,
                Total_Source_Giving_Amount__c
            from Campaign
            where Id = :promotionCampaign.Id
        ];
        System.assertEquals(system.today(), camp.First_Source_Giving_Date__c);
        System.assertEquals(system.today().addDays(3), camp.Last_Source_Giving_Date__c);
        System.assertEquals(2, camp.Total_Source_Giving_Count__c);
        System.assertEquals(1500, camp.Total_Source_Giving_Amount__c);
    }
    
    static void setupTest() {
        account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdId
        );
        insert account1;

        givingGAU = new rC_Giving__GAU__c(
            Name = 'Test Data GAU',
            GivingType__c = 'Donations',
            Recipient__c = 'Club',
            FundType__c = 'Chapter Funds'
        );
        insert givingGAU;
        
        List<Campaign> campList = new List<Campaign>();
        formCampaign = new Campaign(
            Name = 'test form campaign',
            External_Id__c = 'test Form campaign',
            RecordTypeId = donationFormId,
            Type = 'Promotion',
            Status = 'Planned'
        );
        campList.add(formCampaign);
        formCampaign2 = new Campaign(
            Name = 'test form campaign2',
            External_Id__c = 'test Form campaign2',
            RecordTypeId = donationFormId,
            Type = 'Promotion',
            Status = 'Planned'
        );
        campList.add(formCampaign2);
        promotionCampaign = new Campaign(
            Name = 'test Promotion campaign',
            External_Id__c = 'test Promotion campaign',
            RecordTypeId = promotionId,
            Type = 'Promotion',
            Status = 'Planned'
        );
        campList.add(promotionCampaign);
        promotionCampaign2 = new Campaign(
            Name = 'test Promotion campaign 2',
            External_Id__c = 'test Promotion campaign 2',
            RecordTypeId = promotionId,
            Type = 'Promotion',
            Status = 'Planned'
        );
        campList.add(promotionCampaign2);
        
        insert campList;
        
        List<CampaignToSummarize__c> campsToSum = new List<CampaignToSummarize__c>();
        campsToSum.add(new CampaignToSummarize__c(Campaign__c = formCampaign.Id));
        campsToSum.add(new CampaignToSummarize__c(Campaign__c = promotionCampaign.Id));
        insert campsToSum;        

        List<Opportunity> oppsToInsert = new List<Opportunity>();

        opp1 = new Opportunity(
            Name = 'Test Giving 1',
            rC_Giving__GAU__c = givingGAU.Id,
            AccountId = account1.Id,
            CloseDate = system.today(),
            StageName = 'Completed',
            rC_Giving__Projected_Amount__c = 1000,
            CampaignId = promotionCampaign.Id,
            Form_Campaign__c = formCampaign.Id,
            rC_Giving__Giving_Amount__c = 1000,
            rC_Giving__Closed_Amount__c = 1000,
            RecordTypeId = opportunityDonationTypeId
        );
        oppsToInsert.add(opp1);

        opp2 = new Opportunity(
            Name = 'Test Giving 2',
            rC_Giving__GAU__c = givingGAU.Id,
            AccountId = account1.Id,
            CloseDate = system.today().addDays(3),
            StageName = 'Completed',
            rC_Giving__Projected_Amount__c = 500,
            CampaignId = promotionCampaign.Id,
            Form_Campaign__c = formCampaign.Id,
            rC_Giving__Giving_Amount__c = 500,
            rC_Giving__Closed_Amount__c = 500,
            RecordTypeId = opportunityDonationTypeId
        );
        oppsToInsert.add(opp2);

        opp3 = new Opportunity(
            Name = 'Test Giving 3',
            rC_Giving__GAU__c = givingGAU.Id,
            AccountId = account1.Id,
            CloseDate = system.today().addDays(3),
            StageName = 'Completed',
            rC_Giving__Projected_Amount__c = 500,
            CampaignId = promotionCampaign2.Id,
            rC_Giving__Giving_Amount__c = 500,
            rC_Giving__Closed_Amount__c = 500,
            RecordTypeId = opportunityDonationTypeId
        );
        oppsToInsert.add(opp3);
        
        opp4 = new Opportunity(
            Name = 'Test Giving 4',
            rC_Giving__GAU__c = givingGAU.Id,
            AccountId = account1.Id,
            CloseDate = system.today().addDays(3),
            StageName = 'Completed',
            rC_Giving__Projected_Amount__c = 500,
            CampaignId = promotionCampaign2.Id,
            Form_Campaign__c = formCampaign2.Id,
            rC_Giving__Giving_Amount__c = 500,
            rC_Giving__Closed_Amount__c = 500,
            RecordTypeId = opportunityDonationTypeId
        );
        oppsToInsert.add(opp4);

        insert oppsToInsert;
    }
}