/*********************************************************************************************************
(c) 2015 Sierra Club
Name			: AdvocacyActionTriggerHandler
Created by		: Vernon Baas
Created Date	: June 29, 2015
Description		: Handler Class for AdvocacyActionTrigger
Update			: 2015/06/24 - VB - Updated with Static RecordType lookups
				: 2015/08/05 - VB - Added static non-SOQL record type lookup 
				: 2015/08/17 - VB - Added processCountAfter method to support
				:		counts of Advocacy Actions on Campaigns 
				: 2016/11/15 - VB - Adding processMarkDirtyAfter method that no 
				:		longer tries to increment count, but will mark a Campaign
				:		as dirty, so the nightly batch process will re-calculate
				:		count totals
***********************************************************************************************************/
public with sharing class AdvocacyActionTriggerHandler {

	// On Insert
	//		If Contact populated,
	//			then process
	// 
	// On BEFORE Update:
	//		If Contact.old != Contact.new ?
	//			Process Old Contact
	//		Process New Contact
	//
	// On Delete
	//		Reprocess Contact

	/*
    private static String GeneralPreferenceRecordType;
    private static void recordTypes(){
        for(RecordType RT: [SELECT ID,SobjectType 
        						FROM RecordType 
        						WHERE SobjectType='rC_Bios__Preference__c' AND NAME='General']){
            if(RT.SobjectType == 'rC_Bios__Preference__c' ){
                GeneralPreferenceRecordType = RT.ID;
            }
        }
    }
	*/
	
	Map<Id,Integer> campaignIncrementMap = new Map<Id,Integer>(); 
	Map<Id,Integer> campaignDecrementMap = new Map<Id,Integer>(); 

	
    static String GeneralPreferenceRecordType;
	static {
		GeneralPreferenceRecordType = Schema.SObjectType.rC_Bios__Preference__c.getRecordTypeInfosByName().get('Club-wide').getRecordTypeId();
	}

	
	//process(trigger.new,trigger.old,
	//							trigger.isBefore,trigger.isAfter,
	//							trigger.isInsert,trigger.isUpdate,trigger.isDelete,trigger.isUnDelete);
	//public static void AfterInsert(List<rC_Bios__Preference__c> listPreference){
	public void process(List<kweos__EOCS_Data__c> newList, List<kweos__EOCS_Data__c> oldList,
								Map<Id,kweos__EOCS_Data__c> newMap, Map<Id,kweos__EOCS_Data__c> oldMap,
								boolean isBefore,boolean isAfter,
								boolean isInsert,boolean isUpdate,boolean isDelete,boolean isUnDelete) {

		System.debug('AdvocacyActionTriggerHandler:START');

		//Initialize the lists, in case they were passed in as null.
		if(oldList == null) {
			oldList = new List<kweos__EOCS_Data__c>();
		}
		if(oldMap == null) {
			oldMap = new Map<Id,kweos__EOCS_Data__c>();
		}
		if(newList == null) {
			newList = new List<kweos__EOCS_Data__c>();
		}
		if(newMap == null) {
			newMap = new Map<Id,kweos__EOCS_Data__c>();
		}
		

		// Preprocess the lists only looking for SierraRise AdvocacyActions?
		List<kweos__EOCS_Data__c> newSRList = new List<kweos__EOCS_Data__c>(); 
		List<kweos__EOCS_Data__c> oldSRList = new List<kweos__EOCS_Data__c>();
		
		// List of affected Campaigns that need to have Advocacy Action totals recalculated
		//List<Campaign> campaignList = new List<Campaign>();
		Set<Id> campaignIds = new Set<Id>();
		
		// Step though the new Trigger list, only saving the SierraRise Actions
		for(kweos__EOCS_Data__c theAA : newList) {
		
			// If the Advocacy Action's Related Action has a SierraRise promo code
			//if(theAA.kwac__Source_Campaign__r.SierraRise_Campaign__c ) {
			//if(theAA.kwac__Related_Action__r.SierraRise_Campaign__c ) {
			if(theAA.SierraRise_Action__c ) {
				
				newSRList.add(theAA);
				System.debug('NewAction:' + theAA.Id + ':');
			}
		}
		 
		// Step though the old Trigger list, only saving the SierraRise Actions
		for(kweos__EOCS_Data__c theAA : oldList) {
		
			// If the Advocacy Action's Related Action has a SierraRise promo code
			//if(theAA.kwac__Source_Campaign__r.SierraRise_Campaign__c ) {
			//if(theAA.kwac__Related_Action__r.SierraRise_Campaign__c ) {
			if(theAA.SierraRise_Action__c ) {

				oldSRList.add(theAA);
				System.debug('OldAction:' + theAA.Id + ':');
			}
		}

		// List of contacts that will need to be processed. 
		// Find the kwac__Contact__c
		//List<Id> contactsToProcess = new List<Id>();
		
		// Builiding two lists, those who should have their 
		//		SierraRise preference active and those 
		//		  that need to be deactivated
		// 	Note: I used the word 'Confirm' because the process
		//		involves seeing if a preference exists in addition
		//		to seeing if an existing preference is active.
		//		For deletion, all the existing advocacy actions
		//		need to be checked for the contact before the
		//		preference is deactivated.  If they still have
		//		a qualifying advocacy action, the preference
		//		should stay intact.
		List<Id> contactsToConfirmInsert = new List<Id>();  
		List<Id> contactsToConfirmDelete = new List<Id>();

		//System.debug('AA:1');
    	
		if(isInsert) {
			
			System.debug('AA:Insert');
			
			// If the Advocacy Action has a populated Contact
			for(kweos__EOCS_Data__c theAA : newSRList) {

				System.debug('AA:3');
				
				// Then this contact should be added ( if it isn't already )
				if(theAA.kwac__Contact__c != null) {
					
					System.debug('AA:4');
					
	    			//contactsToProcess.add(theAA.kwac__Contact__c);
	    			contactsToConfirmInsert.add(theAA.kwac__Contact__c);
				}
			}
			
		} else if(isUpdate) {

			System.debug('AA:Update');

			// If NEW Advocacy Action has a newly affected Contact
			
			// Step through the Trigger.new AA's
			for(kweos__EOCS_Data__c theAA : newSRList) {
				
				// If the Action is matched to a Contact
				if(theAA.kwac__Contact__c != null) {
					
					// Check the previous value on the Advocacy Action, 
					//		if the value of the Contact has changed, 
					//		then the new contact needs to be activated. 
					if(theAA.kwac__Contact__c != oldMap.get(theAA.Id).kwac__Contact__c) {
		    			contactsToConfirmInsert.add(theAA.kwac__Contact__c);
					}
				}
				System.debug('AA:#:Contact');
			}

			// The OLD Advocacy Action has the affected Contact
			for(kweos__EOCS_Data__c theAA : oldSRList) {
				
				// If the Action is matched to a Contact
				if(theAA.kwac__Contact__c != null) {

					// Check the previous value on the Advocacy Action, 
					//		if the value of the Contact has changed, 
					//		then the new contact needs to be activated. 
					if(theAA.kwac__Contact__c != newMap.get(theAA.Id).kwac__Contact__c) {
		    			contactsToConfirmDelete.add(theAA.kwac__Contact__c);
					}
				}
			}
			
			// Since an batch of updates could potentially include 
			//		both an add and a removal for a single contact,
			//		the add should override a removal.
			// Step through the List of Contacts to insert and remove
			//		any values from the list of deletes
			Integer i = 0;
			Integer j = 0;
			while (i < contactstoConfirmInsert.size()) {
				while (j < contactsToConfirmDelete.size()) {
					
					// VB: Will the get() match when the ID's match?
					if(contactsToConfirmInsert.get(i) == contactsToConfirmDelete.get(j)) {
						contactsToConfirmDelete.remove(j);
					} else {
						j++;
					}
				}
				i++;
			}

		} else if(isDelete) {
			
			System.debug('AA:Delete');
			
			// The OLD Advocacy Action has a populated Contact
			for(kweos__EOCS_Data__c theAA : oldSRList) {
				if(theAA.kwac__Contact__c != null) {
	    			contactsToConfirmDelete.add(theAA.kwac__Contact__c);
				}
			}

			
		} else if(isUnDelete) {
			
			System.debug('AA:UnDelete');
			
			// If undeleted Advocacy Action has the newly affected Contact
			for(kweos__EOCS_Data__c theAA : newSRList) {
				if(theAA.kwac__Contact__c != null) {
	    			contactsToConfirmInsert.add(theAA.kwac__Contact__c);
				}
			}
			
		} else {
			// Error?	
		}
		
		System.debug('AA:ContactsToInsert:' + contactsToConfirmInsert.size());
		System.debug('AA:ContactsToDelete:' + contactsToConfirmDelete.size());
		
		// If there are contacts to be 
		if (contactsToConfirmInsert.size() > 0) {
			processInsertContacts(contactsToConfirmInsert);
		}
		if (contactsToConfirmDelete.size() > 0) {
			processDeleteContacts(contactsToConfirmDelete);
		}
	}

	//
	// Trigger to increment the Advocacy Action Count on the Related Action Campaign
	//
	public void processCountAfter(List<kweos__EOCS_Data__c> newList, List<kweos__EOCS_Data__c> oldList,
								Map<Id,kweos__EOCS_Data__c> newMap, Map<Id,kweos__EOCS_Data__c> oldMap,
								boolean isInsert,boolean isUpdate,boolean isDelete,boolean isUnDelete) {
		System.debug('AdvocacyActionTriggerHandler.processCountAfter:START');
									
		//Initialize the lists, in case they were passed in as null.
		if(oldList == null) {
			oldList = new List<kweos__EOCS_Data__c>();
		}
		if(oldMap == null) {
			oldMap = new Map<Id,kweos__EOCS_Data__c>();
		}
		if(newList == null) {
			newList = new List<kweos__EOCS_Data__c>();
		}
		if(newMap == null) {
			newMap = new Map<Id,kweos__EOCS_Data__c>();
		}

		// List of affected Campaigns that need to have Advocacy Action totals recalculated
		Set<Id> campaignIds = new Set<Id>();
		Set<Id> campaignIncrementIds = new Set<Id>();
		Set<Id> campaignDecrementIds = new Set<Id>();
		Map<Id,Campaign> campaignsToUpdateMap = new Map<Id,Campaign>(); 

		Integer tempCount = 0;

		// Recalculating Advocacy Action counts.
		//		As AA Counts don't care if the action is SierraRise or not, I need to do this on the trigger lists themselves
		//
		if(isInsert) {
			
			System.debug('AA:Insert');
			
			// Step through each of the AA
			for(kweos__EOCS_Data__c theAA : newList) {

				System.debug('AA:3');
				
				// If there is a Related Action campaign 
				if(theAA.kwac__Related_Action__c != null) {

					// Increment the Campaign Advocacy Action counter
					incrementCampaignCountMap(theAA.kwac__Related_Action__c);
				}
			}
			
		} else if(isUpdate) {

			System.debug('AA:Update');

			// If NEW Advocacy Action has a newly affected Contact
			
			// Step through the Trigger.new AA's
			for(kweos__EOCS_Data__c theAA : newList) {
				
				System.debug('AA:#:Contact');

				// Have the AA related action Campaign values been changed ( they could be null ) 
				if(oldMap.get(theAA.Id).kwac__Related_Action__c != newMap.get(theAA.Id).kwac__Related_Action__c) {

					System.debug('AA:#:Diff RelatedAction');
				
					// If there is a defined Related Action on the Campaign
					if(newMap.get(theAA.Id).kwac__Related_Action__c != null) {
						System.debug('AA:#:RelatedAction New:' + newMap.get(theAA.Id).kwac__Related_Action__c);

						// Increment the Campaign Advocacy Action counter
						incrementCampaignCountMap(theAA.kwac__Related_Action__c);
					}
				}
			}

			// The OLD Advocacy Action has the affected Contact
			for(kweos__EOCS_Data__c theAA : oldList) {
				
				// Have the AA related action Campaign values been changed ( they could be null ) 
				if(oldMap.get(theAA.Id).kwac__Related_Action__c != newMap.get(theAA.Id).kwac__Related_Action__c) {
				
					// If the previous AA had a Related Action Campaign value which has now changed.	
					if(oldMap.get(theAA.Id).kwac__Related_Action__c != null) {

						System.debug('AA:#:RelatedAction Old:' + oldMap.get(theAA.Id).kwac__Related_Action__c);
	   					
						// Decrement the Campaign Advocacy Action counter
						decrementCampaignCountMap(theAA.kwac__Related_Action__c);
					}
				}
			}

		} else if(isDelete) {
			
			System.debug('AA:Delete');
			
			// The OLD Advocacy Action has a populated Contact
			for(kweos__EOCS_Data__c theAA : oldList) {

				// Save the related action Campaign, 
				if(theAA.kwac__Related_Action__c != null) {

					// Decrement the Campaign Advocacy Action counter
					decrementCampaignCountMap(theAA.kwac__Related_Action__c);
				}
			}

			
		} else if(isUnDelete) {
			
			System.debug('AA:UnDelete');
			
			// If undeleted Advocacy Action has the newly affected Contact
			for(kweos__EOCS_Data__c theAA : newList) {

				// Save the related action Campaign, 
				if(theAA.kwac__Related_Action__c != null) {

					// Increment the Campaign Advocacy Action counter
					incrementCampaignCountMap(theAA.kwac__Related_Action__c);
				}
			}
			
		} else {
			// Error?	
		}
		
		System.debug('AA:CampaignsToRecalculate:' + campaignIds.size());
		
		// Now look up the Related Convio Actions counts for the affected campaigns		

		// Build the Update map from the keysets of the Campaigns that have been updated
		campaignsToUpdateMap = new Map<Id,Campaign>([SELECT Id,Advocacy_Action_Count__c 
														FROM Campaign
														WHERE Id IN :campaignIncrementMap.keyset()
														   OR Id IN :campaignDecrementMap.keyset()]); 
		
		// Find and update null values
		for(Campaign theCampaign : campaignsToUpdateMap.values()) {
			
			// If the count is null, at least initialize it to Zero
			if (theCampaign.Advocacy_Action_Count__c == null) {
				theCampaign.Advocacy_Action_Count__c = 0;
			}

			// Set the Dirty checkbox to true
			theCampaign.Advocacy_Action_Count_Dirty__c = true;
		}
				
		// Step through the affected campaigns
		for(Campaign theCampaign : campaignsToUpdateMap.values()) {
			
			// Add and Subtract the appropriate values
			if(campaignIncrementMap.containsKey(theCampaign.Id)) {
				theCampaign.Advocacy_Action_Count__c += campaignIncrementMap.get(theCampaign.Id);
			}
			if(campaignDecrementMap.containsKey(theCampaign.Id)) {
				theCampaign.Advocacy_Action_Count__c -= campaignDecrementMap.get(theCampaign.Id);
			}
			
			// In case of a below-zero value somehow, balance it back up to zero
			if (theCampaign.Advocacy_Action_Count__c < 0) {
				theCampaign.Advocacy_Action_Count__c = 0;
			}
		}

		
		// If there are Campaigns to be modified 
		if (campaignsToUpdateMap.size() > 0) {
			
			// Update the campaigns with the new values 
			update campaignsToUpdateMap.values();
		}
		
	}

	//
	// 11/16 - New class to simply mark the Dirty checkbox which will force this Campaign to 
	//		recalculate it's Advocacy Action counts nightly
	//
	public void processMarkDirtyAfter(List<kweos__EOCS_Data__c> newList, List<kweos__EOCS_Data__c> oldList,
								Map<Id,kweos__EOCS_Data__c> newMap, Map<Id,kweos__EOCS_Data__c> oldMap,
								boolean isInsert,boolean isUpdate,boolean isDelete,boolean isUnDelete) {

		System.debug('AdvocacyActionTriggerHandler.processMarkDirtyAfter:START');
									
		//Initialize the lists, in case they were passed in as null.
		if(oldList == null) {
			oldList = new List<kweos__EOCS_Data__c>();
		}
		if(oldMap == null) {
			oldMap = new Map<Id,kweos__EOCS_Data__c>();
		}
		if(newList == null) {
			newList = new List<kweos__EOCS_Data__c>();
		}
		if(newMap == null) {
			newMap = new Map<Id,kweos__EOCS_Data__c>();
		}

		// Affected Campaigns that need to have Advocacy Action totals recalculated
		Set<Id> campaignMarkIds = new Set<Id>();			// Campaigns to mark as dirty
		Map<Id,Campaign> campaignsToUpdateMap = new Map<Id,Campaign>(); 

		// Determining affected Campaigns from the Advocacy Actions
		//
		if(isInsert) {
			
			System.debug('AA:Insert');
			
			// Step through each of the AA
			for(kweos__EOCS_Data__c theAA : newList) {

				//System.debug('AA:3');
				
				// If there is a Related Action campaign 
				if(theAA.kwac__Related_Action__c != null) {

					// Save the Campaign to be marked
	   				campaignMarkIds.add(theAA.kwac__Related_Action__c);
				}
			}
			
		} else if(isUpdate) {

			System.debug('AA:Update');

			// If NEW Advocacy Action has a newly affected Contact
			
			// Step through the Trigger.new AA's
			for(kweos__EOCS_Data__c theAA : newList) {
				
				System.debug('AA:#:Contact');

				// Have the AA related action Campaign values been changed ( they could be null ) 
				if(oldMap.get(theAA.Id).kwac__Related_Action__c != newMap.get(theAA.Id).kwac__Related_Action__c) {

					//System.debug('AA:#:Diff RelatedAction');
				
					// If there is a defined Related Action on the Campaign
					if(newMap.get(theAA.Id).kwac__Related_Action__c != null) {

						//System.debug('AA:#:RelatedAction New:' + newMap.get(theAA.Id).kwac__Related_Action__c);
		   				campaignMarkIds.add(theAA.kwac__Related_Action__c);
					}
				}
			}

			// The OLD Advocacy Action has the affected Contact
			for(kweos__EOCS_Data__c theAA : oldList) {
				
				// Have the AA related action Campaign values been changed ( they could be null ) 
				if(oldMap.get(theAA.Id).kwac__Related_Action__c != newMap.get(theAA.Id).kwac__Related_Action__c) {
				
					// If the previous AA had a Related Action Campaign value which has now changed.	
					if(oldMap.get(theAA.Id).kwac__Related_Action__c != null) {

						//System.debug('AA:#:RelatedAction Old:' + oldMap.get(theAA.Id).kwac__Related_Action__c);
		   				campaignMarkIds.add(theAA.kwac__Related_Action__c);
					}
				}
			}

		} else if(isDelete) {
			
			System.debug('AA:Delete');
			
			// The OLD Advocacy Action has a populated Contact
			for(kweos__EOCS_Data__c theAA : oldList) {

				// Save the related action Campaign 
				if(theAA.kwac__Related_Action__c != null) {
	   				campaignMarkIds.add(theAA.kwac__Related_Action__c);
				}
			}

			
		} else if(isUnDelete) {
			
			System.debug('AA:UnDelete');
			
			// If undeleted Advocacy Action has the newly affected Contact
			for(kweos__EOCS_Data__c theAA : newList) {

				// Save the related action Campaign 
				if(theAA.kwac__Related_Action__c != null) {
	   				campaignMarkIds.add(theAA.kwac__Related_Action__c);
				}
			}
			
		} else {
			// Error?	
		}
		
		System.debug('AA:CampaignsToMark:' + campaignMarkIds.size());
		

		// Build the Update map from the keysets of the Campaigns that have been updated
		//		Only grab Campaigns that are not already marked as dirty. 
		campaignsToUpdateMap = new Map<Id,Campaign>([SELECT Id, Advocacy_Action_Count_Dirty__c 
														FROM Campaign
														WHERE Id IN :campaignMarkIds
														  AND Advocacy_Action_Count_Dirty__c = false]); 
		
		// Set the Campaign as dirty
		for(Campaign theCampaign : campaignsToUpdateMap.values()) {
			
			// Set the Dirty checkbox to true
			theCampaign.Advocacy_Action_Count_Dirty__c = true;
		}
				
		
		// If there are Campaigns to be modified 
		if (campaignsToUpdateMap.size() > 0) {
			
			// Update the campaigns with the new values 
			update campaignsToUpdateMap.values();
		}
		
	}

	public void processAfter(List<kweos__EOCS_Data__c> newList, List<kweos__EOCS_Data__c> oldList,
								Map<Id,kweos__EOCS_Data__c> newMap, Map<Id,kweos__EOCS_Data__c> oldMap,
								boolean isInsert,boolean isUpdate,boolean isDelete,boolean isUnDelete) {

		System.debug('AdvocacyActionTriggerHandler.processAfter:START');

		//Initialize the lists, in case they were passed in as null.
		if(oldList == null) {
			oldList = new List<kweos__EOCS_Data__c>();
		}
		if(oldMap == null) {
			oldMap = new Map<Id,kweos__EOCS_Data__c>();
		}
		if(newList == null) {
			newList = new List<kweos__EOCS_Data__c>();
		}
		if(newMap == null) {
			newMap = new Map<Id,kweos__EOCS_Data__c>();
		}
		

		// List of affected Campaigns that need to have Advocacy Action totals recalculated
		Set<Id> campaignIds = new Set<Id>();
		
		// Recalculating Advocacy Action counts.
		//		As AA Counts don't care if the action is SierraRise or not, I need to do this on the trigger lists themselves
		//
		if(isInsert) {
			
			System.debug('AA:Insert');
			
			// If the Advocacy Action has a populated Contact
			for(kweos__EOCS_Data__c theAA : newList) {

				System.debug('AA:3');
				
				// Save the related action Campaign, 
				if(theAA.kwac__Related_Action__c != null) {
	   				campaignIds.add(theAA.kwac__Related_Action__c);
				}
			}
			
		} else if(isUpdate) {

			System.debug('AA:Update');

			// If NEW Advocacy Action has a newly affected Contact
			
			// Step through the Trigger.new AA's
			for(kweos__EOCS_Data__c theAA : newList) {
				
				System.debug('AA:#:Contact');

				// Have the AA related action Campaign values been changed ( they could be null ) 
				if(oldMap.get(theAA.Id).kwac__Related_Action__c != newMap.get(theAA.Id).kwac__Related_Action__c) {

					System.debug('AA:#:Diff RelatedAction');
				
					// Save off the non-null Campaigns	
					if(oldMap.get(theAA.Id).kwac__Related_Action__c != null) {
						System.debug('AA:#:RelatedAction Old:' + oldMap.get(theAA.Id).kwac__Related_Action__c);
	   					campaignIds.add(oldMap.get(theAA.Id).kwac__Related_Action__c);
					}
					if(newMap.get(theAA.Id).kwac__Related_Action__c != null) {
						System.debug('AA:#:RelatedAction New:' + newMap.get(theAA.Id).kwac__Related_Action__c);
		   				campaignIds.add(newMap.get(theAA.Id).kwac__Related_Action__c);
					}
				}
			}

			// The OLD Advocacy Action has the affected Contact
			for(kweos__EOCS_Data__c theAA : oldList) {
				
				// Have the AA related action Campaign values been changed ( they could be null ) 
				if(oldMap.get(theAA.Id).kwac__Related_Action__c != newMap.get(theAA.Id).kwac__Related_Action__c) {
				
					// Save off the non-null Campaigns	
					if(oldMap.get(theAA.Id).kwac__Related_Action__c != null) {
	   					campaignIds.add(oldMap.get(theAA.Id).kwac__Related_Action__c);
					}
					if(newMap.get(theAA.Id).kwac__Related_Action__c != null) {
		   				campaignIds.add(newMap.get(theAA.Id).kwac__Related_Action__c);
					}
				}
			}

		} else if(isDelete) {
			
			System.debug('AA:Delete');
			
			// The OLD Advocacy Action has a populated Contact
			for(kweos__EOCS_Data__c theAA : oldList) {

				// Save the related action Campaign, 
				if(theAA.kwac__Related_Action__c != null) {
	   				campaignIds.add(theAA.kwac__Related_Action__c);
				}
			}

			
		} else if(isUnDelete) {
			
			System.debug('AA:UnDelete');
			
			// If undeleted Advocacy Action has the newly affected Contact
			for(kweos__EOCS_Data__c theAA : newList) {

				// Save the related action Campaign, 
				if(theAA.kwac__Related_Action__c != null) {
	   				campaignIds.add(theAA.kwac__Related_Action__c);
				}
			}
			
		} else {
			// Error?	
		}

		System.debug('AA:CampaignsToRecalculate:' + campaignIds.size());
		

		// Now look up the Related Convio Actions counts for the affected campaigns		
		
		// If there are contacts to be 
		if (campaignIds.size() > 0) {
			// Instantiate the Campaign Trigger Handler and pass the Campaigns to be recalculated 
			CampaignTriggerHandler myCampaignTR = new CampaignTriggerHandler();
			myCampaignTR.recalculateTotal(campaignIds);
		}
									
	}


	// 
	//	Maintains the campaignIncrementMap totals
	//		incrementing the count or putting a new value into the Map
	//
	private void incrementCampaignCountMap(Id theCampaign) {

		Integer tempCount = 0;
	
		// If the Map already contains this Campaign
		if(campaignIncrementMap.containsKey(theCampaign)) {

			// TODO: There MUST be a better way to do this
			tempCount = campaignIncrementMap.get(theCampaign);
			tempCount++;
			campaignIncrementMap.put(theCampaign,tempCount);
						
		} else {
						
			// Initialize the Counter to 1
			campaignIncrementMap.put(theCampaign,1);
		}
	}

	// 
	//	Maintains the campaignIncrementMap totals
	//		decrementing the count or putting a new value into the Map
	//
	private void decrementCampaignCountMap(Id theCampaignId) {

		Integer tempCount = 0;

		// If the Map already contains this Campaign
		if(campaignIncrementMap.containsKey(theCampaignId)) {
	
			// TODO: There MUST be a better way to do this
			tempCount = campaignIncrementMap.get(theCampaignId);
			tempCount--;
			campaignDecrementMap.put(theCampaignId,tempCount);
							
		} else {
							
			// Initialize the Counter to -1? 
			// NOTE: I'm handling the bizarre world where a Campaign has all 
			//		 of it's actions removed, added back in, and then  
			//		somehow removed again as part of a single batch.  Then 
			//		we process all of the removes before the adds get  
			//		processed.  Please don't judge me.
			campaignIncrementMap.put(theCampaignId,-1);
		}
	}


	// Given a list of Contacts:
	//		Looks up existing preferences and determines if an existing preference simply needs to be updated
	//		or if a new preference needs to be created and inserted.	
	public void processInsertContacts(List<Id> theContactsToProcess) {

		// Holder of preferences to be inserted
		// Now we start building the new preferences
		//List<kweos__EOCS_Data__c> newPreferences = new List<kweos__EOCS_Data__c>(); 
		List<rC_Bios__Preference__c> newSierraRisePreferences = new List<rC_Bios__Preference__c>();

		// Holder of preferences to be updated ( made active )
		List<rC_Bios__Preference__c> updatedSierraRisePreferences = new List<rC_Bios__Preference__c>();

		// Build a Map of existing SierrRise preferences for these Contacts by
		// 	looking up all of the SR Preferences for the Contacts passed-in.
		Map<Id, rC_Bios__Preference__c> existingPreferences = new Map<Id, rC_Bios__Preference__c>(
				[SELECT Id, rC_Bios__Account__c, rC_Bios__Contact__c, rC_Bios__Active__c, rC_Bios__Category__c, rC_Bios__Subcategory__c
					FROM rC_Bios__Preference__c 
					WHERE rC_Bios__Category__c = 'Email Subscription'
						AND rC_Bios__Subcategory__c = 'SierraRise All'
						AND	rC_Bios__Contact__c IN :theContactsToProcess]);

		System.debug('AA: ExistingPreferences Size:' + existingPreferences.size() );
		

		// Did we find the preference for this contact?
		Boolean preferenceFound = false; 

		// Loop through the List of Contacts
		for (Contact thisContact : [SELECT Id, AccountId FROM Contact WHERE Id IN :theContactsToProcess]) {

			System.debug('AA: Contact:' + thisContact.Id + ':' );


			// Set/reset the value for this contact to false
			preferenceFound = false; 

			// This feels very ineffecient, especially for large volumnes.
			//		Would rather have a searchable list, but the key is the ID of the preference
			//		versus the key of the contact.
			// WARNING:  No duplicate testing, which could/should also be done here.
			//
			// Step through all of the SR preferences we found
			//for (rC_Bios__Preference__c thePreference : existingPreferences) {
			for (rC_Bios__Preference__c thePreference : existingPreferences.values()) {

				System.debug('AA: Contact:' + thisContact.Id + ':' + ' Preference Contact:' + thePreference.rC_Bios__Contact__c + ':' );

				// If the contact has an existing SierraRise All preference
				//if(thePreference.rC_Bios__Contact__c == thisContact.Id ) {
				if(thePreference.rC_Bios__Contact__c == thisContact.Id ) {

					System.debug('AA: Preference Found!!!!!' );

					// record that we found the preference for this Contact
					preferenceFound = true;
					
					// If the existing preference is inactive
					if(!thePreference.rC_Bios__Active__c) {

						System.debug('AA: Preference Found: Activate' );
						
						// Set the preference to active
						thePreference.rC_Bios__Active__c = true;
						
						// Add it to the list of preferences to be updated
						updatedSierraRisePreferences.add(thePreference);
						
					} else {  // else // the preference exists and is active, so leave it alone.

						System.debug('AA: Preference Found: Already Active' );

						// This would happen if this is the second, third, etc SierraRise Advocacy action
						//  this contact has taken.						
					}
				}
			}
			
			// If no SR preference was found for this contact,
			if (!preferenceFound) {

				System.debug('AA: No Preference Found. Insert' );
				
				// Create a new preference for this contact.
				// Add the Preference to be inserted
				rC_Bios__Preference__c newPreference = new rC_Bios__Preference__c(
					//rC_Bios__Account__c = thisContact.AccountId,
					rC_Bios__Contact__c = thisContact.Id,
					RecordTypeId = GeneralPreferenceRecordType,
					rC_Bios__Category__c = 'Email Subscription',		// 7/24/15: Populate by Value failed
					rC_Bios__Subcategory__c = 'SierraRise All',			// 7/24/15: Populate by Value failed
					rC_Bios__Code_Value__c = 'SIERRARISE',
					//rC_Bios__Value__c = 'SIERRARISE',
					rC_Bios__Affiliation__c = '',
					rC_Bios__Active__c = true);
				
				// Save off the new Preference					
				newSierraRisePreferences.add(newPreference);
			}
		}

		// Insert the new Preferences
		if(newSierraRisePreferences.size() > 0) {
			System.debug('AA:INSERT PREFERENCE:' + newSierraRisePreferences.size());
		    insert newSierraRisePreferences;
		}

		// Updated the Preferences that need to be activated
		if(updatedSierraRisePreferences.size() > 0) {
			System.debug('AA:UPDATE PREFERENCE' + updatedSierraRisePreferences.size());
		    update updatedSierraRisePreferences;
		}
	}
	
	
	// Given a list of Contacts:
	//		Looks up existing preferences and determines if an existing preference simply needs to be updated ( deactivated )
	//		simpler than the above insert, since if the preference doesn't exist, then no need to insert/update/delete	
	public void processDeleteContacts(List<Id> theContactsToProcess) {

		// Holder of preferences to be updated ( made Inactive )
		List<rC_Bios__Preference__c> updatedSierraRisePreferences = new List<rC_Bios__Preference__c>();

		// Build a Map of existing SierrRise preferences for these Contacts by
		//	looking up all of the SR Preferences for the Contacts passed-in.
		Map<Id, rC_Bios__Preference__c> existingPreferences = new Map<Id, rC_Bios__Preference__c>(
				[SELECT Id, rC_Bios__Account__c, rC_Bios__Contact__c, rC_Bios__Active__c, rC_Bios__Category__c, rC_Bios__Subcategory__c
					FROM rC_Bios__Preference__c 
					WHERE rC_Bios__Category__c = 'Email Subscription'
						AND rC_Bios__Subcategory__c = 'SierraRise All'
						AND	rC_Bios__Contact__c IN :theContactsToProcess]);

		
		// Loop through the List of Contacts
		for (Contact thisContact : [SELECT Id, AccountId FROM Contact WHERE Id IN :theContactsToProcess]) {

			// This feels very ineffecient, especially for large volumnes.
			//		Would rather have a searchable list, but the key is the ID of the preference
			//		versus the key of the contact.
			// WARNING:  No duplicate testing, which could/should also be done here.
			//
			// Step through all of the SR preferences we found
			//for (rC_Bios__Preference__c thePreference : existingPreferences) {
			for (rC_Bios__Preference__c thePreference : existingPreferences.values()) {

				
				// If the contact has an existing preference
				if(thePreference.rC_Bios__Contact__c == thisContact.Id ) {

					// If the existing preference is active
					if(thePreference.rC_Bios__Active__c) {
						
						// Set the preference to inactive
						thePreference.rC_Bios__Active__c = false;
						
						// Add it to the list of preferences to be updated
						updatedSierraRisePreferences.add(thePreference);
					}
				}
			}
			
		}

		// Updated the Preferences that need to be daactivated
		if(updatedSierraRisePreferences.size() > 0) {
		    update updatedSierraRisePreferences;
		}
	}

	// Given a list of Contacts:
	//		Looks up existing preferences and determines if an existing preference simply needs to be updated ( deactivated )
	//		simpler than the above insert, since if the preference doesn't exist, then no need to insert/update/delete	
	public void processDeleteSierraRiseExclusiveContacts(List<Id> theContactsToProcess) {

		// Holder of preferences to be updated ( made Inactive )
		List<rC_Bios__Preference__c> updatedSierraRisePreferences = new List<rC_Bios__Preference__c>();

		// Build a Map of existing SierrRise preferences for these Contacts by
		//	looking up all of the SR Preferences for the Contacts passed-in.
		Map<Id, rC_Bios__Preference__c> existingPreferences = new Map<Id, rC_Bios__Preference__c>(
				[SELECT Id, rC_Bios__Account__c, rC_Bios__Contact__c, rC_Bios__Active__c, rC_Bios__Category__c, rC_Bios__Subcategory__c
					FROM rC_Bios__Preference__c 
					WHERE rC_Bios__Category__c = 'Classification'
						AND rC_Bios__Subcategory__c = 'SierraRise Exclusive'
						AND	rC_Bios__Contact__c IN :theContactsToProcess]);

		
		// Loop through the List of Contacts
		for (Contact thisContact : [SELECT Id, AccountId FROM Contact WHERE Id IN :theContactsToProcess]) {

			// This feels very ineffecient, especially for large volumnes.
			//		Would rather have a searchable list, but the key is the ID of the preference
			//		versus the key of the contact.
			// WARNING:  No duplicate testing, which could/should also be done here.
			//
			// Step through all of the SR preferences we found
			//for (rC_Bios__Preference__c thePreference : existingPreferences) {
			for (rC_Bios__Preference__c thePreference : existingPreferences.values()) {

				
				// If the contact has an existing preference
				if(thePreference.rC_Bios__Contact__c == thisContact.Id ) {

					// If the existing preference is active
					if(thePreference.rC_Bios__Active__c) {
						
						// Set the preference to inactive
						thePreference.rC_Bios__Active__c = false;
						
						// Add it to the list of preferences to be updated
						updatedSierraRisePreferences.add(thePreference);
					}
				}
			}
			
		}

		// Updated the Preferences that need to be daactivated
		if(updatedSierraRisePreferences.size() > 0) {
		    update updatedSierraRisePreferences;
		}
		
	}


}