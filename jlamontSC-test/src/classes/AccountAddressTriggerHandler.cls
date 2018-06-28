// *********************************************************************************************************
//
// Name              : AddressTriggerHandler
// Created By        : Vernon Baas
// Created Date      : April 17, 2015
// Description       : Trigger handler class for trigger on rC_Bios__Address__c.
// Last Updated      :
//	2016/08/19		Vernon Baas		Added check to see if any ZDM field changes on the Address and then 
//										move all ZDM values to the Account Address.  This is increased
//										from simply checking the USPS Zip & Elected Officials Ids fields.
//
// *********************************************************************************************************
public with sharing class AccountAddressTriggerHandler {
    
    private static final Id castironUserId = UserLookup.getId('ciron');
    public static List<rC_Bios__Account_Address__c> AccountAddressesHoldingVariable;
    
    
    //public void moveZDMInfo(List<rC_Bios__Address__C> newList) {
    public void moveZDMInfo(List<rC_Bios__Account_Address__c> newList) {
        //MoveAddressToAccountAddress(newList);
        AccountAddressesHoldingVariable = newList;
    }
    
    // This method moves populated ZDM Information on the Address object to the corresponding Account Address
    //F:private void MoveAddressToAccountAddress(List<rC_Bios__Address__c> newList){
    //private void MoveAddressToAccountAddress(List<rC_Bios__Account_Address__c> newList){
	public static void MoveAddressToAccountAddress(List<rC_Bios__Account_Address__c> newList){

		// Save off the rC_Bios__Address__c references
    	// List of Form Campaigns we will need to look up the Campaign Asks on.  <bulkifried>
    	Set<Id> addressIDs = new Set<Id>();

		// The list of Address that should be updated
    	//List<rC_Bios__Address__c> addressesToUpdate = new List<rC_Bios__Address__c>();
    	//List<rC_Bios__Account_Address__c> accountAddressesToUpdate = new List<rC_Bios__Account_Address__c>();
    	List<rC_Bios__Account_Address__c> accountAddressesToUpdate = new List<rC_Bios__Account_Address__c>();

		//List<Cases> toUpdate = [SELECT id FROM rC_Bios__Account_Address__c WHERE ID in :addressIDs];

    	// Save the Address
        for(rC_Bios__Account_Address__c aa: newList){


			system.debug('\n');
			system.debug('``````````````````````````````````````````````\n');
			system.debug('STARTAA USPS Zip:' + aa.kwrc__USPS_Zip__c + ':\n');
			system.debug('``````````````````````````````````````````````\n');


			// Save off the Address
			//
			// TODO: Stick a check in here in case it's already in the list?
			//addressIDs.add(a.Id);
			//addressIDs.add(a.rC_Bios__Address__c.Id);
			//addressIDs.add(a.rC_Bios__Address__r.Id);
			addressIDs.add(aa.rC_Bios__Address__c);
        }
		
		// Look up the ZDM information from the Address object
    	//Map<String,rC_Bios__Address__c> addressMap = new Map<String,rC_Bios__Address__c>();
    	Map<String,rC_Bios__Address__c> addressMap = new Map<String,rC_Bios__Address__c>();
    	
    	for (rC_Bios__Address__c theAddress :[
    			SELECT  Id,
    					kwrc__KW_CountyCode__c,
    					kwrc__KW_CountyDistrict__c,
    					kwrc__KW_CountyDistrictDesc__c,
    					kwrc__KW_CountyName__c,
    					kwrc__Elected_Officials_Ids__c,
    					kwrc__KW_Error_Code__c,
    					kwrc__ZTDM_Expiry_Date__c,
    					kwrc__KnowWho_Address_Update__c,
    					kwrc__KWD_Encrypted_Action_Id__c,
    					kwrc__KWD_Last_Processed_DT__c,
    					kwrc__Latitude__c,
    					kwrc__Longitude__c,
    					kwrc__KW_MunicipalCode__c,
    					kwrc__KW_MunicipalDistrict__c,
    					kwrc__KW_MunicipalDistrictDesc__c,
    					kwrc__KW_MunicipalName__c,
    					kwrc__KW_MunicipalType__c,
    					kwrc__PO_Box__c,
    					kwrc__KW_StateHouseDistrict__c,
    					kwrc__KW_StateHouseDesc__c,
    					kwrc__KW_StateSenateDistrict__c,
    					kwrc__KW_StateSenateDesc__c,
    					kwrc__KW_USHouseDistrict__c,
    					kwrc__KW_USHouseDesc__c,
    					kwrc__USPS_City__c,
    					kwrc__USPS_State__c,
    					kwrc__USPS_Street__c,
    					kwrc__USPS_Street_2__c,
    					kwrc__USPS_Verified__c,
    					kwrc__USPS_Zip__c,
    					kwrc__KW_USSenateDistrict__c,
    					kwrc__KW_USSenateDesc__c,
    					kwrc__ZDM_Location__c,
    					kwrc__Zip_4__c
    			FROM rC_Bios__Address__c
    			WHERE Id IN :addressIDs]) {

    		
			// Save it into a Map
    		addressMap.put(theAddress.Id,theAddress);
    	}

		// Step though the trigger
        for(rC_Bios__Account_Address__c aa: newList) {

			// If the Address object is in the map
			if (addressMap.containsKey(aa.rC_Bios__Address__c)) {
				
				// Both are null?
				system.debug('Address is in the Map:');
				system.debug('=:=:=:=:=:=:=:=:=:=:=:=:=:=');
				system.debug('AA USPS Zip:' + aa.kwrc__USPS_Zip__c + ':');
				system.debug(' A USPS Zip:' + addressMap.get(aa.rC_Bios__Address__c).kwrc__USPS_Zip__c + ':');
				system.debug('=:=:=:=:=:=:=:=:=:=:=:=:=:=');

				// Now try to determine if we actually need to update the Account Address or not.
				//
				// If the Account Address Map's new ( ZDM'd ) values 
				//		are not null
				//		are not blank
				//		are different than the existing Account Addresses' values
				//			then update the Account Address
				rC_Bios__Address__c incA = addressMap.get(aa.rC_Bios__Address__c);
				//rC_Bios__Account_Address__c incAA = aa;
				
				if(addressesZDMDifferent(incA,aa)) {
				//if(addressesZDMDifferent(addressMap.get(aa.rC_Bios__Address__c),aa)) {

					// Create the new Account Address to submit the update upon		
					rC_Bios__Account_Address__c newAA = new rC_Bios__Account_Address__c();
	
					// Grab the ID from the Account Address so we update the correct one.				
					newAA.Id									= aa.Id;
	
					// Now populate the new Account Address with the values we stored in the Address object map.
					newAA.kwrc__KW_CountyCode__c 				= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_CountyCode__c;
					newAA.kwrc__KW_CountyDistrict__c 			= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_CountyDistrict__c;
					newAA.kwrc__KW_CountyDistrictDesc__c 		= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_CountyDistrictDesc__c;
					newAA.kwrc__KW_CountyName__c 				= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_CountyName__c;
					newAA.kwrc__Elected_Officials_Ids__c 		= addressMap.get(aa.rC_Bios__Address__c).kwrc__Elected_Officials_Ids__c;
					newAA.kwrc__KW_Error_Code__c 				= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_Error_Code__c;
					newAA.kwrc__ZTDM_Expiry_Date__c 			= addressMap.get(aa.rC_Bios__Address__c).kwrc__ZTDM_Expiry_Date__c;
					newAA.kwrc__KnowWho_Address_Update__c 		= addressMap.get(aa.rC_Bios__Address__c).kwrc__KnowWho_Address_Update__c;
					newAA.kwrc__KWD_Encrypted_Action_Id__c 		= addressMap.get(aa.rC_Bios__Address__c).kwrc__KWD_Encrypted_Action_Id__c;
					newAA.kwrc__KWD_Last_Processed_DT__c 		= addressMap.get(aa.rC_Bios__Address__c).kwrc__KWD_Last_Processed_DT__c;
					newAA.kwrc__Latitude__c 					= addressMap.get(aa.rC_Bios__Address__c).kwrc__Latitude__c;
					newAA.kwrc__Longitude__c 					= addressMap.get(aa.rC_Bios__Address__c).kwrc__Longitude__c;
					newAA.kwrc__KW_MunicipalCode__c 			= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_MunicipalCode__c;
					newAA.kwrc__KW_MunicipalDistrict__c 		= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_MunicipalDistrict__c;
					newAA.kwrc__KW_MunicipalDistrictDesc__c 	= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_MunicipalDistrictDesc__c;
					newAA.kwrc__KW_MunicipalName__c 			= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_MunicipalName__c;
					newAA.kwrc__KW_MunicipalType__c 			= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_MunicipalType__c;
					newAA.kwrc__PO_Box__c 						= addressMap.get(aa.rC_Bios__Address__c).kwrc__PO_Box__c;
					newAA.kwrc__KW_StateHouseDistrict__c	 	= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_StateHouseDistrict__c;
					newAA.kwrc__KW_StateHouseDesc__c 			= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_StateHouseDesc__c;
					newAA.kwrc__KW_StateSenateDistrict__c 		= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_StateSenateDistrict__c;
					newAA.kwrc__KW_StateSenateDesc__c 			= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_StateSenateDesc__c;
					newAA.kwrc__KW_USHouseDistrict__c 			= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_USHouseDistrict__c;
					newAA.kwrc__KW_USHouseDesc__c 				= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_USHouseDesc__c;
					newAA.kwrc__USPS_City__c 					= addressMap.get(aa.rC_Bios__Address__c).kwrc__USPS_City__c;
					newAA.kwrc__USPS_State__c 					= addressMap.get(aa.rC_Bios__Address__c).kwrc__USPS_State__c;
					newAA.kwrc__USPS_Street__c 					= addressMap.get(aa.rC_Bios__Address__c).kwrc__USPS_Street__c;
					newAA.kwrc__USPS_Street_2__c 				= addressMap.get(aa.rC_Bios__Address__c).kwrc__USPS_Street_2__c;
					newAA.kwrc__USPS_Verified__c 				= addressMap.get(aa.rC_Bios__Address__c).kwrc__USPS_Verified__c;
					newAA.kwrc__USPS_Zip__c 					= addressMap.get(aa.rC_Bios__Address__c).kwrc__USPS_Zip__c;
					newAA.kwrc__KW_USSenateDistrict__c 			= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_USSenateDistrict__c;
					newAA.kwrc__KW_USSenateDesc__c 				= addressMap.get(aa.rC_Bios__Address__c).kwrc__KW_USSenateDesc__c;
					newAA.kwrc__Zip_4__c 						= addressMap.get(aa.rC_Bios__Address__c).kwrc__Zip_4__c;
	
					// KW Geolocation object is not writable
					//aa.kwrc__ZDM_Location__c = addressMap.get(aa.rC_Bios__Address__c).kwrc__ZDM_Location__c;
					
					// Add the Address to the list to be updated
					accountAddressesToUpdate.add(newAA);
					
				}
				
				// VB: 8/19/16 - Old criteria that only checked USPS Zip & Elected Officials Ids
				/*
				// If the Account Address Map's new ( ZDM'd ) values for Zip & Elected officials
				//		are not null
				//		are not blank
				//		are different than the existing Account Addresses' values
				//			then update the Account Address
				if (addressMap.get(aa.rC_Bios__Address__c).kwrc__USPS_Zip__c 				!= null &&							// Not Null 
					addressMap.get(aa.rC_Bios__Address__c).kwrc__Elected_Officials_Ids__c	!= null && 
					!String.isBlank(addressMap.get(aa.rC_Bios__Address__c).kwrc__USPS_Zip__c) &&								// Not Blank
					!String.isBlank(addressMap.get(aa.rC_Bios__Address__c).kwrc__Elected_Officials_Ids__c) &&
					aa.kwrc__USPS_Zip__c 				!= addressMap.get(aa.rC_Bios__Address__c).kwrc__USPS_Zip__c &&			// Different from existing aa value.
					aa.kwrc__Elected_Officials_Ids__c 	!= addressMap.get(aa.rC_Bios__Address__c).kwrc__Elected_Officials_Ids__c ) {
				}
				*/
			}
        }
		
		// Update all the appropriate addresses.
		update accountAddressesToUpdate;
		
		// Update the Address object's ZDM informaiton with the information in the Address
        
    }

	// New method to check to see if there are any differences between the supplied
	//		Addresss and Account Address object's ZDM fields
	public static boolean addressesZDMDifferent(rC_Bios__Address__c add,rC_Bios__Account_Address__c aa) {

		if (addressesBoolFieldDifferent(add.kwrc__KnowWho_Address_Update__c,aa.kwrc__KnowWho_Address_Update__c)) return true;
		if (addressesBoolFieldDifferent(add.kwrc__PO_Box__c,aa.kwrc__PO_Box__c)) return true;
		if (addressesBoolFieldDifferent(add.kwrc__USPS_Verified__c,aa.kwrc__USPS_Verified__c)) return true;

		if (addressesDateFieldDifferent(add.kwrc__KWD_Last_Processed_DT__c,aa.kwrc__KWD_Last_Processed_DT__c)) return true;
		if (addressesDateFieldDifferent(add.kwrc__ZTDM_Expiry_Date__c,aa.kwrc__ZTDM_Expiry_Date__c)) return true;

		if (addressesDeciFieldDifferent(add.kwrc__Latitude__c,aa.kwrc__Latitude__c)) return true;
		if (addressesDeciFieldDifferent(add.kwrc__Longitude__c,aa.kwrc__Longitude__c)) return true;
		
		// Go through each of the fields, checking if the value is different and return true if we find a difference
		if (addressesFieldDifferent(add.kwrc__Elected_Officials_Ids__c,aa.kwrc__Elected_Officials_Ids__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KWD_Encrypted_Action_Id__c,aa.kwrc__KWD_Encrypted_Action_Id__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_CountyCode__c,aa.kwrc__KW_CountyCode__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_CountyDistrict__c,aa.kwrc__KW_CountyDistrict__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_CountyDistrictDesc__c,aa.kwrc__KW_CountyDistrictDesc__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_CountyName__c,aa.kwrc__KW_CountyName__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_Error_Code__c,aa.kwrc__KW_Error_Code__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_MunicipalCode__c,aa.kwrc__KW_MunicipalCode__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_MunicipalDistrict__c,aa.kwrc__KW_MunicipalDistrict__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_MunicipalDistrictDesc__c,aa.kwrc__KW_MunicipalDistrictDesc__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_MunicipalName__c,aa.kwrc__KW_MunicipalName__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_MunicipalType__c,aa.kwrc__KW_MunicipalType__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_StateHouseDistrict__c,aa.kwrc__KW_StateHouseDistrict__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_StateHouseDesc__c,aa.kwrc__KW_StateHouseDesc__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_StateSenateDistrict__c,aa.kwrc__KW_StateSenateDistrict__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_StateSenateDesc__c,aa.kwrc__KW_StateSenateDesc__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_USHouseDistrict__c,aa.kwrc__KW_USHouseDistrict__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_USHouseDesc__c,aa.kwrc__KW_USHouseDesc__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_USSenateDistrict__c,aa.kwrc__KW_USSenateDistrict__c)) return true;
		if (addressesFieldDifferent(add.kwrc__KW_USSenateDesc__c,aa.kwrc__KW_USSenateDesc__c)) return true;
		if (addressesFieldDifferent(add.kwrc__USPS_City__c,aa.kwrc__USPS_City__c)) return true;
		if (addressesFieldDifferent(add.kwrc__USPS_State__c,aa.kwrc__USPS_State__c)) return true;
		if (addressesFieldDifferent(add.kwrc__USPS_Street__c,aa.kwrc__USPS_Street__c)) return true;
		if (addressesFieldDifferent(add.kwrc__USPS_Street_2__c,aa.kwrc__USPS_Street_2__c)) return true;
		if (addressesFieldDifferent(add.kwrc__USPS_Zip__c,aa.kwrc__USPS_Zip__c)) return true;
		if (addressesFieldDifferent(add.kwrc__Zip_4__c,aa.kwrc__Zip_4__c)) return true;

		// No different fields were found, then they appear to match.
		return false;
	}

	// Compare two values, checking to make sure the first is not blank(null/empty)
	//		Addresss and Account Address object's ZDM fields
	public static boolean addressesFieldDifferent(String field1, String field2) {

		// Check the first value, to make sure it isn't null/blank before comparing the strings
		if (field1	!= null && 
			!String.isBlank(field1) &&
			field1 	!= field2 ) {
			return true;
		} else {
			return false;
		}
	}
	public static boolean addressesBoolFieldDifferent(Boolean field1, Boolean field2) {
		// Check the first value, to make sure it isn't null/blank before comparing the strings
		// No test for blank
		if (field1	!= null && 
			field1 	!= field2 ) {
			return true;
		} else {
			return false;
		}
	}
	public static boolean addressesDateFieldDifferent(Datetime field1, Datetime field2) {
		// Check the first value, to make sure it isn't null/blank before comparing the strings
		// No test for blank
		if (field1	!= null && 
			field1 	!= field2 ) {
			return true;
		} else {
			return false;
		}
	}
	public static boolean addressesDeciFieldDifferent(Decimal field1, Decimal field2) {
		// Check the first value, to make sure it isn't null/blank before comparing the strings
		// No test for blank
		if (field1	!= null && 
			field1 	!= field2 ) {
			return true;
		} else {
			return false;
		}
	}


	// VB: 5/14/15 - This method looks like a copy and paste error.  Commenting it out.
    
    /*
    // Look for a defined Campaign Ask
    //		that matches the form Campaign, Giving Amount
    //		and apply the Campaign Asks Member Type and Level to the Batch Upload  
    private void updateMemberLevelType(List<rC_Connect__Batch_Upload__c> newList){
    	
    	// List of Form Campaigns we will need to look up the Campaign Asks on.  <bulkifried>
    	Set<Id> formCampaignIDs = new Set<Id>();

    	// Save the Batch Upload Form Campaigns
        for(rC_Connect__Batch_Upload__c bu: newList){

			// Set the Status for the incoming BU records
			bu.rC_Connect__Batch_Upload_Status__c = 'To ZDM';
			        	
			// Save off the form Campaign ID's from the batch
			//
			// TODO: Stick a check in here in case it's already in the list?
			formCampaignIDs.add(bu.Form_Campaign__c);
        }
    	
    	// Look up all the Campaign Asks for the given set of formCampaigns
    	//		Only look at One Payment Frequency and Default Asks
    	//		WARNING: Hopefully, this should return one ask per campaign, but currently there are 
    	//			no validations to prevent the entry of multiple default campaign asks.  This currently
    	//			returns the first returned match. 
    	//
    	Map<String,rC_Connect__Campaign_Ask__c> campaignAsksMap = new Map<String,rC_Connect__Campaign_Ask__c>();
    	for (rC_Connect__Campaign_Ask__c theAsk :[
    			SELECT  rC_Connect__Campaign__c,
    					Ask_1_Member_Level__c, Ask_1_Member_Type__c, rC_Connect__Ask_1_Amount__c,
						Ask_2_Member_Level__c, Ask_2_Member_Type__c, rC_Connect__Ask_2_Amount__c,
						Ask_3_Member_Level__c, Ask_3_Member_Type__c, rC_Connect__Ask_3_Amount__c,
						Ask_4_Member_Level__c, Ask_4_Member_Type__c, rC_Connect__Ask_4_Amount__c,
						Ask_5_Member_Level__c, Ask_5_Member_Type__c, rC_Connect__Ask_5_Amount__c
    			FROM rC_Connect__Campaign_Ask__c
    			WHERE rC_Connect__Campaign__c IN :formCampaignIDs
    			AND rC_Connect__Giving_Frequency__c = 'One Payment'
    			AND rC_Connect__Is_Default_Ask__c = TRUE]) {
    		
    		// Now save off the 5 potential Level/Type definitions
    		//
    		// The Map key is the Campaign + the Ask Amount + which of the 5 asks
    		//		The Value is the Campaign Ask
    		campaignAsksMap.put(theAsk.rC_Connect__Campaign__c + String.valueOf(theAsk.rC_Connect__Ask_1_Amount__c) + '1',theAsk);
    		campaignAsksMap.put(theAsk.rC_Connect__Campaign__c + String.valueOf(theAsk.rC_Connect__Ask_2_Amount__c) + '2',theAsk);
    		campaignAsksMap.put(theAsk.rC_Connect__Campaign__c + String.valueOf(theAsk.rC_Connect__Ask_3_Amount__c) + '3',theAsk);
    		campaignAsksMap.put(theAsk.rC_Connect__Campaign__c + String.valueOf(theAsk.rC_Connect__Ask_4_Amount__c) + '4',theAsk);
    		campaignAsksMap.put(theAsk.rC_Connect__Campaign__c + String.valueOf(theAsk.rC_Connect__Ask_5_Amount__c) + '5',theAsk);
    	}


		// Now step back through the Trigger list
		//		but populate the Level/Type from the Map
        for(rC_Connect__Batch_Upload__c bu: newList){

			// Convert the Batch Upload Giving Amount to a string.
			//		Saves a lot of duplication below
			String buGivingAmt = String.valueOf(bu.rC_Connect__Giving_Giving_Amount__c);
			
			// Now check the 5 separate asks:
			// 		If the value is stored in the map, then update the 
			// TODO: Add a loop, if so motivated.
			if (campaignAsksMap.containsKey( bu.Form_Campaign__c + buGivingAmt + '1')) {
				bu.Member_Type__c  = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '1').Ask_1_Member_Level__c;
				bu.Member_Level__c = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '1').Ask_1_Member_Type__c;
			} else if (campaignAsksMap.containsKey( bu.Form_Campaign__c + buGivingAmt + '2')) {
				bu.Member_Type__c  = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '2').Ask_2_Member_Level__c;
				bu.Member_Level__c = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '2').Ask_2_Member_Type__c;
			} else if (campaignAsksMap.containsKey( bu.Form_Campaign__c + buGivingAmt + '3')) {
				bu.Member_Type__c  = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '3').Ask_3_Member_Level__c;
				bu.Member_Level__c = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '3').Ask_3_Member_Type__c;
			} else if (campaignAsksMap.containsKey( bu.Form_Campaign__c + buGivingAmt + '4')) {
				bu.Member_Type__c  = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '4').Ask_4_Member_Level__c;
				bu.Member_Level__c = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '4').Ask_4_Member_Type__c;
			} else if (campaignAsksMap.containsKey( bu.Form_Campaign__c + buGivingAmt + '5')) {
				bu.Member_Type__c  = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '5').Ask_5_Member_Level__c;
				bu.Member_Level__c = campaignAsksMap.get( bu.Form_Campaign__c + buGivingAmt + '5').Ask_5_Member_Type__c;
			}        	
		}
    }
    */
}