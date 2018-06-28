public with sharing class P2P_Personal_CampaignTriggerHandler {
	
	private boolean IsExecuting = false;

    public P2P_Personal_CampaignTriggerHandler(boolean isExecuting){
        IsExecuting = isExecuting;
    }

	/**
	 * Logic to run after new personal campaigns are created.
	 */
	public void OnAfterInsert(P2P_Personal_Campaign__c[] newPersonalCampaigns){
   		// Increment the campaign count on the related contacts.
   		updateCampaignCountOnContact(newPersonalCampaigns);
    }
    
    /**
     * Increments the number of personal campaigns a contact is assocated with.
     */
    private void updateCampaignCountOnContact(P2P_Personal_Campaign__c[] personalCampaigns) {
    	Map<Id, Decimal> contactCampaignCount = new Map<Id, Decimal>();
		
		for (P2P_Personal_Campaign__c personalCampaign: personalCampaigns) {
			// Campaign count.
			if (contactCampaignCount.containsKey(personalCampaign.P2P_Campaigner__c)) {
				contactCampaignCount.put(personalCampaign.P2P_Campaigner__c, contactCampaignCount.get(personalCampaign.P2P_Campaigner__c) + 1);
			}
			else {
				contactCampaignCount.put(personalCampaign.P2P_Campaigner__c, 1);	
			}
		}
		
		// Get the contacts that need to be updated.
		if (!contactCampaignCount.isEmpty()) {
			
			List<Contact> contacts = [SELECT Id, P2P_Total_Campaigns__c, P2P_Total_Donations__c, P2P_Total_Donation_Amount__c FROM Contact WHERE Id IN : contactCampaignCount.keySet()];
			for (Contact contact : contacts) {
				// Increase campaign count.
				if (contact.P2P_Total_Campaigns__c == NULL) {
					contact.P2P_Total_Campaigns__c = contactCampaignCount.get(contact.Id);
				}
				else {
					contact.P2P_Total_Campaigns__c += contactCampaignCount.get(contact.Id);
				}
			}
		
			update contacts; 
		}
    }
}