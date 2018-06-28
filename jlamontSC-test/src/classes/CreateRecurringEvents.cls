public without sharing class CreateRecurringEvents implements Queueable {
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
	private Id originalEventId;
	
	public CreateRecurringEvents(Id eventId) {
		this.originalEventId = eventId;
	}
	
	public void execute(QueueableContext context) {
		Campaign originalCamp = [
			select
				Id,
				RecordTypeId,
				Additional_Directions__c,
				Additional_Info_URL__c,
				Publish_Date__c,
				Bring__c,
				Cancel_Reason__c,
				Cancellation_Option__c,
				Cancellation_Policy_Description__c,
				Carpool__c,
				Club_Entity__c,
				Cost_Description__c,
				Start_Date__c,
				End_Date__c,
				Date_Tentative__c,
				Display_Method__c,
				Entity_Specific_Level__c,
				Events_Category__c,
				Geocode__Latitude__s,
				Geocode__Longitude__s,
				Event_Name__c,
				Events_Type__c,
				External_URL__c,
				Sierra_Club_Activity__c,
				Level__c,
				Limit_Publication__c,
				Full_Description__c,
				Summary_Description__c,
				Signup_Instructions__c,
				Signup_Restrictions__c,
				Sponsor_Description__c,
				Status__c,
				Start_Time__c,
				End_Time__c,
				Time_Tentative__c,
				Unpublished_Notes__c,
				URL_Description__c,
				URL_for_Additional_Information__c,
				URL_to_Share__c,
				Registrations_Accepted__c,
				Registration_Cutoff__c,
				Send_RSVP_to_Leader__c,
				Ask_for_Additional_Attendees__c,
				Ask_for_Mobile_Phone__c,
				Ask_for_Phone_Number__c,
				Ask_for_Street_Address__c,
				Ask_for_ZIP_Code__c,
				Custom_Field_1_Label__c,
				Custom_Field_2_Label__c,
				Custom_Field_3_Label__c,
				Custom_Field_4_Label__c,
				Custom_Field_5_Label__c,
				Display_Field_1__c,
				Display_Field_2__c,
				Display_Field_3__c,
				Display_Field_4__c,
				Display_Field_5__c,
				Require_Field_1__c,
				Require_Field_2__c,
				Require_Field_3__c,
				Require_Field_4__c,
				Require_Field_5__c,
				Require_Mobile_Phone__c,
				Require_Phone_Number__c,
				Require_Street_Address__c,
				Require_ZIP_Code__c,
				Require_Additional_Attendees__c,
				Unpublish_Date__c,
				Marketing_Interest_Area_Global__c,
				Club_Event__c,
				Campaign_Strategy_Global__c,
				National_Campaign_Global__c,
				Local_Campaign_Global__c,
				Waiver_Required__c,
				Marketing_Tags_Global__c,
				Location_Description__c,
				Tactic_Owner_Category_Global__c,
				Tactic_Owner_Global__c,
				State_Global__c,
				Local_Grassroots_Campaign__c,
				Do_not_show_on_website_calendars__c,
				Recurring_Dates__c,
				RecurringEvent__c
			from Campaign
			where Id = :originalEventId
		];
		
		List<DateTime> dateTimeList = (List<DateTime>)System.Json.deserialize(originalCamp.Recurring_Dates__c, List<DateTime>.class);
		List<Campaign> campList = new List<Campaign>();
		for(Integer idx = 1; idx < dateTimeList.size(); idx ++) {
			Campaign newCamp = originalCamp.clone(false, true);
			newCamp.Name = 'NewRecur';
			newCamp.Club_Event__c = null;
			newCamp.URL_to_Share__c = null;
			newCamp.Start_Date__c = dateTimeList.get(idx).date();
			if(originalCamp.End_Date__c != null) {
				newCamp.End_Date__c = newCamp.Start_Date__c;
			}
			campList.add(newCamp);
		}
		AutoNameCampaigns.setNames(campList);
		EventsCampaignTriggerHandler.checkLeaders = false;
		EventLeaderTriggerHandler.leadersChecked = true;
		insert campList;
		Set<Id> campIds = new Set<Id>();
		for(Campaign camp : campList) {
			campIds.add(camp.Id);
		}
		Map<Id, Campaign> campMap = new Map<Id, Campaign>([
			select Id, Club_Event__c from Campaign where Id in :campIds
		]);
		
		List<Event_Leader__c> leaderList = [
			select
				Id,
              	Contact__c, 
               	Phone_or_Other_Contact_Information__c, 
               	Email__c, 
               	Leader_Name__c, 
               	Is_Primary_Leader__c,
               	RecurringEventLeader__c
            from Event_Leader__c
            where Campaign__c = :originalEventId
		];

		List<Event_Leader__c> leadersToInsert = new List<Event_Leader__c>();
		for(Event_Leader__c ldr : leaderList) {
			for(Integer idx = 0; idx < campList.size(); idx ++) {
				Event_Leader__c newLdr = ldr.clone(false, true);
				newLdr.Campaign__c = campList.get(idx).Id;
				newLdr.Club_Event__c = campMap.get(newLdr.Campaign__c).Club_Event__c;
				leadersToInsert.add(newLdr);
			}
		}
		insert leadersToInsert;
	}
}