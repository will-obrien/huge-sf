@isTest
private class InitializeGiftCampaignSummaryTest {
    static Id promotionId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Promotion').getRecordTypeId();

    static testMethod void myUnitTest() {
        List<Campaign> campList = new List<Campaign>();
        Campaign promotionCampaign = new Campaign(
            Name = 'test Promotion campaign',
            External_Id__c = 'test Promotion campaign',
            RecordTypeId = promotionId,
            Type = 'Promotion',
            Status = 'Planned'
        );
        campList.add(promotionCampaign);
        Campaign promotionCampaign2 = new Campaign(
            Name = 'test Promotion campaign 2',
            External_Id__c = 'test Promotion campaign 2',
            RecordTypeId = promotionId,
            Type = 'Promotion',
            Status = 'Planned'
        );
        campList.add(promotionCampaign2);
        
        insert campList;
    	
		List<CampaignToSummarize__c> sumList = new List<CampaignToSummarize__c>();
		sumList.add(new CampaignToSummarize__c(Campaign__c = promotionCampaign.Id));     	
		sumList.add(new CampaignToSummarize__c(Campaign__c = promotionCampaign2.Id));
		
		insert sumList;
		
		List<CampaignToSummarize__c> list1 = [select Id from CampaignToSummarize__c];
		System.assertEquals(2, list1.size());
		
		Test.startTest();
		Database.executeBatch(new InitializeGiftCampaignSummary('Promotion', Date.Today()));
		Test.stopTest();

		list1 = [select Id from CampaignToSummarize__c];
		System.assertEquals(0, list1.size());
    }
}