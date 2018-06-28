@isTest
private class FindGiftCampaignsToSummarizeTest {
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
        Database.executeBatch(new FindGiftCampaignsToSummarize('Donation Form', System.today() - 1));
        Test.stopTest();

		List<CampaignToSummarize__c> summaryList = [
			SELECT Campaign__c FROM CampaignToSummarize__c
		];

		Set<Id> idSet = new Set<Id>();
		for(CampaignToSummarize__c camp : summaryList) {
			idSet.add(camp.Campaign__c);
		}
		
		System.debug('Donation Form summaryList:' + summaryList);
		System.assertEquals(summaryList.size(), 2);
		System.assert(idSet.contains(formCampaign.Id));
		System.assert(idSet.contains(formCampaign2.Id));
    }
    
    static testMethod void summarizePromotionCampaigns() {
        setupTest();
        Test.startTest();
        Database.executeBatch(new FindGiftCampaignsToSummarize('Promotion', System.today() - 1));
        Test.stopTest();
        
		List<CampaignToSummarize__c> summaryList = [
			SELECT Campaign__c FROM CampaignToSummarize__c
		];

		Set<Id> idSet = new Set<Id>();
		for(CampaignToSummarize__c camp : summaryList) {
			idSet.add(camp.Campaign__c);
		}
		
		System.debug('Promotion summaryList:' + summaryList);
		System.assertEquals(summaryList.size(), 2);
		System.assert(idSet.contains(promotionCampaign.Id));
		System.assert(idSet.contains(promotionCampaign2.Id));
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
        
        System.debug('formCampaign Id:' + formCampaign.Id);
        System.debug('formCampaign2 Id:' + formCampaign2.Id);
        System.debug('promotionCampaign Id:' + promotionCampaign.Id);
        System.debug('promotionCampaign2 Id:' + promotionCampaign2.Id);
        
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