trigger P2P_OpportunityTrigger on Opportunity (after insert) {
	// Maps to store amounts and submissions keyed on personal campaign id.
	Map<Id, Decimal> amountToAdd = new Map<Id, Decimal>();
	Map<Id, Integer> countToAdd = new Map<Id, Integer>();
	
	for (Opportunity o: Trigger.new) {
		// Check to see if the opportunity was made to a personal campaign.
		if (o.P2P_Personal_Campaign__c != NULL) {
			if (amountToAdd.containsKey(o.P2P_Personal_Campaign__c)) {
				amountToAdd.put(o.P2P_Personal_Campaign__c, amountToAdd.get(o.P2P_Personal_Campaign__c) + o.Amount);
			}
			else {
				amountToAdd.put(o.P2P_Personal_Campaign__c, o.Amount);	
			}
			
			if (countToAdd.containsKey(o.P2P_Personal_Campaign__c)) {
				countToAdd.put(o.P2P_Personal_Campaign__c, countToAdd.get(o.P2P_Personal_Campaign__c) + 1);
			}
			else {
				countToAdd.put(o.P2P_Personal_Campaign__c, 1);
			}
		}
	}
	
	if (!amountToAdd.isEmpty()) {
		// Query the personal campaigns so we can add in the new amounts.
		List<P2P_Personal_Campaign__c> personalCampaigns = [SELECT Id, Amount_Raised__c, Submission_Count__c FROM P2P_Personal_Campaign__c WHERE Id IN : amountToAdd.keySet()];
		for (P2P_Personal_Campaign__c personalCampaign: personalCampaigns) {
			// Amount raised
			if (personalCampaign.Amount_Raised__c == NULL) {
				personalCampaign.Amount_Raised__c = amountToAdd.get(personalCampaign.Id);
			}
			else {
				personalCampaign.Amount_Raised__c += amountToAdd.get(personalCampaign.Id);
			}	
			
			// Submission counts
			if (personalCampaign.Submission_Count__c == NULL) {
				personalCampaign.Submission_Count__c = countToAdd.get(personalCampaign.Id);
			}
			else {
				personalCampaign.Submission_Count__c += countToAdd.get(personalCampaign.Id);
			}
		}
		
		update personalCampaigns;
	}
}