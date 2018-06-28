trigger P2P_Personal_CampaignTrigger on P2P_Personal_Campaign__c (after insert, after update) {
	
	P2P_Personal_CampaignTriggerHandler triggerHandler = new P2P_Personal_CampaignTriggerHandler(TRUE);
	
	/**
	 * On insert we'll want to increment the number of campaigns the contact owns.
	 */
	if (Trigger.isInsert && Trigger.isAfter) {
		triggerHandler.OnAfterInsert(Trigger.new);
	}
}