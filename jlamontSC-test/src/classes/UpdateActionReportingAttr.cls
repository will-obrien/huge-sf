/*
	UpdateActionReportingAttr
	
	This class runs as a batch process. It is meant to keep reporting attributes on Advocacy Actions
	in synch with the Campaign which is the Related Action.
	
	It looks for CampaignChange records that were inserted by a trigger on the Campaign object, indicating
	that one or more reporting attributes have been changed.
	
	If it finds changes, it updates reporting attributes on any Advocacy Action that has a lookup
	to the changed Campaigns as Related Actions.
	
	Finally, CampaignChange records that have been processed are deleted.
*/

public class UpdateActionReportingAttr implements Database.Batchable<sObject>, Database.Stateful {
	private Map<Id,Campaign> campaignsUpdated;
	private DateTime maxDateChanged;
	
    public Database.QueryLocator start(Database.BatchableContext BC) {
    	AggregateResult[] aggRslt = [
    		select 
    			Campaign__c,
    			max(CreatedDate) maxDate
    		from CampaignChange__c
    		group by Campaign__c
    	];
    	Set<Id> campaignIds = new Set<Id>();
    	for(AggregateResult ar : aggRslt) {
    		campaignIds.add((Id)ar.get('Campaign__c'));
    		DateTime dateChanged = (DateTime)ar.get('maxDate');
    		if(maxDateChanged == null) {
    			maxDateChanged = dateChanged;
    		}
    		else if(dateChanged > maxDateChanged) {
    			maxDateChanged = dateChanged;
    		}
    	}
    	campaignsUpdated = new Map<Id, Campaign>([
            SELECT 
    			Id, 
    			Marketing_Tags_Global__c,
    			Tactic_Owner_Category_Global__c,
    			Tactic_Owner_Global__c,
    			State_Global__c,
    			National_Campaign_Global__c,
    			Campaign_Strategy_Global__c,
    			Local_Campaign_Global__c
    		from Campaign
    		where Id in :campaignIds
    	]);
        return Database.getQueryLocator([
            SELECT 
    			Id,
    			kwac__Related_Action__c 
    		from kweos__EOCS_Data__c
    		where kwac__Related_Action__c in :campaignIds
    	]);
    }
    public void execute(Database.BatchableContext BC, List<kweos__EOCS_Data__c> scope) {
    	List<kweos__EOCS_Data__c> actionsToUpdate = new List<kweos__EOCS_Data__c>();
    	for(kweos__EOCS_Data__c action : scope) {
    		Campaign camp = campaignsUpdated.get(action.kwac__Related_Action__c);
    		if(camp != null) {
    			actionsToUpdate.add(new kweos__EOCS_Data__c(
    				Id = action.Id,
	    			//Marketing_Tags_Global__c = camp.Marketing_Tags_Global__c,
	    			Tactic_Owner_Category_Global__c = camp.Tactic_Owner_Category_Global__c,
	    			Tactic_Owner_Global__c = camp.Tactic_Owner_Global__c,
	    			State_Global__c = camp.State_Global__c,
	    			National_Campaign_Global__c = camp.National_Campaign_Global__c,
	    			Campaign_Strategy_Global__c = camp.Campaign_Strategy_Global__c,
	    			Local_Campaign_Global__c = camp.Local_Campaign_Global__c
	    		));
    		}
    	}
    	if( ! actionsToUpdate.isEmpty() ) {
    		update actionsToUpdate;
    	}
    }
    public void finish(Database.BatchableContext BC) {
    	List<CampaignChange__c> campChangeList = [
    		select Id
    		from CampaignChange__c
    		where CreatedDate <= :maxDateChanged
    	];
    	if( ! campChangeList.isEmpty() ) {
    		delete campChangeList;
    	}
    }  
}