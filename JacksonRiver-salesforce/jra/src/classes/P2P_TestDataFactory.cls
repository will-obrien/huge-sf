@isTest
public with sharing class P2P_TestDataFactory {

    public static Contact p2pContactCreator(String firstName, String lastName, String email) {
        Contact contact = new Contact();
        contact.FirstName = firstName;
        contact.LastName = lastName;
        contact.Email = email;
        insert contact;
        
        // Return with AccountId
        contact = [SELECT Id, AccountId, FirstName, LastName, Email FROM contact where Id =: contact.Id];
        
        return contact;
    }
    
    public static P2P_Category__c p2pCategoryCreator(String name, String description, String url) {
        P2P_Category__c category = new P2P_Category__c();
        category.Name = name;
        category.P2P_Category_Description__c = description;
        category.P2P_Category_URL__c = url;
        insert category;
        
        return category;
    }
    
    public static P2P_Campaign__c p2pCampaignCreator(String name, P2P_Category__c category, String nodeId, String goalType) {
        P2P_Campaign__c campaign = new P2P_Campaign__c();
        campaign.name = name;
        campaign.P2P_Category__c = category.Id;
        campaign.Node_ID__c = nodeId;
        campaign.Goal_Type__c = goalType;
        insert campaign;
        
        return campaign;
    }
    
    public static P2P_Personal_Campaign__c p2pPersonalCampaignCreator(string Name, P2P_Campaign__c campaign, Contact contact,
        Integer length, String goalType, Decimal goal) {
        P2P_Personal_Campaign__c personalCampaign = new P2P_Personal_Campaign__c();
        personalCampaign.Name = name;
        personalCampaign.P2P_Category__c = campaign.P2P_Category__c;
        personalCampaign.P2P_Campaign__c = campaign.Id;
        personalCampaign.P2P_Campaigner__c = contact.Id;
        personalCampaign.Start_Date__c = Date.today();
        personalCampaign.End_Date__c = Date.today().addDays(length);
        personalCampaign.Goal_Type__c = goalType;
        personalCampaign.Fundraising_Goal__c = goal;
        
        insert personalCampaign;
        
        return personalCampaign;    
    }
    
    public static Opportunity p2pCampaignDonationCreator(Double amount, Contact contact, P2P_Personal_Campaign__c personalCampaign) {
        Opportunity donation = new Opportunity();
        donation.Name = 'Donation to ' + personalCampaign.Name;
        donation.Amount = amount;
        donation.AccountId = contact.AccountId;
        donation.StageName = 'Posted';
        donation.Probability = 100;
        donation.CloseDate = Date.today();
        donation.P2P_Personal_Campaign__c = personalCampaign.Id;
        insert donation;
        
        return donation;    
    }
    
}