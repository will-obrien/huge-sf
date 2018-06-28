@isTest
private class P2P_Personal_CampaignTriggerTest {

	/*
	static testMethod void personalCampaignOwnerCampaignCountTest() {
		Contact contact = P2P_TestDataFactory.p2pContactCreator('John', 'Doe', 'john.doe@example.com');
        P2P__c category = P2P_TestDataFactory.p2pCategoryCreator('Endangered Species', 'Peer to peer campaigns related to endangered species.', 'http://example.com/endangered-species');
        P2P_Campaign__c campaign = P2P_TestDataFactory.p2pCampaignCreator('Blue Whales', category, '5', 'Amount Raised');
        P2P_Personal_Campaign__c personalCampaign1 = P2P_TestDataFactory.p2pPersonalCampaignCreator('John\'s Campaign to Stop Whale Poaching', campaign, contact, 30, 'Amount Raised', 1000.00);
        
        Opportunity donation1 = P2P_TestDataFactory.p2pCampaignDonationCreator(50, contact, personalCampaign1);
        
		contact = [SELECT Id, AccountId, P2P_Total_Campaigns__c, P2P_Total_Donations__c, P2P_Total_Donation_Amount__c FROM Contact WHERE Id =: contact.Id];
		System.assertEquals(1, contact.P2P_Total_Campaigns__c);
		System.assertEquals(1, contact.P2P_Total_Donations__c);
		System.assertEquals(50, contact.P2P_Total_Donation_Amount__c);
		
		// Add another.
		P2P_Personal_Campaign__c personalCampaign2 = P2P_TestDataFactory.p2pPersonalCampaignCreator('John Saves the Whales', campaign, contact, 45, 'Amount Raised', 500.00);
		
		Opportunity donation2 = P2P_TestDataFactory.p2pCampaignDonationCreator(25, contact, personalCampaign2);
		
		contact = [SELECT Id, AccountId, P2P_Total_Campaigns__c, P2P_Total_Donations__c, P2P_Total_Donation_Amount__c FROM Contact WHERE Id =: contact.Id];
		System.assertEquals(2, contact.P2P_Total_Campaigns__c);
		System.assertEquals(2, contact.P2P_Total_Donations__c);
		System.assertEquals(75, contact.P2P_Total_Donation_Amount__c);
	}

    static testMethod void personalCampaignToCampaignCalculationsTest() {
        
        Contact contact = P2P_TestDataFactory.p2pContactCreator('John', 'Doe', 'john.doe@example.com');
        P2P__c category = P2P_TestDataFactory.p2pCategoryCreator('Endangered Species', 'Peer to peer campaigns related to endangered species.', 'http://example.com/endangered-species');
        P2P_Campaign__c campaign = P2P_TestDataFactory.p2pCampaignCreator('Blue Whales', category, '5', 'Amount Raised');
        
        campaign = [SELECT Id, P2P_Category__c, Number_of_Submission__c FROM P2P_Campaign__c WHERE Id =: campaign.Id];
        System.assertEquals(NULL, campaign.Number_of_Submission__c);
        
        // Create 2 personal campaigns
        P2P_Personal_Campaign__c personalCampaign1 = P2P_TestDataFactory.p2pPersonalCampaignCreator('John\'s Campaign to Stop Whale Poaching', campaign, contact, 30, 'Amount Raised', 1000.00);
        P2P_Personal_Campaign__c personalCampaign2 = P2P_TestDataFactory.p2pPersonalCampaignCreator('John Saves the Whales', campaign, contact, 45, 'Amount Raised', 500.00);
        
        // Update the personal campaign's submission counts manually
        personalCampaign1.Submission_Count__c = 10;
        personalCampaign1.Donation_Count__c = 1;
        update personalCampaign1;
        
        campaign = [SELECT Number_of_Submission__c, Number_of_donations__c FROM P2P_Campaign__c WHERE Id =: campaign.Id];
        System.assertEquals(10, campaign.Number_of_Submission__c);
        System.assertEquals(1, campaign.Number_of_donations__c);
        
        personalCampaign2.Submission_Count__c = 20;
        personalCampaign2.Donation_Count__c = 3;
        update personalCampaign2;
        
        campaign = [SELECT Number_of_Submission__c, Number_of_donations__c FROM P2P_Campaign__c WHERE Id =: campaign.Id];
        System.assertEquals(30, campaign.Number_of_Submission__c);
        System.assertEquals(4, campaign.Number_of_donations__c);
    }
    */
}