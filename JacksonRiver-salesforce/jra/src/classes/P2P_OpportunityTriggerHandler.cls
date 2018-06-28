public with sharing class P2P_OpportunityTriggerHandler {
	private boolean IsExecuting = false;

    public P2P_OpportunityTriggerHandler(boolean isExecuting){
        IsExecuting = isExecuting;
    }
    
    /**
	 * Logic to run after new opportunities are created.
	 */
	public void OnAfterInsert(Opportunity[] newOpportunities){
   		// Increment the campaign count on the related contacts.
   		updatePersonalCampaignStatistics(newOpportunities);
    }
    
    /**
     * Update the running totals on the personal peer to peer campaign after
     * each new donation is made.
     */
    private void updatePersonalCampaignStatistics(Opportunity[] newOpportunities) {
		// Maps to store amounts and submissions keyed on personal campaign id.
		Map<Id, Decimal> amountToAdd = new Map<Id, Decimal>();
		Map<Id, Integer> countToAdd = new Map<Id, Integer>();
		
		for (Opportunity o : newOpportunities) {
			// Check to see if the opportunity was made to a personal campaign.
			if (o.P2P_Personal_Campaign__c != NULL) {
				// Keep track of the amount to add for each personal campaign.
				if (amountToAdd.containsKey(o.P2P_Personal_Campaign__c)) {
					amountToAdd.put(o.P2P_Personal_Campaign__c, amountToAdd.get(o.P2P_Personal_Campaign__c) + o.Amount);
				}
				else {
					amountToAdd.put(o.P2P_Personal_Campaign__c, o.Amount);	
				}
				
				// Keep track of the count to add for each personal campaign.
				if (countToAdd.containsKey(o.P2P_Personal_Campaign__c)) {
					countToAdd.put(o.P2P_Personal_Campaign__c, countToAdd.get(o.P2P_Personal_Campaign__c) + 1);
				}
				else {
					countToAdd.put(o.P2P_Personal_Campaign__c, 1);
				}
			}
		}
		
		// If we've got some values to add, keep track of the campaigns and contacts that also need to be updated.
		if (!amountToAdd.isEmpty()) {
			Map<Id, Id> campaignsToUpdate = new Map<Id, Id>();
			Map<Id, Id> contactsToUpdate = new Map<Id, Id>();
			
			Map<Id, Decimal> amountToAddToCampaign = new Map<Id, Decimal>();
			Map<Id, Integer> countToAddToCampaign = new Map<Id, Integer>();
			
			Map<Id, Decimal> amountToAddToContact = new Map<Id, Decimal>();
			Map<Id, Integer> countToAddToContact = new Map<Id, Integer>();
			
			// Query the personal campaigns so we can add in the new amounts.
			List<P2P_Personal_Campaign__c> personalCampaigns = [SELECT Id, P2P_Campaign__c, P2P_Campaigner__c, Amount_Raised__c, Submission_Count__c, Donation_Count__c FROM P2P_Personal_Campaign__c WHERE Id IN : amountToAdd.keySet()];
			for (P2P_Personal_Campaign__c personalCampaign: personalCampaigns) {
				
				// Track the stats to the peer to peer campaign
				addValueToDecimalMap(amountToAddToCampaign, personalCampaign.P2P_Campaign__c, amountToAdd.get(personalCampaign.Id));
				addValueToIntegerMap(countToAddToCampaign, personalCampaign.P2P_Campaign__c, countToAdd.get(personalCampaign.Id));
				
				// Track the stats to the campaign owner (contact)
				addValueToDecimalMap(amountToAddToContact, personalCampaign.P2P_Campaigner__c, amountToAdd.get(personalCampaign.Id));
				addValueToIntegerMap(countToAddToContact, personalCampaign.P2P_Campaigner__c, countToAdd.get(personalCampaign.Id));
				
				// Amount raised
				personalCampaign.Amount_Raised__c = amountToAdd.get(personalCampaign.Id) + (personalCampaign.Amount_Raised__c == NULL ? 0 : personalCampaign.Amount_Raised__c);
				// Submission count
				personalCampaign.Submission_Count__c = countToAdd.get(personalCampaign.Id) + (personalCampaign.Submission_Count__c == NULL ? 0 : personalCampaign.Submission_Count__c);
				// Donation count
				personalCampaign.Donation_Count__c = countToAdd.get(personalCampaign.Id) + (personalCampaign.Donation_Count__c == NULL ? 0 : personalCampaign.Donation_Count__c);

			}
			
			// Update the personal campaigns.
			update personalCampaigns;
			
			// Update the related peer to peer campaign.
			updateValuesOnPeerToPeerCampaign(amountToAddToCampaign, countToAddToCampaign);
			
			// Update the related contact.
			updateCountsOnContact(amountToAddToContact, countToAddToContact);
			
		}
    }	
    
    /**
     * Increases the amount raised and number of donations on the contact object.
     */
    private void updateCountsOnContact(Map<Id, Decimal> amountToAdd, Map<Id, Integer> countToAdd) {
    	List<Contact> contacts = [SELECT Id, P2P_Total_Donation_Amount__c, P2P_Total_Donations__c FROM Contact WHERE Id IN : amountToAdd.keySet()];
		for (Contact contact : contacts) {
			contact.P2P_Total_Donation_Amount__c = amountToAdd.get(contact.Id) + (contact.P2P_Total_Donation_Amount__c == NULL ? 0 : contact.P2P_Total_Donation_Amount__c);
			contact.P2P_Total_Donations__c = countToAdd.get(contact.Id) + (contact.P2P_Total_Donations__c == NULL ? 0 : contact.P2P_Total_Donations__c);
		}
		update contacts;	
    }
    
    /**
     * Increases the amount raised, number of donations and number of submission on the peer to peer campaign object.
     */
    private void updateValuesOnPeerToPeerCampaign(Map<Id, Decimal> amountToAdd, Map<Id, Integer> countToAdd) {
    	// Get all the campaigns that need updating.
		List<P2P_Campaign__c> campaigns = [SELECT Id, Amount_Raised__c, Number_of_donations__c FROM P2P_Campaign__c WHERE Id IN : amountToAdd.keySet()];
		for (P2P_Campaign__c campaign : campaigns) {
			campaign.Amount_Raised__c = amountToAdd.get(campaign.Id) + (campaign.Amount_Raised__c == NULL ? 0 : campaign.Amount_Raised__c);
			campaign.Number_of_donations__c = countToAdd.get(campaign.Id) + (campaign.Number_of_donations__c == NULL ? 0 : campaign.Number_of_donations__c);
			campaign.Number_of_Submission__c = countToAdd.get(campaign.Id) + (campaign.Number_of_Submission__c == NULL ? 0 : campaign.Number_of_Submission__c);
		}
		update campaigns;
    }
    
    /**
     * Helper function to add decimal values to a map collection.
     */
    private void addValueToDecimalMap(Map<Id, Decimal> decimalMap, Id key, Decimal value) {
    	if (!decimalMap.containsKey(key)) {
			decimalMap.put(key, value);
		}
		else {
			decimalMap.put(key, decimalMap.get(key) + value);	
		}
    }
    
    /**
     * Helper function to add integer values to a map collection.
     */
    private void addValueToIntegerMap(Map<Id, Integer> integerMap, Id key, Integer value) {
    	if (!integerMap.containsKey(key)) {
			integerMap.put(key, value);
		}
		else {
			integerMap.put(key, integerMap.get(key) + value);	
		}
    }
}