/*
	MoveZDMFromAccountsToContacts
	
	This class is called by ContactTrigger (before insert) 
	and ContactBeforeUpdateHandler called by CIContactChanges Trigger (before update) (if AccountId has changed)
	
	It moves ZDM information from the Account to the newly inserted or updated Contact
	
	7/2017 - Created by Mark Maslow
*/
public with sharing class MoveZDMFromAccountsToContacts {
	public static void moveInfo(List<Contact> contactList) {
		Set<Id> accountIdSet = new Set<Id>();
		for(Contact ctct : contactList) {
			accountIdSet.add(ctct.AccountId);
		}
		Map<Id, Account> accountMap = new Map<Id, Account>([
			select
				Id, 
				kwzd__KW_CountyCode__c,
				kwzd__KW_CountyDistrict__c,
				kwzd__KW_CountyDistrictDesc__c,
				kwzd__KW_CountyName__c,
				kwzd__Elected_Officials_Ids__c,
				kwzd__KW_Error_Code__c,
				kwzd__ZTDM_Expiry_Date__c,
				kwzd__KnowWho_Address_Update__c,
				kwzd__KWD_Encrypted_Action_Id__c,
				kwzd__KWD_Last_Processed_DT__c,
				kwzd__Latitude__c,
				kwzd__Longitude__c,
				kwzd__KW_MunicipalCode__c,
				kwzd__KW_MunicipalDistrict__c,
				kwzd__KW_MunicipalDistrictDesc__c,
				kwzd__KW_MunicipalName__c,
				kwzd__KW_MunicipalType__c,
				kwzd__PO_Box__c,
				kwzd__KW_StateHouseDistrict__c,
				kwzd__KW_StateHouseDesc__c,
				kwzd__KW_StateSenateDistrict__c,
				kwzd__KW_StateSenateDesc__c,
				kwzd__KW_USHouseDistrict__c,
				kwzd__KW_USHouseDesc__c,
				kwzd__USPS_City__c,
				kwzd__USPS_State__c,
				kwzd__USPS_Street__c,
				kwzd__USPS_Street_2__c,
				kwzd__USPS_Verified__c,
				kwzd__USPS_Zip__c,
				kwzd__KW_USSenateDistrict__c,
				kwzd__KW_USSenateDesc__c,
				kwzd__Zip_4__c
			from Account
			where Id in :accountIdSet			
		]);
		
		for(Contact ctct : contactList) {
			Account acct = accountMap.get(ctct.AccountId);
			if(acct != null) {
				ctct.kwzd__KW_CountyCode__c = acct.kwzd__KW_CountyCode__c;
				ctct.kwzd__KW_CountyDistrict__c = acct.kwzd__KW_CountyDistrict__c;
				ctct.kwzd__KW_CountyDistrictDesc__c = acct.kwzd__KW_CountyDistrictDesc__c;
				ctct.kwzd__KW_CountyName__c = acct.kwzd__KW_CountyName__c;
				ctct.kwzd__Elected_Officials_Ids__c = acct.kwzd__Elected_Officials_Ids__c;
				ctct.kwzd__KW_Error_Code__c = acct.kwzd__KW_Error_Code__c;
				ctct.kwzd__ZTDM_Expiry_Date__c = acct.kwzd__ZTDM_Expiry_Date__c;
				ctct.kwzd__KnowWho_Address_Update__c = acct.kwzd__KnowWho_Address_Update__c;
				ctct.kwzd__KWD_Encrypted_Action_Id__c = acct.kwzd__KWD_Encrypted_Action_Id__c;
				ctct.kwzd__KWD_Last_Processed_DT__c = acct.kwzd__KWD_Last_Processed_DT__c;
				ctct.kwzd__Latitude__c = acct.kwzd__Latitude__c;
				ctct.kwzd__Longitude__c = acct.kwzd__Longitude__c;
				ctct.kwzd__KW_MunicipalCode__c = acct.kwzd__KW_MunicipalCode__c;
				ctct.kwzd__KW_MunicipalDistrict__c = acct.kwzd__KW_MunicipalDistrict__c;
				ctct.kwzd__KW_MunicipalDistrictDesc__c = acct.kwzd__KW_MunicipalDistrictDesc__c;
				ctct.kwzd__KW_MunicipalName__c = acct.kwzd__KW_MunicipalName__c;
				ctct.kwzd__KW_MunicipalType__c = acct.kwzd__KW_MunicipalType__c;
				ctct.kwzd__PO_Box__c = acct.kwzd__PO_Box__c;
				ctct.kwzd__KW_StateHouseDistrict__c = acct.kwzd__KW_StateHouseDistrict__c;
				ctct.kwzd__KW_StateHouseDesc__c = acct.kwzd__KW_StateHouseDesc__c;
				ctct.kwzd__KW_StateSenateDistrict__c = acct.kwzd__KW_StateSenateDistrict__c;
				ctct.kwzd__KW_StateSenateDesc__c = acct.kwzd__KW_StateSenateDesc__c;
				ctct.kwzd__KW_USHouseDistrict__c = acct.kwzd__KW_USHouseDistrict__c;
				ctct.kwzd__KW_USHouseDesc__c = acct.kwzd__KW_USHouseDesc__c;
				ctct.kwzd__USPS_City__c = acct.kwzd__USPS_City__c;
				ctct.kwzd__USPS_State__c = acct.kwzd__USPS_State__c;
				ctct.kwzd__USPS_Street__c = acct.kwzd__USPS_Street__c;
				ctct.kwzd__USPS_Street_2__c = acct.kwzd__USPS_Street_2__c;
				ctct.kwzd__USPS_Verified__c = acct.kwzd__USPS_Verified__c;
				ctct.kwzd__USPS_Zip__c = acct.kwzd__USPS_Zip__c;
				ctct.kwzd__KW_USSenateDistrict__c = acct.kwzd__KW_USSenateDistrict__c;
				ctct.kwzd__KW_USSenateDesc__c = acct.kwzd__KW_USSenateDesc__c;
				ctct.kwzd__Zip_4__c = acct.kwzd__Zip_4__c;
			}
		}
	}    
}