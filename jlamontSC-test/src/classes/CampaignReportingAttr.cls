/*
	CampaignReportingAttr
	
	Called by CampaignTrigger after update
	
	Insert CampaignChange records for Campaigns that have had any change to selected reporting attributes

	Test coverage accomplished by class UpdateActionReportingAttrTest
*/
public with sharing class CampaignReportingAttr {
    public static void checkAttributes(List<Campaign> newList, Map<Id, Campaign> oldMap) {
    	List<CampaignChange__c> campChgList = new List<CampaignChange__c>();
    	for(Campaign newCamp : newList) {
    		Campaign oldCamp = oldMap.get(newCamp.Id);
    		if(
    			newCamp.Marketing_Tags_Global__c != oldCamp.Marketing_Tags_Global__c ||
    			newCamp.Tactic_Owner_Category_Global__c != oldCamp.Tactic_Owner_Category_Global__c ||
    			newCamp.Tactic_Owner_Global__c != oldCamp.Tactic_Owner_Global__c ||
    			newCamp.State_Global__c != oldCamp.State_Global__c ||
    			newCamp.National_Campaign_Global__c != oldCamp.National_Campaign_Global__c ||
    			newCamp.Campaign_Strategy_Global__c != oldCamp.Campaign_Strategy_Global__c ||
    			newCamp.Local_Campaign_Global__c != oldCamp.Local_Campaign_Global__c
    		) {
    			campChgList.add(new CampaignChange__c(Campaign__c = newCamp.Id));
    		}
    	}
		if( ! campChgList.isEmpty() ) {
			insert campChgList;
		}    	
    }
}