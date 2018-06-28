trigger CampaignMember_OnAfterDelete on CampaignMember (after delete) {
	Set<Id> TravellerContactIds = new Set<Id>();
	Set<Id> TravellerIds = new Set<Id>();
	Set<Id> CampaignIds = new Set<Id>();
	
	for(CampaignMember cm : trigger.old)
	{ 
		TravellerContactIds.add(cm.ContactId);
		CampaignIds.add(cm.CampaignId);
	}
	
	for(Contact c : [select AccountId from Contact where Id in : TravellerContactIds])
	{
		TravellerIds.add(c.AccountId);	
	}	

	TravellerUtility.updateTravellersValidPromotion(TravellerIds, CampaignIds);	
}