trigger Campaign_OnAfterDelete on Campaign (after delete) {
/*deactivate this since 
    1. no one should hard delete campaign, they should update a campaign to deactivate it.
    2. this trigger never work since campaignMember will never be caught after Campaign is deleted.
*/    
    Set<Id> TravellerContactIds = new Set<Id>();
    Set<Id> TravellerIds = new Set<Id>();
    Set<Id> CampaignIds = new Set<Id>();
    
    for(Campaign c : trigger.old) 
    {
        CampaignIds.add(c.Id);
    }
    
    for(List<CampaignMember> campaignMembers : [select Id, ContactId from CampaignMember 
                                                    where CampaignId in : CampaignIds])
    {
        for(CampaignMember cm : campaignMembers)
        {
            TravellerContactIds.add(cm.ContactId);
        }
    }
    
    
    for(List<Contact> travellerContacts : [select AccountId from Contact where Id in : TravellerContactIds])
    {
        for(Contact c : travellerContacts)
        {
            TravellerIds.add(c.AccountId);  
        }   
    }
    
    TravellerUtility.updateTravellersValidPromotion(TravellerIds, CampaignIds);
}