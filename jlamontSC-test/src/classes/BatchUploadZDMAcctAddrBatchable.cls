global class BatchUploadZDMAcctAddrBatchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date earliestDate = Date.newInstance(2016, 8, 1);
        if(Test.isRunningTest()) {
            earliestDate = Date.today();
        }
        return Database.getQueryLocator([
			select
				Id, 
				rC_Connect__Batch_Upload_Address_Matched__c,
				kwrc__Elected_Officials_Ids__c,
				kwrc__KWD_Last_Processed_DT__c,
				kwrc__KW_CountyCode__c,
				kwrc__KW_CountyDistrictDesc__c,
				kwrc__KW_CountyDistrict__c,
				kwrc__KW_CountyName__c,
				kwrc__KW_Error_Code__c,
				kwrc__KW_MunicipalCode__c,
				kwrc__KW_MunicipalDistrictDesc__c,
				kwrc__KW_MunicipalDistrict__c,
				kwrc__KW_MunicipalName__c,
				kwrc__KW_MunicipalType__c,
				kwrc__KW_StateHouseDesc__c,
				kwrc__KW_StateHouseDistrict__c,
				kwrc__KW_StateSenateDesc__c,
				kwrc__KW_StateSenateDistrict__c,
				kwrc__KW_USHouseDesc__c,
				kwrc__KW_USHouseDistrict__c,
				kwrc__KW_USSenateDesc__c,
				kwrc__KW_USSenateDistrict__c,
				kwrc__Latitude__c,
				kwrc__Longitude__c,
				kwrc__PO_Box__c,
				kwrc__USPS_City__c,
				kwrc__USPS_State__c,
				kwrc__USPS_Street_2__c,
				kwrc__USPS_Street__c,
				kwrc__USPS_Zip__c,
				kwrc__ZTDM_Expiry_Date__c,
				kwrc__Zip_4__c
			from rC_Connect__Batch_Upload__c
			where
            	LastModifiedDate >= :earliestDate AND
				rC_Connect__Batch_Upload_Status__c = 'Committed' AND
				rC_Connect__Batch_Upload_Address_Matched__c != null AND
				kwrc__USPS_Street__c != null AND
				AccountAddressUpdated__c = false
		]);    	
    }
    global void execute(Database.BatchableContext BC, List<rC_Connect__Batch_Upload__c> buList) {
		//Create Map to map Addresses to set of Account Addresses that point to those Addresses
		Set<Id> addressIdSet = new Set<Id>();
		for(rC_Connect__Batch_Upload__c bu : buList) {
			addressIdSet.add(bu.rC_Connect__Batch_Upload_Address_Matched__c);
		}
		
		List<rC_Bios__Account_Address__c> addrList = [
			select
				Id,
				rC_Bios__Address__c, 
				kwrc__Elected_Officials_Ids__c,
				kwrc__KWD_Last_Processed_DT__c,
				kwrc__KW_CountyCode__c,
				kwrc__KW_CountyDistrictDesc__c,
				kwrc__KW_CountyDistrict__c,
				kwrc__KW_CountyName__c,
				kwrc__KW_Error_Code__c,
				kwrc__KW_MunicipalCode__c,
				kwrc__KW_MunicipalDistrictDesc__c,
				kwrc__KW_MunicipalDistrict__c,
				kwrc__KW_MunicipalName__c,
				kwrc__KW_MunicipalType__c,
				kwrc__KW_StateHouseDesc__c,
				kwrc__KW_StateHouseDistrict__c,
				kwrc__KW_StateSenateDesc__c,
				kwrc__KW_StateSenateDistrict__c,
				kwrc__KW_USHouseDesc__c,
				kwrc__KW_USHouseDistrict__c,
				kwrc__KW_USSenateDesc__c,
				kwrc__KW_USSenateDistrict__c,
				kwrc__Latitude__c,
				kwrc__Longitude__c,
				kwrc__PO_Box__c,
				kwrc__USPS_City__c,
				kwrc__USPS_State__c,
				kwrc__USPS_Street_2__c,
				kwrc__USPS_Street__c,
				kwrc__USPS_Zip__c,
				kwrc__ZTDM_Expiry_Date__c,
				kwrc__Zip_4__c
			from rC_Bios__Account_Address__c
			where rC_Bios__Address__c in :addressIdSet
			order by rC_Bios__Address__c
		];

		Map<Id, Set<rC_Bios__Account_Address__c>> addressToAccountAddresses = new Map<Id, Set<rC_Bios__Account_Address__c>>();
		Set<rC_Bios__Account_Address__c> accountAddrSet = new Set<rC_Bios__Account_Address__c>();
		Id lastAddressId = addrList.get(0).rC_Bios__Address__c;
		for(rC_Bios__Account_Address__c addr : addrList) {
			if(addr.rC_Bios__Address__c != lastAddressId) {
				addressToAccountAddresses.put(lastAddressId, accountAddrSet);
				accountAddrSet = new Set<rC_Bios__Account_Address__c>();
				lastAddressId = addr.rC_Bios__Address__c;
			}
			accountAddrSet.add(addr);
		}
		addressToAccountAddresses.put(lastAddressId, accountAddrSet);
		
		//Create two lists -
		//    List of Account Addresses to update ZDM information
		//    List of Batch Uploads to update AccountAddressUpdated field
		List<rC_Connect__Batch_Upload__c> batchUploadsToUpdate = new List<rC_Connect__Batch_Upload__c>();
		List<rC_Bios__Account_Address__c> accountAddressesToUpdate = new List<rC_Bios__Account_Address__c>();
		Set<Id> accountAddrIdSet = new Set<Id>();
		for(rC_Connect__Batch_Upload__c bu : buList) {
			Set<rC_Bios__Account_Address__c> addrSet = addressToAccountAddresses.get(bu.rC_Connect__Batch_Upload_Address_Matched__c);
            if(addrSet != null) {
                for(rC_Bios__Account_Address__c accountAddr : addrSet) {
                    if(accountAddr.kwrc__Latitude__c != bu.kwrc__Latitude__c || accountAddr.kwrc__Longitude__c != bu.kwrc__Longitude__c) {
                        if( ! accountAddrIdSet.contains(accountAddr.Id)) {
                            accountAddressesToUpdate.add(
                                new rC_Bios__Account_Address__c (
                                    Id = accountAddr.Id,
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
                                    kwrc__ZTDM_Expiry_Date__c = bu.kwrc__ZTDM_Expiry_Date__c,
                                    kwrc__Zip_4__c = bu.kwrc__Zip_4__c
                                )
                            );
                            accountAddrIdSet.add(accountAddr.Id);
                        }
                    }
                }
			}
			batchUploadsToUpdate.add(new rC_Connect__Batch_Upload__c(Id = bu.Id, AccountAddressUpdated__c = true));
		}
		//Update Account Addresses with ZDM Information
		update accountAddressesToUpdate;
		//Update Batch Upload records, setting AccountAddressUpdated field to true
		//First, set static variable to prevent Batch Upload triggers from firing
		BatchUploadTriggerHandler.updatingAccountAddress = true;
		update batchUploadsToUpdate;
    }
    global void finish(Database.BatchableContext BC) {
    }
}