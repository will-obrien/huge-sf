/*
 * 2/27/2017 Maslow - Check to ensure that there is a phone number before adding to phoneSet 
*/
public with sharing class MobileSubscriberContactUpdate {
	public static void handleUpdate(List<Contact> newValues, Map<Id, Contact> oldMap) {
		List<Contact> contactsToUpdate = new List<Contact>();
		List<UpsertMobileIntegrationRequests.MobileIntegrationParameters> MIRRequestsToUpdate = new List<UpsertMobileIntegrationRequests.MobileIntegrationParameters>();
		
		Set<String> phoneSet = new Set<String>();
		for(Contact ctct : newValues) {
            String phoneDigits = getPhoneDigits(ctct.Phone);
            if(String.isNotBlank(phoneDigits)) {
				phoneSet.add(phoneDigits);
            }
		}
        System.debug('phoneSet: ' + phoneSet);
		List<Mobile_Integration_Request__c> mirList = [
			select Phone_Key__c from Mobile_Integration_Request__c
			where Phone_Key__c in :phoneSet
		];
		Set<String> phonesWithMobileRequests = new Set<String>();
		for(Mobile_Integration_Request__c mir : mirList) {
			phonesWithMobileRequests.add(mir.Phone_Key__c);
		}
		
		for(Contact ctct : newValues) {
			if(ctct.Mobile_Subscriber__c == true) {
				Contact oldContact = oldMap.get(ctct.Id);
				if(oldContact != null) {
					Boolean removeMobileSubscription = false;
					if(String.isEmpty(ctct.Phone)) {
						removeMobileSubscription = true;
					}
					else {
						String oldPhoneDigits = getPhoneDigits(oldContact.Phone);
						String newPhoneDigits = getPhoneDigits(ctct.Phone);
						if(oldPhoneDigits != newPhoneDigits) {
							if( ! phonesWithMobileRequests.contains(newPhoneDigits)) {
								removeMobileSubscription = true;
							}
						}
					}
					if(removeMobileSubscription) {
						contactsToUpdate.add(new Contact(Id=ctct.Id, Mobile_Subscriber__c = false));
					}
					else {
						if(phonesWithMobileRequests.contains(getPhoneDigits(ctct.Phone))) {
							if(	oldContact.Email != ctct.Email ||
								oldContact.FirstName != ctct.FirstName ||
								oldContact.LastName != ctct.LastName ||
								oldContact.MailingStreet != ctct.MailingStreet ||
								oldContact.MailingCity != ctct.MailingCity ||
								oldContact.MailingPostalCode != ctct.MailingPostalCode ||
								oldContact.MailingCountry != ctct.MailingCountry 
							) {
								MIRRequestsToUpdate.add(new UpsertMobileIntegrationRequests.MobileIntegrationParameters(
									ctct.Id, ctct.Phone, 'Contact'
								)); 
							}
						}
					}
				}
			}
		}
		if( ! contactsToUpdate.isEmpty() ) {
			update contactsToUpdate;
		}
		if( ! MIRRequestsToUpdate.isEmpty() ) {
			UpsertMobileIntegrationRequests.upsertRequests(MIRRequestsToUpdate);
		}
	}
	private static String getPhoneDigits(String phone) {
		if(String.isEmpty(phone)) {
			return '';
		}
		String phoneDigits = phone.replaceAll('\\D+', '');
		if(phoneDigits.length() == 11) {
			phoneDigits = phoneDigits.substring(1);
		}
		return phoneDigits;
	}
}