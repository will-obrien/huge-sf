/*
//Name              : BatchUploadPostFlaggedProcessing
//Created By        : Mark Maslow
//Created Date      : March, 2016
//Description       : Batch uploads can flag during processing for various reasons. 
						While some require human judgment and need to be manually reviewed, there are a few cases where updates 
						can be applied automatically without review.
						
						See https://docs.google.com/document/d/1ddV7hZLbJhXBAy8XHfHd3gYZSQ3QvHZKHXxL0hPoX6Q
						
						Variant 3 is handled by trigger handler BatchUploadBeforeInsertUpdate
//Updates			: 2016/12/05 Tami Lau: Clear address for 'Address Type may not be Changed' errors
//					: 2017/02/17 Tami Lau: Reset batch upload if row lock error
*/

public without sharing class BatchUploadPostFlaggedProcessing {
	public static Boolean flaggedBatchesProcessed = false;
	private static List<rC_Connect__Batch_Upload__c> batchesToUpdate = new List<rC_Connect__Batch_Upload__c>();
	private static List<rC_Bios__Account_Address__c> addressesToUpdate = new List<rC_Bios__Account_Address__c>();
	private static List<rC_Connect__Batch_Upload__c> variant1List = new List<rC_Connect__Batch_Upload__c>();
	private static List<rC_Connect__Batch_Upload__c> variant2List = new List<rC_Connect__Batch_Upload__c>();
	//private static List<rC_Connect__Batch_Upload__c> variant3List = new List<rC_Connect__Batch_Upload__c>();
    private static List<rC_Connect__Batch_Upload__c> variant4List = new List<rC_Connect__Batch_Upload__c>();
	public static void process(List<rC_Connect__Batch_Upload__c> buList) {
		if(flaggedBatchesProcessed) {
			return;
		}
		for(rC_Connect__Batch_Upload__c bu : buList) {
			if(bu.rC_Connect__Batch_Upload_Status__c == 'Flagged') {
				flaggedBatchesProcessed = true;
				if(
					bu.rC_Connect__Batch_Upload_Flagged_Technical_Reason__c != null &&
                    bu.Flagged_Reset_By__c != 'rCorner BatchUpload') 
				{
					if(bu.rC_Connect__Batch_Upload_Flagged_Technical_Reason__c.contains('Address Type already exists for Account')) {
						if(bu.kwrc__USPS_Verified__c || (bu.rC_Connect__Address_Street_Line_1__c != null && bu.rC_Connect__Address_Street_Line_1__c != 'Unknown' && bu.kwrc__USPS_Verified__c == false && bu.kwrc__KW_Error_Code__c != 'ADDRESS NOT FOUND' && bu.Account_Unknown_Address__c == true)) {
							variant1List.add(bu);
						}
						else if(bu.rC_Connect__Address_Street_Line_1__c == 'Unknown' || bu.Similar_Address__c) {
							variant2List.add(bu);
						}   
					}
                    else if(bu.rC_Connect__Batch_Upload_Flagged_Technical_Reason__c.contains('Address Type may not be Changed')) {
							variant2List.add(bu);
						}
                    else if(bu.rC_Connect__Batch_Upload_Flagged_Technical_Reason__c.contains('UNABLE_TO_LOCK_ROW')) {
							variant4List.add(bu);
						}                    
				}
			}
		}
		if( ! variant1List.isEmpty() ) {
			processVariant1List(variant1List);
		}
		if( ! variant2List.isEmpty() ) {
			processVariant2List(variant2List);
        }
        
		if( ! variant4List.isEmpty() ) {
			processVariant4List(variant4List);
        }  
        
		if( ! batchesToUpdate.isEmpty() ) {
			update batchesToUpdate;
		}
        
		if( ! addressesToUpdate.isEmpty() ) {
			UpdateAccountAddressAsynch updater = new UpdateAccountAddressAsynch(addressesToUpdate);
			Id jobId = System.enqueueJob(updater);
		}
	}
    
    //Variant 1: new address is verified or is unverified but would replace an Unknown, so update existing account address
	private static void processVariant1List(List<rC_Connect__Batch_Upload__c> buList) {
		//Create map to correlate Account Id with set of Account Addresses 
		Map<Id, Set<rC_Bios__Account_Address__c>> addrMap = new Map<Id, Set<rC_Bios__Account_Address__c>>();
		Set<Id> idSet = new Set<Id>();
		for(rC_Connect__Batch_Upload__c bu : buList) {
			idSet.add(bu.rC_Connect__Batch_Upload_Account_Matched__c);
		}
		List<rC_Bios__Account_Address__c> addrList = [
			select 
				id, 
				rC_Bios__Account__c, 
				rC_Bios__Type__c,
				rC_Bios__Preferred_Billing__c
			from rC_Bios__Account_Address__c
			where rC_Bios__Account__c in :idSet
		];
		for(rC_Bios__Account_Address__c addr : addrList) {
			Set<rC_Bios__Account_Address__c> addrSet = addrMap.get(addr.rC_Bios__Account__c);
			if(addrSet == null) {
				addrSet = new Set<rC_Bios__Account_Address__c>();
			}
			addrSet.add(addr);
			addrMap.put(addr.rC_Bios__Account__c, addrSet);
		}
		//Process Batch Upload records
		for(rC_Connect__Batch_Upload__c bu : buList) {
			Set<rC_Bios__Account_Address__c> addrSet = addrMap.get(bu.rC_Connect__Batch_Upload_Account_Matched__c);
			if(addrSet != null) {
				Id preferredBillingId;
				rC_Bios__Account_Address__c addrToUpdate;
				for(rC_Bios__Account_Address__c addr : addrSet) {
					if(addr.rC_Bios__Preferred_Billing__c) {
						//addrToUpdate = addr;
						if(preferredBillingId == null) {
							preferredBillingId = addr.Id;
						}
					}
					if(addr.rC_Bios__Type__c == bu.rC_Connect__Address_Type__c) {
						addrToUpdate = addr;
					}
				} 
				if(preferredBillingId != null && preferredBillingId != addrToUpdate.Id) {
					rC_Connect__Batch_Upload__c buToUpdate = new rC_Connect__Batch_Upload__c(
						Id = bu.Id,
						rC_Connect__Batch_Upload_Flagged_Reason__c = 'Account has multiple addresses. Please find and update preferred address.'
					);
					batchesToUpdate.add(buToUpdate);
				}
				else {
					addressesToUpdate.add(changeAddress(bu, addrToUpdate.Id));
					batchesToUpdate.add(resetBatchUploadToProcess(bu));
				}
			}
		}
	}
	
    //Variant 2: new address is "Unknown," similar to existing verified address, or same as existing address but different type,
    //so clear address fields on batch upload since we don't need it
    private static void processVariant2List(List<rC_Connect__Batch_Upload__c> buList) {
		for(rC_Connect__Batch_Upload__c bu : buList) {
			rC_Connect__Batch_Upload__c buUpdate = new rC_Connect__Batch_Upload__c(
				Id = bu.Id,
				rC_Connect__Address_Street_Line_1__c = null,
				rC_Connect__Address_Street_Line_2__c = null,
				rC_Connect__Address_City__c = null,
				rC_Connect__Address_State__c = null,
				rC_Connect__Address_Postal_Code__c = null,
				rC_Connect__Address_Country__c = null,
				rC_Connect__Address_Type__c = null,
				rC_Connect__Address_Preferred_Billing__c = false,
				rC_Connect__Address_Preferred_Shipping__c = false,
				rC_Connect__Batch_Upload_Status__c = 'To Process',
				rC_Connect__Batch_Upload_Flagged_Reason__c = null,
				rC_Connect__Batch_Upload_Flagged_Technical_Reason__c = null,
				Flagged_Reset_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName(),
				Flagged_Reset_Date__c = System.today()
			);
			batchesToUpdate.add(buUpdate);
		}
	}

    //Variant 4: record hit row lock, just reset status and flags
    private static void processVariant4List(List<rC_Connect__Batch_Upload__c> buList) {
        for (rC_Connect__Batch_Upload__c bu: buList) {
			rC_Connect__Batch_Upload__c buUpdate = new rC_Connect__Batch_Upload__c(
				Id = bu.Id,
				rC_Connect__Batch_Upload_Status__c = 'To Process',
				rC_Connect__Batch_Upload_Flagged_Reason__c = null,
				rC_Connect__Batch_Upload_Flagged_Technical_Reason__c = null
			);
			batchesToUpdate.add(buUpdate);
        }
    }
    
	private static rC_Connect__Batch_Upload__c resetBatchUploadToProcess(rC_Connect__Batch_Upload__c bu) {
		rC_Connect__Batch_Upload__c buUpdate = new rC_Connect__Batch_Upload__c(
			Id = bu.Id,
			rC_Connect__Batch_Upload_Status__c = 'To Process',
			rC_Connect__Batch_Upload_Flagged_Reason__c = null,
			rC_Connect__Batch_Upload_Flagged_Technical_Reason__c = null,
			Flagged_Reset_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName(),
			Flagged_Reset_Date__c = System.today()
		);
		return buUpdate;
	}
	private static rC_Bios__Account_Address__c changeAddress(rC_Connect__Batch_Upload__c bu, Id addrId) {
		rC_Bios__Account_Address__c addr = new rC_Bios__Account_Address__c(
			Id = addrId,
			rC_Bios__Original_Street_Line_1__c = bu.rC_Connect__Address_Street_Line_1__c,
			rC_Bios__Original_Street_Line_2__c = bu.rC_Connect__Address_Street_Line_2__c,
			rC_Bios__Original_City__c = bu.rC_Connect__Address_City__c,
			rC_Bios__Original_State__c = bu.rC_Connect__Address_State__c,
			rC_Bios__Original_Postal_Code__c = bu.rC_Connect__Address_Postal_Code__c,
			rC_Bios__Original_Country__c = bu.rC_Connect__Address_Country__c,
			rC_Bios__Active__c = true,
			rC_Bios__Preferred_Billing__c = true,
			rC_Bios__Preferred_Shipping__c = true,
			kwrc__USPS_Verified__c = bu.kwrc__USPS_Verified__c,
			kwrc__Elected_Officials_Ids__c = bu.kwrc__Elected_Officials_Ids__c,
			kwrc__KWD_Last_Processed_DT__c = bu.kwrc__KWD_Last_Processed_DT__c,
			kwrc__KW_CountyCode__c = bu.kwrc__KW_CountyCode__c,
			kwrc__KW_CountyDistrictDesc__c = bu.kwrc__KW_CountyDistrictDesc__c,
			kwrc__KW_CountyDistrict__c = bu.kwrc__KW_CountyDistrict__c,
			kwrc__KW_CountyName__c = bu.kwrc__KW_CountyName__c,
			kwrc__KW_Error_Code__c = bu.kwrc__KW_Error_Code__c,
			kwrc__KW_MunicipalCode__c = bu.kwrc__KW_MunicipalCode__c,
			kwrc__KW_MunicipalDistrictDesc__c = bu.kwrc__KW_MunicipalDistrictDesc__c,
			kwrc__KW_MunicipalDistrict__c = bu.kwrc__KW_MunicipalDistrict__c,
			kwrc__KW_MunicipalName__c = bu.kwrc__KW_MunicipalName__c,
			kwrc__KW_MunicipalType__c = bu.kwrc__KW_MunicipalType__c,
			kwrc__KW_StateHouseDesc__c = bu.kwrc__KW_StateHouseDesc__c,
			kwrc__KW_StateHouseDistrict__c = bu.kwrc__KW_StateHouseDistrict__c,
			kwrc__KW_StateSenateDesc__c = bu.kwrc__KW_StateSenateDesc__c,
			kwrc__KW_StateSenateDistrict__c = bu.kwrc__KW_StateSenateDistrict__c,
			kwrc__KW_USHouseDesc__c = bu.kwrc__KW_USHouseDesc__c,
			kwrc__KW_USHouseDistrict__c = bu.kwrc__KW_USHouseDistrict__c,
			kwrc__KW_USSenateDesc__c = bu.kwrc__KW_USSenateDesc__c,
			kwrc__KW_USSenateDistrict__c = bu.kwrc__KW_USSenateDistrict__c,
			kwrc__Latitude__c = bu.kwrc__Latitude__c,
			kwrc__Longitude__c = bu.kwrc__Longitude__c,
			kwrc__PO_Box__c = bu.kwrc__PO_Box__c,
			kwrc__USPS_City__c = bu.kwrc__USPS_City__c,
			kwrc__USPS_State__c = bu.kwrc__USPS_State__c,
			kwrc__USPS_Street_2__c = bu.kwrc__USPS_Street_2__c,
			kwrc__USPS_Street__c = bu.kwrc__USPS_Street__c,
			kwrc__USPS_Zip__c = bu.kwrc__USPS_Zip__c,
			kwrc__ZDM_Location__Latitude__s = bu.kwrc__Latitude__c,
			kwrc__ZDM_Location__Longitude__s = bu.kwrc__Longitude__c,
			kwrc__ZTDM_Expiry_Date__c = bu.kwrc__ZTDM_Expiry_Date__c,
			kwrc__Zip_4__c = bu.kwrc__Zip_4__c
		);
		return addr;
	}
}