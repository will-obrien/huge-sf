/*
AdvocacyActionMCTriggerHandler

Called by AdvocacyActionTrigger - after insert, after update

If phone is entered on an Advocacy Action, call UpsertMobileIntegrationRequests to create or update Mobile Integration Request

Test coverage is via UpsertMobileIntegrationRequestsTest

Mark Maslow - January 2017
*/
public without sharing class AdvocacyActionMCTriggerHandler {
	public static void handleChange() {
		List<UpsertMobileIntegrationRequests.MobileIntegrationParameters> contactList = new List<UpsertMobileIntegrationRequests.MobileIntegrationParameters>();
		if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) ) {
			List<kweos__EOCS_Data__c> actionList = Trigger.new;
			for(kweos__EOCS_Data__c action : actionList) {
				if(Trigger.isInsert) {
					if(action.Mobile_Opt_In__c == true) {
						if( ! String.isEmpty(action.kwac__Contact__c) ) {
							if( ! String.isEmpty(action.kweos__Phone__c)) {
								UpsertMobileIntegrationRequests.MobileIntegrationParameters parm = new UpsertMobileIntegrationRequests.MobileIntegrationParameters(
									action.kwac__Contact__c,
									action.kweos__Phone__c,
									'Advocacy Action'
								);
								parm.advocacyActionId = action.Id;
								contactList.add(parm);
							}
						}
					}
				}
				else if(Trigger.isUpdate) {
					if(action.Mobile_Opt_In__c == true) {
						if( ! String.isEmpty(action.kwac__Contact__c) ) {
							if( ! String.isEmpty(action.kweos__Phone__c)) {
								kweos__EOCS_Data__c oldAction = (kweos__EOCS_Data__c) Trigger.oldMap.get(action.Id);
								if(String.isEmpty(oldAction.kwac__Contact__c) || String.isEmpty(oldAction.kweos__Phone__c)) {
									UpsertMobileIntegrationRequests.MobileIntegrationParameters parm = new UpsertMobileIntegrationRequests.MobileIntegrationParameters(
										action.kwac__Contact__c,
										action.kweos__Phone__c,
										'Advocacy Action'
									);
									parm.advocacyActionId = action.Id;
									contactList.add(parm);
								}
							}
						}
					}
				}
			}
		}
		if( ! contactList.isEmpty() ) {
			UpsertMobileIntegrationRequests.upsertRequests(contactList);
		}
	}
}