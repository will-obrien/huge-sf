/*
UpsertMobileIntegrationRequests

Called by EventRegistrationTrigger and AdvocacyActionTrigger

If phone is entered on an EventRegistration or Advocacy Action, create or update Mobile Integration Request

Mark Maslow - January 2017
*/
public without sharing class UpsertMobileIntegrationRequests {
	public static Set<String> badPhoneEnd = new Set<String> {'1111111','2222222','3333333','4444444','5555555','6666666','7777777','8888888','9999999','0000000','1234567','4567890','5551212'};
	public static Set<String> badPhoneStart = new Set<String> {'111','222','333','444','555','666','777','888','999','000'};
	
	public static void upsertRequests(List<MobileIntegrationParameters> parmsList) {
		Map<String, MobileIntegrationParameters> phoneToContactMap = new Map<String, MobileIntegrationParameters>();
		for(MobileIntegrationParameters mip : parmsList) {
			if(mip.phone != null) {
				String phoneDigits = mip.phone.replaceAll('\\D+', '');
				if(phoneDigits.length() == 11 && phoneDigits.startsWith('1')) {
					phoneDigits = phoneDigits.substring(1);
				}
				if(isValidPhone(phoneDigits)) {
					phoneToContactMap.put(phoneDigits, mip);
				}
			}
		}
		
		List<Mobile_Integration_Request__c> requestsToUpsert = new List<Mobile_Integration_Request__c>();
		Map<String, Mobile_Integration_Request__c> phoneToRequestMap = new Map<String, Mobile_Integration_Request__c>();
		
		List<Mobile_Integration_Request__c> existingRequests = [
			select Id, Contact__c, Phone_Key__c from Mobile_Integration_Request__c
			where Phone_Key__c in :phoneToContactMap.keySet()
		];
		for(Mobile_Integration_Request__c req : existingRequests) {
			phoneToRequestMap.put(req.Phone_Key__c, req); 
		}

		for(String phoneDigits : phoneToContactMap.keySet()) {
			MobileIntegrationParameters mip = phoneToContactMap.get(phoneDigits);
			Mobile_Integration_Request__c req = phoneToRequestMap.get(phoneDigits);
			if(req == null) {
				Mobile_Integration_Request__c newRequest = new Mobile_Integration_Request__c(
					Contact__c = mip.contactId,
					Phone_Key__c = phoneDigits,
					Phone__c = mip.phone,
					Opt_In_Source__c = mip.optInSource
				);
				newRequest.Advocacy_Action__c = mip.advocacyActionId;
				newRequest.Event_Registration__c  = mip.eventRegistrationId;
				requestsToUpsert.add(newRequest);
			}
			else {
				Mobile_Integration_Request__c updatedRequest = new Mobile_Integration_Request__c(
					Id = req.Id,
					Contact__c = mip.contactId,
					Opt_In_Source__c = mip.optInSource
				);
				updatedRequest.Advocacy_Action__c = mip.advocacyActionId;
				updatedRequest.Event_Registration__c  = mip.eventRegistrationId;
				requestsToUpsert.add(updatedRequest);
			} 
		}
		if( ! requestsToUpsert.isEmpty()) {
			upsert requestsToUpsert;
		}		
	}
	private static Boolean isValidPhone(String digits) {
		if(digits.length() != 10) {
			return false;
		}
		if(digits.startsWith('1')) {
			return false;
		}
		String phoneStart = digits.substring(0,3);
		String phoneEnd = digits.substring(3);

		if(badPhoneStart.contains(phoneStart) || badPhoneEnd.contains(phoneEnd)) {
			return false;
		}		
		
		return true;
	}
	public Class MobileIntegrationParameters {
		public Id contactId;
		public String phone;
		public Id advocacyActionId;
		public Id eventRegistrationId;
		public String optInSource;
		public MobileIntegrationParameters(Id contactId, String phone, String optInSource) {
			this.contactId = contactId;
			this.phone = phone;
			this.optInSource = optInSource;
		}
	}
}