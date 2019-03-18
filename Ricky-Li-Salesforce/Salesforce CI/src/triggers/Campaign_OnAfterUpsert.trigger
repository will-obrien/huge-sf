trigger Campaign_OnAfterUpsert on Campaign (after insert, after update) {
	Set<Id> TravellerContactIds = new Set<Id>();
	Set<Id> TravellerIds = new Set<Id>();
	Set<Id> CampaignIds = new Set<Id>();
	
	for(Campaign c : trigger.new)
	{
		CampaignIds.add(c.Id);
	} 
	
	for(CampaignMember cm : [select Id, ContactId from CampaignMember where CampaignId in : CampaignIds])
	{
		TravellerContactIds.add(cm.ContactId);
	}	
	
	for(Contact c : [select AccountId from Contact where Id in : TravellerContactIds])
	{
		TravellerIds.add(c.AccountId);	
	}	
	
	TravellerUtility.updateTravellersValidPromotion(TravellerIds, CampaignIds);
}