/*
	AAUpdateReportingAttr
	
	Called by AdvocacyActionTrigger before insert
	
	Update Reporting Attributes on Advocacy Action to reflect values in Related Action Campaign
	
	Test coverage accomplished by class UpdateActionReportingAttrTest
*/

public with sharing class AAUpdateReportingAttr {
    public static void updateReportingAttr(List<kweos__EOCS_Data__c> actionList) {
    	//Get list of related action campaigns
    	Set<Id> idSet = new Set<Id>();
    	for(kweos__EOCS_Data__c action : actionList) {
    		if(action.kwac__Related_Action__c != null) {
	    		if( ! idSet.contains(action.kwac__Related_Action__c) ) {
	    			idSet.add(action.kwac__Related_Action__c);
	    		}
    		}
    	}
    	if(idSet.isEmpty()) {
    		return;
    	}
    	//Retrieve reporting attributes from all campaigns in actionList
    	Map<Id, Campaign> campMap = new Map<Id, Campaign>([
    		select
    			Id, 
    			Marketing_Tags_Global__c,
    			Tactic_Owner_Category_Global__c,
    			Tactic_Owner_Global__c,
    			State_Global__c,
    			National_Campaign_Global__c,
    			Campaign_Strategy_Global__c,
    			Local_Campaign_Global__c
    		from Campaign
    		where Id in :idSet
    	]);
    	//Copy campaign attributes to actions
    	for(kweos__EOCS_Data__c action : actionList) {
    		Campaign camp = campMap.get(action.kwac__Related_Action__c);
    		//action.Marketing_Tags_Global__c = camp.Marketing_Tags_Global__c;
			action.Tactic_Owner_Category_Global__c = camp.Tactic_Owner_Category_Global__c;
    		action.Tactic_Owner_Global__c = camp.Tactic_Owner_Global__c;
    		action.State_Global__c = camp.State_Global__c;
    		action.National_Campaign_Global__c = camp.National_Campaign_Global__c;
    		action.Campaign_Strategy_Global__c = camp.Campaign_Strategy_Global__c;
    		action.Local_Campaign_Global__c = camp.Local_Campaign_Global__c;
    	}
    }    
}