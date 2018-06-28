// **************************************************************************
// batchCampaignAATotals								(c) 2015 Sierra Club
//
//	Processes the recalculation of the Advocacy Action totals 
//			batchCampaignAATotalsSchedulable.  This class performs the 
//			recalculation of the stuff stuff to e recalculated.  This class 
//			is called nightly to recalcuate 
//
//	2015/09/14		VB		Original ()
//	2015/09/14		VB		Modified Added 'after' clauses on update & delete, 
//								so totals could be calculated correctly.
//	2015/09/18		VB		Convio Counts are now correctly added in the 
//								finish method.
//	2015/10/08		VB		Bug fix, can't depend on existence of Advocacy
//								action.  Build list of Campaigns to update
//								based upon dirty flag, not on an existing
//								Advocacy Action on a dirty campaign.
//	2016/07/26		VB		Two changes, one is the inclusion of the new
//								offset value to add to the total.  The second
//								is a check for an aborted process and not 
//								update the values in the finish method.
// **************************************************************************
global class batchCampaignAATotals implements Database.Batchable<sObject>, Database.Stateful{

	global Integer totalAdvocacyActionCount = 0;
	global Map<Id,Campaign> campaignsToUpdateMap = new Map<Id,Campaign>();
	global Map<Id,Integer> relatedConvioActionCounts = new Map<Id,Integer>();
	global boolean notAborted;		// This value only gets set when the batch completes. 

    global final String theQuery;

    global batchCampaignAATotals(String q){
        theQuery = q;
        notAborted = false;	// Initialize to false
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(theQuery);
    }

    global void execute(Database.BatchableContext BC,List<kweos__EOCS_Data__c> scope){
    	
    	// Need to be able to iterate through the affected Campaigns
    	Set<Id> campaignIds = new Set<Id>();

		// Build the list of Campaigns to be updated manually here,
		//		can't trust that there will actually be an Advocacy Action
		//		for the campaign.  It might have none.  ( sigh )
		for(Campaign dirtyCampaign :[SELECT Id, Related_Convio_Action__r.Advocacy_Action_Count__c, Advocacy_Action_Count_Offset__c
										FROM Campaign
										WHERE Advocacy_Action_Count_Dirty__c = true]) {
		//for(Campaign dirtyCampaign :[theQueryB]) {
											
			// If the Campaign Map doesn't already contact the current AA's Related Action Campaign
			if(!campaignsToUpdateMap.containsKey(dirtyCampaign.Id)) {
				
				//System.debug('Campaign to Map:' + dirtyCampaign.kwac__Related_Action__c);
				
				// Add it to the Campaign Map
				//		Start the counter at Zero
				//		Reset the Campaign Dirty flag back.
				campaignsToUpdateMap.put(dirtyCampaign.Id,
					new Campaign(
						Id = dirtyCampaign.Id,
						Advocacy_Action_Count_Dirty__c = false,		// reset the 'dirty' count flag.
						Advocacy_Action_Count__c = 0,
						Advocacy_Action_Count_Offset__c = dirtyCampaign.Advocacy_Action_Count_Offset__c	// The Current offset
					));
					
				// Also save the Campaign Id into a Set
				campaignIds.add(dirtyCampaign.Id);
			}
		}

		//
		// Any Campaign can have an optionally defined "Related Convio Action"
		//		The Advocacy Action count of the Convio Camapgin is added to the related Campaign's total
		//
		// Build a map of the Campaign IDs and their Related Convio Action Counts
		for(Campaign convioCampaign :[SELECT Id, Related_Convio_Action__r.Advocacy_Action_Count__c
										FROM Campaign
										WHERE Id IN :campaignIds]) {

			// If there is a defined related convio action Campaign
			if(convioCampaign.Related_Convio_Action__r != null) {
				
				// If there is a defined  Count on the convio action Campaign 
				if(convioCampaign.Related_Convio_Action__r.Advocacy_Action_Count__c != null) {
				
					// Save off the Convio Action count, under the parent's campaign ID
					//  NOTE: Saying that again, it's not the Related Convio Campaign's ID,
					//		but the Campaign that has the Related Convio Campaign referenced 					
					relatedConvioActionCounts.put(convioCampaign.Id,convioCampaign.Related_Convio_Action__r.Advocacy_Action_Count__c.intValue());
				} else {
					relatedConvioActionCounts.put(convioCampaign.Id,0);
				}
			}
		}

		Id lastRelatedActionCampaignId = null;
		
		// Step through the list of Advocacy Actions
		for(kweos__EOCS_Data__c theAA : scope) {
			
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

			//System.debug('Last AA/Campaign to process');

			// Now process the last Related Action
			processRelatedActionBreak(lastRelatedActionCampaignId);
		}

        // This appears to be unnecessarily updating the list of Campaigns
        //update campaignsToUpdateMap.values();

		// Now that we've finished processing, we can be fairly sure the user didn't aboard the process
        notAborted = true;

    }

	//
	// Places the current count ( along with the Convio offset ) into the Campaign
	//		and resets the Advocacy Action counter 
	//
	private void processRelatedActionBreak(Id relatedActionId) {
		
		//System.debug('relatedActionId:' + relatedActionId);
		//System.debug('totalAdvocacyActionCount:' + totalAdvocacyActionCount);
		//System.debug('campaignsToUpdateMap:' + campaignsToUpdateMap);
		//System.debug('campaignsToUpdateMap.get(relatedActionId):' + campaignsToUpdateMap.get(relatedActionId));
		//System.debug('relatedActionId.Count:' + campaignsToUpdateMap.get(relatedActionId).Advocacy_Action_Count__c );

		// Update the map with the total count.
		//		In most instances, this will be the subtotal from the current batch of 200 records
		campaignsToUpdateMap.get(relatedActionId).Advocacy_Action_Count__c += totalAdvocacyActionCount;

		// Reset the current Advocacy Action counter back to zero		
		totalAdvocacyActionCount = 0;
	}

	//
	// Once All batches are processed
	//
    global void finish(Database.BatchableContext BC){

		// This should only happen if the user hasn't aboarted the batch
		//		When aborted, this code would update the unprocessed 
		//		campaigns with blank values.
		//		
		if (notAborted) {

			// Step through the map and add in the Related Convio Action Counts.
			for (Campaign theCampaign : campaignsToUpdateMap.values()){
	
				// If there is a value for the Related Convio Action Count
				if(relatedConvioActionCounts.containsKey(theCampaign.Id)) {
		
					// The total is the combined value of the count 
					//		and the value of the related Convio Actions total				
					campaignsToUpdateMap.get(theCampaign.Id).Advocacy_Action_Count__c += 
							relatedConvioActionCounts.get(theCampaign.Id); 
				}
				
				// Add the offset value to the total, if there's an offset.
				if(theCampaign.Advocacy_Action_Count_Offset__c != null && theCampaign.Advocacy_Action_Count_Offset__c > 0) {
					campaignsToUpdateMap.get(theCampaign.Id).Advocacy_Action_Count__c += 
							theCampaign.Advocacy_Action_Count_Offset__c; 
					
				}
						
			}

	        // Now update the Campaigns with Related Convio Actions with the additional totals 
    	    update campaignsToUpdateMap.values();
			
		}

    }
}