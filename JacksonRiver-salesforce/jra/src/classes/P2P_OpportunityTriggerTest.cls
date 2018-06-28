@isTest
private class P2P_OpportunityTriggerTest {

    static testMethod void campaignCalculationsTest() {
        
        Contact contact = P2P_TestDataFactory.p2pContactCreator('John', 'Doe', 'john.doe@example.com');
        P2P_Category__c category = P2P_TestDataFactory.p2pCategoryCreator('Endangered Species', 'Peer to peer campaigns related to endangered species.', 'http://example.com/endangered-species');
        P2P_Campaign__c campaign = P2P_TestDataFactory.p2pCampaignCreator('Blue Whales', category, '5', 'Amount Raised');
        P2P_Personal_Campaign__c personalCampaign = P2P_TestDataFactory.p2pPersonalCampaignCreator('John\'s Campaign to Stop Whale Poaching', campaign, contact, 30, 'Amount Raised', 1000.00);
        Opportunity donation = P2P_TestDataFactory.p2pCampaignDonationCreator(10, contact, personalCampaign);
                
        personalCampaign = [SELECT Id, Name, Amount_Raised__c, Donation_Count__c, Submission_Count__c FROM P2P_Personal_Campaign__c WHERE Id =: personalCampaign.Id];
        System.assertEquals(10.00, personalCampaign.Amount_Raised__c);
        System.assertEquals(1, personalCampaign.Submission_Count__c);
        System.assertEquals(1, personalCampaign.Donation_Count__c);
        
        Opportunity donation2 = P2P_TestDataFactory.p2pCampaignDonationCreator(25, contact, personalCampaign);
        personalCampaign = [SELECT Id, Name, Amount_Raised__c, Donation_Count__c, Submission_Count__c FROM P2P_Personal_Campaign__c WHERE Id =: personalCampaign.Id];
        System.assertEquals(35.00, personalCampaign.Amount_Raised__c);
        System.assertEquals(2, personalCampaign.Submission_Count__c);
        System.assertEquals(2, personalCampaign.Donation_Count__c);
        
        
    }
}