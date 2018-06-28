/*********************************************************************************************************
Name			: ContactAfterInsertHandler
Created By		: Vernon Baas
Created Date	: June 18, 2015
Description		: Handler for ContactAfterInsertTrigger ( at least part of it )
Updated			: 2014/06/24 VB: Updated with Static RecordType lookups
				: 2015/08/05 VB: Added static non-SOQL record type lookup 
***********************************************************************************************************/

public with sharing class ContactAfterInsertHandler {
	
	// Look up the Cast Iron & BSD info as statics    
    static Id castIronUserId;
    static Id bsdProfile;
    static {
        castIronUserId = UserLookup.getId('ciron');
        for(Profile prof : [Select Id From Profile Where Name = 'BSD User' Limit 1]) {
          bsdProfile = prof.Id;
        }
    }

	/*
    private static String GeneralPreferenceRecordType;

    //fetch Account and Contact record type with name 'Houshold'
    private static void recordTypes(){
        for(RecordType RT: [SELECT ID,SobjectType 
        						FROM RecordType 
        						WHERE SobjectType='rC_Bios__Preference__c' AND NAME='General']){
            if(RT.SobjectType == 'rC_Bios__Preference__c' ){
                GeneralPreferenceRecordType = RT.Id;
            }
        }
    }
	*/
    static String GeneralPreferenceRecordType;
	static {
		GeneralPreferenceRecordType = Schema.SObjectType.rC_Bios__Preference__c.getRecordTypeInfosByName().get('Club-wide').getRecordTypeId();
	}

    
    //This method will be fired after Contacts get inserted.
    public void OnAfterInsert(List<Contact> newList) {
        designateSierraRiseContact(newList);
    }
    
    // Set the User as a SierraRise contact and create appropriate preferences
    private void designateSierraRiseContact(List<Contact> newList){

		//recordTypes();
    	
    	// Build a list of all of the Contact's Original_Campaign__c
    	Set<Id> SierraRiseCampaignIds = new Set<Id>();
    	for (Contact newContact : newList) {
    		SierraRiseCampaignIds.add(newContact.Original_Campaign__c);
    	}
    	
    	// Look up which of those Campaigns qualify as SierraRise. and only save the SR campaigns 
		Map<Id, Campaign> SierraRiseCampaigns = new Map<Id, Campaign>(
					[SELECT Id, SierraRise_Campaign__c 
							FROM Campaign 
							WHERE Id in :SierraRiseCampaignIds
							AND SierraRise_Campaign__c = true]);

    	// Best variable name EVAR!
    	Set<Id> contactsToAddSierraRisePreferencesForIds = new Set<Id>();
    	
    	// Now check each Contact in the trigger and see if their Source/Original Campaign is a SierraRise one.
    	for (Contact newContact : newList) {
    		
    		// If the Contact's Original Campaign is one of the SierraRise campaigns
    		if(SierraRiseCampaigns.containsKey(newContact.Original_Campaign__c)) {
    			
    			// Save off the Contact ID so we can create the SierraRise preference
            	contactsToAddSierraRisePreferencesForIds.add(newContact.Id);
        	}
    	}
		
		// Now we start building the new preferences
		List<rC_Bios__Preference__c> newSierraRisePreferences = new List<rC_Bios__Preference__c>();

		// Step through the trigger again ( since we need the Account from the Contact and don't want to look it up )
		for (Contact thisContact : newList) {

			// If the Contact did qualify
			if(contactsToAddSierraRisePreferencesForIds.contains(thisContact.Id)) {

				// Create the new Preference			
				rC_Bios__Preference__c newPreference = new rC_Bios__Preference__c(
					rC_Bios__Account__c = thisContact.AccountId,
					rC_Bios__Contact__c = thisContact.Id,
					RecordTypeId = GeneralPreferenceRecordType,
					rC_Bios__Category__c = 'Email Subscription',		// 7/24/15: Populate by Value failed
					rC_Bios__Subcategory__c = 'SierraRise All',			// 7/24/15: Populate by Value failed
					rC_Bios__Value__c = 'SIERRARISE',
					rC_Bios__Active__c = true);

				// Save off the new Preference					
				newSierraRisePreferences.add(newPreference);
			}			
		}

		// Insert the new Preferences
		if(newSierraRisePreferences.size() > 0) {
		    insert newSierraRisePreferences;
		}
    	
    	
    }
    
	

}