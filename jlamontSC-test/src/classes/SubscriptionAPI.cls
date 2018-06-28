@RestResource(urlMapping='/SubscriptionAPI/*')
global without sharing class SubscriptionAPI {
	static Id preferenceGeneralTypeId = Schema.SObjectType.rC_Bios__Preference__c.getRecordTypeInfosByName().get('Club-wide').getRecordTypeId();

	@HttpPost
	global static SubscriptionResponse subscribe(SubscriptionRequest request) {
		SubscriptionResponse response = new SubscriptionResponse();
		response.success = true;
		response.numberAlreadySubscribed = 0;
		response.numberNewlySubscribed = 0;
		response.numberReactivated = 0;
		response.isNewEmail = false;
		
		if(String.isEmpty(request.email)) {
			response.errorMessage = 'Email Address is Required';
			response.success = false;
			return response;
		}
		if(String.isEmpty(request.preferenceCode)) {
			response.errorMessage = 'preferenceCode is Required';
			response.success = false;
			return response;
		}
		if(request.preferenceCode != 'INSIDER') {
			List<rC_Bios__Preference_Code__c> codeList = [
				select Id from rC_Bios__Preference_Code__c 
				where rC_Bios__Code_Value__c = :request.preferenceCode 
			];
			if(codeList.size() == 0) {
				response.errorMessage = '"' + request.preferenceCode + '" is Not a Valid Preference Code';
				response.success = false;
				return response;
			}
		}
		//Check that passed source is a valid Campaign Id
		//If not, plug with null
		if( ! String.isEmpty(request.source) ) {
			List<Campaign> campList = [
				select Id from Campaign where Id = :request.source
			];
			if(campList.isEmpty()) {
				request.source = null;
			}
		}
		//Find all Contacts with email
		List<Contact> contactList = [select Id from Contact where Email = :request.email];
		//If no Contacts with email, create a batch upload record to create Contact and Preference and return response
		if(contactList.size() == 0) {
			String errorMessage = createContact(request);
			response.isNewEmail = true;
			response.errorMessage = errorMessage;
			response.success = (String.isEmpty(errorMessage));
			return response;
		}
		//Find all Preferences for Contacts with requested code value or NOEMAIL code value
		List<rC_Bios__Preference__c> preferenceList = [
			select rC_Bios__Contact__c, rC_Bios__Code_Value__c, rC_Bios__Active__c
			from rC_Bios__Preference__c 
			where 
				rC_Bios__Contact__c in :contactList
				and rC_Bios__Code_Value__c in (:request.preferenceCode, 'NOEMAIL', 'NOINSIDER')
			order by rC_Bios__Contact__c
		];
		//Create map to correlate Contacts with their Preferences
		Map<Id, Set<rC_Bios__Preference__c>> contactToPreferenceMap = new Map<Id, Set<rC_Bios__Preference__c>>();
		if(preferenceList.size() > 0) {
			Set<rC_Bios__Preference__c> preferenceSet = new Set<rC_Bios__Preference__c>();
			Id lastContactId = preferenceList.get(0).rC_Bios__Contact__c;	
			for(rC_Bios__Preference__c pref : preferenceList) {
				if(pref.rC_Bios__Contact__c != lastContactId) {
					contactToPreferenceMap.put(lastContactId, preferenceSet);
					preferenceSet = new Set<rC_Bios__Preference__c>();
					lastContactId = pref.rC_Bios__Contact__c;
				}
				preferenceSet.add(pref);
			}
			contactToPreferenceMap.put(lastContactId, preferenceSet);
		}

		List<rC_Bios__Preference__c> preferencesToUpdate = new List<rC_Bios__Preference__c>();
		List<rC_Bios__Preference__c> preferencesToInsert = new List<rC_Bios__Preference__c>();
		for(Contact ctct : contactList) {
			Set<rC_Bios__Preference__c> preferenceSet = contactToPreferenceMap.get(ctct.Id);
			if(preferenceSet == null || preferenceSet.size() == 0) {
				if(request.preferenceCode != 'INSIDER') {
					preferencesToInsert.add(createPreference(ctct.Id, request.preferenceCode));
					response.numberNewlySubscribed ++;
				}
			}
		 	else {
				rC_Bios__Preference__c preferenceWithCodeValue = getPreferenceWithCodeValue(preferenceSet, request.preferenceCode);
				rC_Bios__Preference__c noEmailPreference = getPreferenceWithCodeValue(preferenceSet, 'NOEMAIL');
				rC_Bios__Preference__c noInsiderPreference = getPreferenceWithCodeValue(preferenceSet, 'NOINSIDER');
				
				if(preferenceWithCodeValue == null) {
					if(request.preferenceCode != 'INSIDER') { 
						preferencesToInsert.add(createPreference(ctct.Id, request.preferenceCode));
						response.numberNewlySubscribed ++;
					}
				}
				else {
					if(preferenceWithCodeValue.rC_Bios__Active__c) {
						response.numberAlreadySubscribed ++;
					}
					else {
						rC_Bios__Preference__c preferenceToUpdate = new rC_Bios__Preference__c (
							Id = preferenceWithCodeValue.Id,
							rC_Bios__Active__c = true
						);
						preferencesToUpdate.add(preferenceToUpdate);
						response.numberReactivated ++;
					}
				}
				if(noEmailPreference != null) {
					if(noEmailPreference.rC_Bios__Active__c) {
						rC_Bios__Preference__c preferenceToUpdate = new rC_Bios__Preference__c (
							Id = noEmailPreference.Id,
							rC_Bios__Active__c = false
						);
						preferencesToUpdate.add(preferenceToUpdate);
					}
				}
				if(noInsiderPreference != null) {
					if(noInsiderPreference.rC_Bios__Active__c && request.preferenceCode == 'INSIDER') {
						rC_Bios__Preference__c preferenceToUpdate = new rC_Bios__Preference__c (
							Id = noInsiderPreference.Id,
							rC_Bios__Active__c = false
						);
						preferencesToUpdate.add(preferenceToUpdate);
					}
				}
			}
		}
		try {
			if(preferencesToInsert.size() > 0) {
				insert preferencesToInsert;
			}
			if(preferencesToUpdate.size() > 0) {
				update preferencesToUpdate;
			}
		}
		catch(Exception e) {
			System.debug('Error:' + e.getMessage());
			response.errorMessage = e.getMessage();
			response.success = false;
		}		

		return response;		
	}
	private static rC_Bios__Preference__c createPreference(Id contactId, String preferenceCode) {
		rC_Bios__Preference__c preference = new rC_Bios__Preference__c(
			RecordTypeId = preferenceGeneralTypeId,	
			rC_Bios__Contact__c = contactId,
			rC_Bios__Code_Value__c = preferenceCode,
			rC_Bios__Active__c = true
		);
		return preference;
	}
	private static rC_Bios__Preference__c getPreferenceWithCodeValue(Set<rC_Bios__Preference__c> preferences, String codeValue) {
		for(rC_Bios__Preference__c pref : preferences) {
			if(pref.rC_Bios__Code_Value__c == codeValue) {
				return pref;
			}
		}
		return null;
	}
	private static String createContact(SubscriptionRequest request) {
		String errorMessage = null;
		rC_Connect__Batch_Upload__c batch = new rC_Connect__Batch_Upload__c(
			rC_Connect__Preferences_1_Code_Value__c = request.preferenceCode,
			rC_Connect__Exclude_Giving__c = true,
			rC_Connect__Contact_1_First_Name__c = request.firstName,
			rC_Connect__Contact_1_Last_Name__c = request.lastName,
			rC_Connect__Contact_1_Email__c = request.email,
			Autoresponder_Email__c = request.email,
			rC_Connect__Contact_1_Phone_1__c = request.phone,
			rC_Connect__Address_Street_Line_1__c = request.streetAddress,
			rC_Connect__Address_State__c = request.state,
			rC_Connect__Address_City__c = request.city,
			rC_Connect__Address_Postal_Code__c = request.postalCode,
			rC_Connect__Address_Country_Name__c = request.country,
			Source_URL__c = request.sourceURL
		);
		if( ! String.isEmpty(request.mobilePhone)) {
			batch.rC_Connect__Contact_1_Phone_2__c = request.mobilePhone;
			batch.rC_Connect__Contact_1_Phone_2_Type__c = 'Mobile';
		}
		if( ! String.isEmpty(request.source)) {
			batch.rC_Connect__Batch_Upload_Campaign_Matched__c = request.source;
		}
		if(String.isEmpty(request.firstName)) {
			batch.rC_Connect__Contact_1_First_Name__c = 'Supporter';
		}
		if(String.isEmpty(request.lastName)) {
			batch.rC_Connect__Contact_1_Last_Name__c = 'Unknown';
		}
		if(request.preferenceCode == 'INSIDER') {
			batch.rC_Connect__Preferences_1_Code_Value__c = null;
		}
		try {
			insert batch;
		}
		catch(Exception e) {
			errorMessage = e.getMessage();
		}
		return errorMessage;
	}
	global class SubscriptionRequest {
		public String preferenceCode {get; set;}
		public String email {get; set;}
		public String firstName {get; set;}
		public String lastName {get; set;}
		public String streetAddress {get; set;}
		public String city {get; set;}
		public String state {get; set;}
		public String postalCode {get; set;}
		public String country {get; set;}
		public String phone {get; set;}
		public String mobilePhone {get; set;}
		public String source {get; set;}
		public String sourceURL {get; set;}
	}
	global class SubscriptionResponse {
		public Boolean isNewEmail {get; set;}
		public Integer numberAlreadySubscribed {get; set;}
		public Integer numberReactivated {get; set;}
		public Integer numberNewlySubscribed {get; set;}
		public Boolean success {get; set;}
		public String errorMessage {get; set;}
	}
}