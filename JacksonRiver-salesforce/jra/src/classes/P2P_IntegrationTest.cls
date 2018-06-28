/**
 * Test all the P2P triggers work together in an integrated fashion.
 */
@isTest
private class P2P_IntegrationTest {

    static testMethod void bulkPropagationTest() {
        Contact contact = P2P_TestDataFactory.p2pContactCreator('John', 'Doe', 'john.doe@example.com');
        P2P_Category__c category = P2P_TestDataFactory.p2pCategoryCreator('Endangered', 'Peer to peer campaigns related to endangered species.', 'http://example.com/es');
        
        // Create a couple campaigns
        List<P2P_Campaign__c> campaigns = new List<P2P_Campaign__c>();
        campaigns.add(P2P_TestDataFactory.p2pCampaignCreator('Blue Whales', category, '5', 'Amount Raised'));
        campaigns.add(P2P_TestDataFactory.p2pCampaignCreator('Rats', category, '6', 'Amount Raised'));
        campaigns.add(P2P_TestDataFactory.p2pCampaignCreator('Dogs', category, '7', 'Amount Raised'));
        
        campaigns = [SELECT Id, P2P_Category__c, Number_of_Submission__c, Number_of_donations__c, Amount_Raised__c FROM P2P_Campaign__c WHERE Id IN : campaigns];
        for (P2P_Campaign__c campaign : campaigns) {
            System.assertEquals(NULL, campaign.Number_of_Submission__c);
            System.assertEquals(NULL, campaign.Number_of_donations__c);
            System.assertEquals(NULL, campaign.Amount_Raised__c);
        }
        
        List<P2P_Personal_Campaign__c> personalCampaigns = new List<P2P_Personal_Campaign__c>();
        // Create a bunch of personal campaigns and assign them to campaigns.
        for (Integer i = 0; i < 100; i++) {
            P2P_Personal_Campaign__c pc = new P2P_Personal_Campaign__c();
            pc.Name = 'Personal Campaign ' + i;
            pc.P2P_Category__c = campaigns.get(0).P2P_Category__c;
            pc.P2P_Campaign__c = campaigns.get(0).Id;
            pc.P2P_Campaigner__c = contact.Id;
            pc.Start_Date__c = Date.today();
            pc.End_Date__c = Date.today().addDays(30);
            pc.Goal_Type__c = 'Amount Raised';
            pc.Fundraising_Goal__c = 10000;
            personalCampaigns.add(pc);
        }   
        
        insert personalCampaigns;
        for (P2P_Personal_Campaign__c personalCampaign : personalCampaigns) {
            System.assertEquals(NULL, personalCampaign.Amount_Raised__c);
            System.assertEquals(NULL, personalCampaign.Donation_Count__c);
            System.assertEquals(NULL, personalCampaign.Submission_Count__c);
        }
        
        List<Opportunity> donations = new List<Opportunity>();
        for (Integer i = 0; i < 200; i++) {
            Opportunity donation = new Opportunity();
            donation.Name = 'Donation to ' + personalCampaigns.get(0).Name;
            donation.Amount = 10;
            donation.AccountId = contact.AccountId;
            donation.StageName = 'Posted';
            donation.Probability = 100;
            donation.CloseDate = Date.today();
            donation.P2P_Personal_Campaign__c = personalCampaigns.get(0).Id;
            donations.add(donation);
        }
        
        insert donations;
        
        // Assert that values on the personal campaign updated correctly
        P2P_Personal_Campaign__c personalCampaign = [SELECT Id, Name, Amount_Raised__c, Donation_Count__c, Submission_Count__c FROM P2P_Personal_Campaign__c WHERE Id =: personalCampaigns.get(0).Id];
        System.assertEquals(2000.00, personalCampaign.Amount_Raised__c);
        System.assertEquals(200, personalCampaign.Donation_Count__c);
        System.assertEquals(200, personalCampaign.Submission_Count__c);
        
        // Assert that values on the campaign updated correctly
        P2P_Campaign__c campaign = [SELECT Id, P2P_Category__c, Number_of_Submission__c, Number_of_donations__c, Amount_Raised__c  FROM P2P_Campaign__c WHERE Id =: campaigns.get(0).Id];
        System.assertEquals(200, campaign.Number_of_Submission__c);
        System.assertEquals(200, campaign.Number_of_donations__c);
        System.assertEquals(2000.00, campaign.Amount_Raised__c);
        
        contact = [SELECT Id, P2P_Total_Donation_Amount__c, P2P_Total_Campaigns__c, P2P_Total_Donations__c FROM Contact WHERE Id =: contact.Id];
        System.assertEquals(2000.00, contact.P2P_Total_Donation_Amount__c);
        System.assertEquals(200, contact.P2P_Total_Donations__c);
        System.assertEquals(100, contact.P2P_Total_Campaigns__c);
    }
    
    static testMethod void propagationTest() {
        Contact contact = P2P_TestDataFactory.p2pContactCreator('John', 'Doe', 'john.doe@example.com');
        P2P_Category__c category = P2P_TestDataFactory.p2pCategoryCreator('Endangered Species', 'Peer to peer campaigns related to endangered species.', 'http://example.com/endangered-species');
        P2P_Campaign__c campaign = P2P_TestDataFactory.p2pCampaignCreator('Blue Whales', category, '5', 'Amount Raised');
        P2P_Personal_Campaign__c personalCampaign = P2P_TestDataFactory.p2pPersonalCampaignCreator('John\'s Campaign to Stop Whale Poaching', campaign, contact, 30, 'Amount Raised', 1000.00);
        Opportunity donation = P2P_TestDataFactory.p2pCampaignDonationCreator(10, contact, personalCampaign);
        
        update personalCampaign;
        
        // Check personal campaign stats
        personalCampaign = [SELECT Id, Name, Amount_Raised__c, Donation_Count__c, Submission_Count__c FROM P2P_Personal_Campaign__c WHERE Id =: personalCampaign.Id];
        System.assertEquals(10.00, personalCampaign.Amount_Raised__c);
        System.assertEquals(1, personalCampaign.Submission_Count__c);
        System.assertEquals(1, personalCampaign.Donation_Count__c);
        
        // Check campaign stats
        campaign = [SELECT Id, P2P_Category__c, Number_of_Submission__c, Number_of_donations__c, Amount_Raised__c  FROM P2P_Campaign__c WHERE Id =: campaign.Id];
        //System.assertEquals(1, campaign.Number_of_Submission__c);
        System.assertEquals(1, campaign.Number_of_donations__c);
        System.assertEquals(10.00, campaign.Amount_Raised__c);
        
        P2P_Personal_Campaign__c personalCampaign2 = P2P_TestDataFactory.p2pPersonalCampaignCreator('John\'s Campaign to Stop Whale Poaching 2', campaign, contact, 30, 'Amount Raised', 1000.00);
        Opportunity donation2 = P2P_TestDataFactory.p2pCampaignDonationCreator(25, contact, personalCampaign2);
        
        campaign = [SELECT Id, Number_of_Submission__c, Number_of_donations__c, Amount_Raised__c  FROM P2P_Campaign__c WHERE Id =: campaign.Id];
        System.assertEquals(35.00, campaign.Amount_Raised__c);
        System.assertEquals(2, campaign.Number_of_donations__c);
        
        // Check contact stats
        contact = [SELECT Id, P2P_Total_Donation_Amount__c, P2P_Total_Campaigns__c, P2P_Total_Donations__c FROM Contact WHERE Id =: contact.Id];
        System.assertEquals(35.00, contact.P2P_Total_Donation_Amount__c);
        System.assertEquals(2, contact.P2P_Total_Donations__c);
        System.assertEquals(2, contact.P2P_Total_Campaigns__c);
       
    }
}