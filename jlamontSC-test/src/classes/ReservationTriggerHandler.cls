public class ReservationTriggerHandler {

	public static void addExplorerPreference(List<Reservation__c> res) {

		//get list of reservations where contact has an email
		List<Reservation__c> newRes = new List<Reservation__c>([SELECT Id,Contact__r.Id,Contact__r.Email FROM Reservation__c WHERE Id IN :res AND Contact__r.Email != null]);

		//add Contact IDs to a set
		Set<Id> incomingContacts = new Set<Id>();
		for (Reservation__c r : newRes) {
			incomingContacts.add(r.Contact__r.Id);
		}

		//find all existing Explorer preferences
		List<rC_Bios__Preference__c> existingSubscribers = new List<rC_Bios__Preference__c>([SELECT Id, rC_Bios__Contact__r.Id FROM rC_Bios__Preference__c WHERE rC_Bios__Code_Value__c = 'EXPLORER' AND rC_Bios__Contact__c IN :incomingContacts]);
		
		//for each Explorer preference, add the Contact Id to a set to check against
		Set<Id> existingSubscriberIds = new Set<Id>();
		for (rC_Bios__Preference__c p : existingSubscribers) {
			existingSubscriberIds.add(p.rC_Bios__Contact__r.Id);
		}

		List<rC_Bios__Preference__c> prefToInsert = new List<rC_Bios__Preference__c>();

		//if incoming contact is not in existing subscriber set, create a preference
		for (Id i : incomingContacts) {
			if (!existingSubscriberIds.contains(i)) {
				rC_Bios__Preference__c pref = new rC_Bios__Preference__c(
					rC_Bios__Contact__c = i,
					rC_Bios__Code_Value__c = 'EXPLORER');
				prefToInsert.add(pref);
			}
		}

		if (prefToInsert.size()>0) {
			insert prefToInsert;
		}


	}
}