// **************************************************************************
// CampaignTriggerHandler								(c) 2015 Sierra Club
//
//	Trigger Handler for the trigger CampaignTrigger
//			When a Campaign is inserted or updated, check that there is 
//		not already a Campaign with External Id = new Campaign Name.
//		Otherwise, populdate External Id with new value for Campaign Name
//
//	2015/05/18?		MM		Original
//	2015/09/08		VB		Code to calculate Advocacy Action counts
//	2015/09/08		VB		Added 'after' clauses on update & delete, 
//								so totals could be calculated correctly.
//	2015/09/08		VB		Added clause to update Dirty AdvocacyAction count
//  2015/09/17		VB		Apologies, recalculateTotal() may be deprecated
//								with new batch approach.
// **************************************************************************
public with sharing class CampaignTriggerHandler {
	
	// Currently set to the Cast Iron user.  Aside from the end users, this should be the only
	//		other profile editing or updating Campaigns.
    private static final Id castironUserId = UserLookup.getId('ciron');
    private static Id groupsTypeId;
    
	Integer totalAdvocacyActionCount = 0;
	Map<Id,Campaign> campaignsToUpdateMap = new Map<Id,Campaign>();
	Map<Id,Integer> relatedConvioActionCounts = new Map<Id,Integer>();
    
    static {
        groupsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lists').getRecordTypeId();
    }
    
	//
    // Check for duplicate Name/External Id & Copy Name into External Id 
    //
    public static void beforeInsertUpdate(List<Campaign> newCampaigns, Map<Id, Campaign> oldCampaigns) {

		// Return if the current user is Cast Iron
        if (System.UserInfo.getUserId() == castironUserId) {
            return;
        }

		// Build the list of Campaigns that need to be checked.
        List<String> campNameList = new List<String>();     
        for(Campaign newCamp : newCampaigns) {
        	
        	// Ignore non-group Campaigns
            if(newCamp.RecordTypeId != groupsTypeId) {
            	
            	// This should only happen on an insert, right?
                if(oldCampaigns != null) {
                	
                	// Find the campaign in the trigger.old
                    Campaign oldCamp = oldCampaigns.get(newCamp.Id);
                    if(oldCamp != null) {
                    	
                    	// If the Campaign Name has changed
                        if(oldCamp.Name != newCamp.Name) {
                            campNameList.add(newCamp.Name);
                        }
                    }
                }
                else {
                	
                	// All inserts get added
                    campNameList.add(newCamp.Name);
                }
            }
        }
        
        // Build a list of relevant existing Campaigns, by external id
        List<Campaign> existingNamesList = new List<Campaign>([
            select External_Id__c from Campaign where External_Id__c in :campNameList
        ]);
        Set<String> existingNames = new Set<String>();
        for(Campaign camp : existingNamesList) {
            existingNames.add(camp.External_Id__c);
        }
        
        // Step through the trigger
        for(Campaign camp : newCampaigns) {
        	
        	// Ignore non-group Campaigns
        	// VB: Additional temporary exception for Campaigns converted from Convio
            if((camp.RecordTypeId != groupsTypeId) && camp.Converted_From_Convio__c == false) {
            	
            	// Throw an error if the Campaign Name is already in use.
                if(existingNames.contains(camp.Name)) {
                    camp.Name.addError('Campaign already exists');
                }
                else {
                	
                	// Copy the Name over to the External Id
                    camp.External_ID__c = camp.Name;
                }
            }
        }
    }

	//
    // Recalculate the Total Actions counter for the given campaigns
    //
    public void recalculateTotal(Set<Id> campaignIds) {

		// Step though each of the Campaigns		
		for (Id theId : campaignIds) {

			//Campaign tempCamp = new Campaign(
			//		Id = theId,
			//		Advocacy_Action_Count__c  = 0
			//		);

			// Create a Map of All Campaigns with empty counts
			campaignsToUpdateMap.put(theId,
					new Campaign(
						Id = theId,
						Advocacy_Action_Count_Dirty__c = true,		// set the 'dirty' count flag.
						Advocacy_Action_Count__c = 0
					));
		}
		

		// Grab all of the Advocacy Actions for the list of Campaigns, ordered by Related Action
		List<kweos__EOCS_Data__c> aaList = new List<kweos__EOCS_Data__c>([
			SELECT Id, kwac__Related_Action__c 
				FROM kweos__EOCS_Data__c
				WHERE kwac__Related_Action__c IN :campaignIds
				ORDER BY kwac__Related_Action__c]
		);
		
		// Build a map of the Campaign IDs and their Related Convio Action Counts
		for(Campaign convioCampaign :[SELECT Id, Related_Convio_Action__r.Advocacy_Action_Count__c
										FROM Campaign
										WHERE Id IN :campaignIds]) {

			// If there is a Count on the related convio action Campaign
			if(convioCampaign.Related_Convio_Action__r != null) {
				
				if(convioCampaign.Related_Convio_Action__r.Advocacy_Action_Count__c != null) {
				
					// Save off the Convio Action count, under the parent's campaign					
					relatedConvioActionCounts.put(convioCampaign.Id,convioCampaign.Related_Convio_Action__r.Advocacy_Action_Count__c.intValue());
				} else {
					relatedConvioActionCounts.put(convioCampaign.Id,0);
				}
			}
		}
		
		
		Id lastRelatedActionCampaignId = null;
		
		// Step through the list of Advocacy Actions
		for(kweos__EOCS_Data__c theAA : aaList) {
			
			// Starting the loop, initialize the last related action Id 
			if(lastRelatedActionCampaignId == null) {
				lastRelatedActionCampaignId = theAA.kwac__Related_Action__c;
			}

			// If we start processing a new Campaign
			if(lastRelatedActionCampaignId != theAA.kwac__Related_Action__c) {
				
				// First process the last Related Action
				processRelatedActionBreak(lastRelatedActionCampaignId);
				
				// Then update the last Related Action to the current one
				lastRelatedActionCampaignId = theAA.kwac__Related_Action__c;
			}
			
			// Increment the counter
			totalAdvocacyActionCount += 1;
		}

		// As long as we counted at least one Related Action
		if(lastRelatedActionCampaignId != null) {

			// Now process the last Related Action
			processRelatedActionBreak(lastRelatedActionCampaignId);
		}
		
		// Update all Campaigns in the map, since some may need to be zeroed out.
		update campaignsToUpdateMap.values();
    }

	//
	// Places the current count ( along with the Convio offset ) into the Campaign
	//		and resets the Advocacy Action counter 
	//
	private void processRelatedActionBreak(Id relatedActionId) {
		
		// If there is a value for the Related Vonvio Action Count
		if(relatedConvioActionCounts.containsKey(relatedActionId)) {

			// The total is the combined value of the count and the value of the related Convio Actions total				
			campaignsToUpdateMap.get(relatedActionId).Advocacy_Action_Count__c = 
					totalAdvocacyActionCount + relatedConvioActionCounts.get(relatedActionId); 
				
		} else {

			// Update the map with the total count
			campaignsToUpdateMap.get(relatedActionId).Advocacy_Action_Count__c = totalAdvocacyActionCount;
		}

		// Reset the current Advocacy Action counter back to zero		
		totalAdvocacyActionCount = 0;
	}
}