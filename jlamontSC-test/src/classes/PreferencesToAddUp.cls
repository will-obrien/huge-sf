/*************************************************************************
	PreferencesToAddUp
	
	Called by PreferenceTrigger
	
	If any Preferences that AddUp is interested in have changed, enqueue an instance 
	of PreferenceToAddUpSender to send messages to BSD

	2016/08		Mark Maslow		Original
*/
public with sharing class PreferencesToAddUp {
	public static Boolean sendToAddUp = true;

	public static void sendPreferences(Boolean isNew, List<rC_Bios__Preference__c> newList, Map<Id, rC_Bios__Preference__c> oldMap) {
		Map<String, String> SCPrefToAddupPref = new Map<String, String>();
		SCPrefToAddupPref.put('No AddUP Campaign Updates', 'email_opt_in_campaign_updates');
		SCPrefToAddupPref.put('No AddUP Campaign Recommendations', 'email_opt_in_user_recommendations');
		SCPrefToAddupPref.put('No AddUP Friend Recommendations', 'email_opt_in_fb_friend_recommendations');
		SCPrefToAddupPref.put('No AddUp Email', 'email_opt_in');
		
		Map<Id, String> contactIdToAddupId = new Map<Id, String>();
		Set<Id> contactIds = new Set<Id>();
		List<rC_Bios__Preference__c> prefsToWork = new List<rC_Bios__Preference__c>();
		for(rC_Bios__Preference__c pref : newList) {
			if(! String.isEmpty(pref.rC_Bios__Contact__c) ) {
				String addUpPref = SCPrefToAddUpPref.get(pref.rC_Bios__Subcategory__c);
				if(addUpPref != null) {
					if(isNew) {
						if(pref.rC_Bios__Active__c) {
							prefsToWork.add(pref);
							contactIds.add(pref.rC_Bios__Contact__c);
						}
					}
					else {
						rC_Bios__Preference__c oldPref = oldMap.get(pref.Id);
						if(pref.rC_Bios__Subcategory__c != oldPref.rC_Bios__Subcategory__c || pref.rC_Bios__Active__c != oldPref.rC_Bios__Active__c) {
							prefsToWork.add(pref);
							contactIds.add(pref.rC_Bios__Contact__c);
						}
					}
				}
			}
		}
		List<Contact> contactList = [
			select Id, Website_System_Id__c 
			from Contact
			where Id in :contactIds 
		];
		for(Contact ctct : contactList) {
			contactIdToAddupId.put(ctct.Id, ctct.Website_System_Id__c);
		}
		for(rC_Bios__Preference__c pref : prefsToWork) {
			String addUpId = contactIdToAddupId.get(pref.rC_Bios__Contact__c);
			if(addUpId != null) {
				String addUpPref = SCPrefToAddUpPref.get(pref.rC_Bios__Subcategory__c);
			    PreferencesToAddUpSender sender = new PreferencesToAddUpSender(addUpId, addUpPref, (! pref.rC_Bios__Active__c));
			    System.enqueueJob(sender);
			}
						
		}
	}
}