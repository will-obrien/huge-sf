@isTest
private class P2P_OpportunityTriggerTest {

    static testMethod void campaignCalculationsTest() {
        
        Contact contact = new Contact();
        contact.FirstName = 'John';
        contact.LastName = 'Doe';
        contact.Email = 'john.doe@example.com';
        insert contact;
        
        contact = [SELECT AccountId, FirstName, LastName, Email FROM contact where Id =: contact.Id];
        
        P2P__c category = new P2P__c();
        category.Name = 'Endangered Species';
        category.P2P_Category_Description__c = 'Peer to peer campaigns related to endangered species.';
        category.P2P_Category_URL__c = 'http://example.com/endangered-species';
        insert category;
        
        P2P_Campaign__c campaign = new P2P_Campaign__c();
        campaign.name = 'Blue Whales';
 
        campaign.P2P_Category__c = category.Id;
        campaign.Node_ID__c = '255';
        campaign.Goal_Type__c = 'Amount Raised';
        insert campaign;
        
        P2P_Personal_Campaign__c personalCampaign = new P2P_Personal_Campaign__c();
        personalCampaign.Name = 'John\'s Campaign to Stop Whale Poaching';
        personalCampaign.P2P_Category__c = category.Id;
        personalCampaign.P2P_Campaign__c = campaign.Id;
        personalCampaign.P2P_Campaigner__c = contact.Id;
        personalCampaign.Node_ID__c = '256';
        personalCampaign.Published_in_Springboard__c = TRUE;
        personalCampaign.Start_Date__c = Date.today();
        personalCampaign.End_Date__c = Date.today().addDays(30);
        personalCampaign.Goal_Type__c = 'Amount Raised';
        personalCampaign.Fundraising_Goal__c = 1000.00;
        personalCampaign.Suggested_Donation_Amount__c = 10.00;
        insert personalCampaign;
        
        Opportunity donation = new Opportunity();
        donation.Amount = 10.00;
        donation.Name = 'John Doe Donation';
        donation.AccountId = contact.AccountId;
        donation.StageName = 'Posted';
        donation.Probability = 100;
        donation.CloseDate = Date.today();
        donation.Transaction_Date_Time__c = DateTime.now();
        donation.P2P_Personal_Campaign__c = personalCampaign.Id;
        insert donation;
        
        personalCampaign = [SELECT Id, Amount_Raised__c, Submission_Count__c FROM P2P_Personal_Campaign__c WHERE Id =: personalCampaign.Id];
        System.assertEquals(10.00, personalCampaign.Amount_Raised__c);
        System.assertEquals(1, personalCampaign.Submission_Count__c);
        
    }
}