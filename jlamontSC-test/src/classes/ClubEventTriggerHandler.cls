public without sharing class ClubEventTriggerHandler {
    private static Id eventId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    private static String userType = UserInfo.getUserType();
    public static Boolean testing = false;
    public static Boolean insertCompleted = false;
	public static void afterInsert(List<Club_Event__c> eventList) {
		if(testing) {
			return;
		}
		//If a ClubEvent was created by a community user,
		//create a Campaign from the ClubEvent
		if(EventHelper.sourceObject == 'Campaign' && ! Test.isRunningTest()) {
			return;
		}
		if(insertCompleted) {
			return;
		}
		
		List<Campaign> campList = new List<Campaign>();
		for(Club_Event__c evnt : eventList) {
			Campaign camp = new Campaign(
	            RecordTypeId = eventId,
				Name = getCampaignId(evnt), 
				Club_Event__c = evnt.Id 
			);
			camp = moveData(camp, evnt);
			campList.add(camp);
		}
		insert campList;
		Set<Id> campIdSet = new Set<Id>();
		for(Campaign camp : campList) {
			campIdSet.add(camp.Id);
		}
		campList = [
			SELECT Id, Club_Event__c, URL_to_Share__c
			FROM Campaign
			WHERE Id in :campIdSet
		];
		List<Club_Event__c> eventsToUpdate = new List<Club_Event__c>();
		for(Campaign camp : campList) {
			Club_Event__c evnt = new Club_Event__c(
				Id = camp.Club_Event__c,
				Campaign__c = camp.Id,
				URL_to_Share__c = camp.URL_to_Share__c
			);
			eventsToUpdate.add(evnt);
		}
		update eventsToUpdate;
		insertCompleted = true;
	}
	public static void afterUpdate(List<Club_Event__c> eventList) {
		//If a ClubEvent was modified by a community user,
		//modify corresponding Campaign
		if(EventHelper.sourceObject == 'Campaign') {
			return;
		}
		Set<Id> idSet = new Set<Id>();
		for(Club_Event__c evnt : eventList) {
			idSet.add(evnt.Campaign__c);
		}
		List<Campaign> campList = [
			SELECT Id, Club_Event__c FROM Campaign WHERE Id in :idSet
		];
		Map<Id, Campaign> campMap = new Map<Id, Campaign>();
		for(Campaign camp : campList) {
			campMap.put(camp.Club_Event__c, camp);
		}
		List<Campaign> campaignsToUpdate = new List<Campaign>();
		for(Club_Event__c ev : eventList) {
			Campaign camp = campMap.get(ev.Id);
			if(camp != null) {
				campaignsToUpdate.add(moveData(camp, ev));
			}
		}
		if(! campaignsToUpdate.isEmpty() ) {
			update campaignsToUpdate;
		}
	}
	public static void afterDelete(List<Club_Event__c> eventList) {
		//If a Club Event is deleted, delete associated Campaign
		//Only delete associated campaign if user requested to delete Club Event 
		if(EventLeaderTriggerHandler.leadersChecked == true) {
			return;
		}
		List<Campaign> campaignsToDelete = new List<Campaign>();
		for(Club_Event__c ev : eventList) {
			if(ev.Campaign__c != null) {
				campaignsToDelete.add(new Campaign(Id = ev.Campaign__c));
			}
		}
		if( ! campaignsToDelete.isEmpty() ) {
			delete campaignsToDelete;
		}
	}
	public static String getCampaignId(Club_Event__c clubEvent) {
		String eventNumber = clubEvent.Name.substring(4);
		String yearString = String.valueOf(Math.mod(clubEvent.CreatedDate.Year(), 1000));
		return '5' + ('00' + yearString).right(2) + 'Z' + eventNumber;
	}
	private static Campaign moveData(Campaign camp, Club_Event__c evnt) {
		camp.Additional_Directions__c = evnt.Additional_Directions__c;
		camp.Additional_Info_URL__c = evnt.Additional_Info_URL__c;
		camp.Publish_Date__c = evnt.Begin_Publication__c;
		camp.Bring__c = evnt.Bring__c;
		camp.Cancel_Reason__c = evnt.Cancel_Reason__c;
		camp.Cancellation_Option__c = evnt.Cancellation_Option__c;
		camp.Cancellation_Policy_Description__c = evnt.Cancellation_Policy_Description__c;
		camp.Carpool__c = evnt.Carpool__c;
		camp.Club_Entity__c = evnt.Club_Entity__c;
		camp.Cost_Description__c = evnt.Cost_Description__c;
		camp.Start_Date__c = evnt.Date_Begin__c;
		camp.End_Date__c = evnt.Date_End__c;
		camp.Date_Tentative__c = evnt.Date_Tentative__c;
		camp.Display_Method__c = evnt.Display_Method__c;
		camp.Entity_Specific_Level__c = evnt.Entity_Specific_Level__c;
		camp.Events_Category__c = evnt.Event_Category__c;
		camp.Location_Description__c = evnt.Location_Description__c;
		camp.Geocode__Latitude__s = evnt.Event_Location__Latitude__s;
		camp.Geocode__Longitude__s = evnt.Event_Location__Longitude__s;
		camp.Event_Name__c = evnt.Event_Title__c;
		camp.Events_Type__c = evnt.Event_Type__c;
		if(camp.Display_Method__c == 'External URL') {
			camp.External_URL__c = evnt.External_URL__c;
		}
		else {
			camp.External_URL__c = null;
		}
		camp.Sierra_Club_Activity__c = evnt.Is_Club_Activity__c;
		camp.Level__c = evnt.Level__c;
		camp.Limit_Publication__c = evnt.Limit_Publication__c;
		camp.Full_Description__c = evnt.Long_Description__c;
		camp.Summary_Description__c = evnt.Short_Description__c;
		if(evnt.Short_Description__c != null) {
			if(evnt.Short_Description__c.length() > 256) {
				camp.Sharing_Description__c = evnt.Short_Description__c.substring(0,256);
			}
			else {
				camp.Sharing_Description__c = evnt.Short_Description__c;
			}
		}
		camp.Signup_Instructions__c = evnt.Signup_Instructions__c;
		camp.Signup_Restrictions__c = evnt.Signup_Restrictions__c;
		camp.Sponsor_Description__c = evnt.Sponsor_Description__c;
		camp.Status__c = evnt.Status__c;
		camp.Start_Time__c = evnt.Time_Begin__c;
		camp.End_Time__c = evnt.Time_End__c;
		camp.Time_Tentative__c = evnt.Time_Tentative__c;
		camp.Unpublished_Notes__c = evnt.Unpublished_Notes__c;
		camp.URL_Description__c = evnt.URL_Description__c;
		camp.URL_for_Additional_Information__c = evnt.URL_for_Additional_Information__c;
		camp.Full_Description__c = evnt.Full_Description__c;
		camp.Registrations_Accepted__c = evnt.Registrations_Accepted__c;
		camp.Registration_Cutoff__c = evnt.Registration_Cutoff__c;
		camp.Send_RSVP_to_Leader__c = evnt.Send_RSVP_to_Leader__c;
		camp.Ask_for_Additional_Attendees__c = evnt.Ask_for_Additional_Attendees__c;
		camp.Ask_for_Mobile_Phone__c = evnt.Ask_for_Mobile_Phone__c;
		camp.Ask_for_Phone_Number__c = evnt.Ask_for_Phone_Number__c;
		camp.Ask_for_Street_Address__c = evnt.Ask_for_Street_Address__c;
		camp.Ask_for_ZIP_Code__c = evnt.Ask_for_ZIP_Code__c;
		camp.Custom_Field_1_Label__c = evnt.Custom_Field_1_Label__c;
		camp.Custom_Field_2_Label__c = evnt.Custom_Field_2_Label__c;
		camp.Custom_Field_3_Label__c = evnt.Custom_Field_3_Label__c;
		camp.Custom_Field_4_Label__c = evnt.Custom_Field_4_Label__c;
		camp.Custom_Field_5_Label__c = evnt.Custom_Field_5_Label__c;
		camp.Display_Field_1__c = evnt.Display_Field_1__c;
		camp.Display_Field_2__c = evnt.Display_Field_2__c;
		camp.Display_Field_3__c = evnt.Display_Field_3__c;
		camp.Display_Field_4__c = evnt.Display_Field_4__c;
		camp.Display_Field_5__c = evnt.Display_Field_5__c;
		camp.Require_Field_1__c = evnt.Require_Field_1__c;
		camp.Require_Field_2__c = evnt.Require_Field_2__c;
		camp.Require_Field_3__c = evnt.Require_Field_3__c;
		camp.Require_Field_4__c = evnt.Require_Field_4__c;
		camp.Require_Field_5__c = evnt.Require_Field_5__c;
		camp.Require_Mobile_Phone__c = evnt.Require_Mobile_Phone__c;
		camp.Require_Phone_Number__c = evnt.Require_Phone_Number__c;
		camp.Require_Street_Address__c = evnt.Require_Street_Address__c;
		camp.Require_ZIP_Code__c = evnt.Require_ZIP_Code__c;
		camp.Require_Additional_Attendees__c = evnt.Require_Additional_Attendees__c;
		camp.Unpublish_Date__c = evnt.Unpublish_Date__c;
		camp.Campaign_Strategy_Global__c = evnt.Campaign_Strategy_Global__c;
		camp.Local_Campaign_Global__c = evnt.Local_Campaign_Global__c;
		camp.National_Campaign_Global__c = evnt.National_Campaign_Global__c;
		camp.Marketing_Interest_Area_Global__c = evnt.Marketing_Interest_Area_Global__c;
		camp.Waiver_Required__c = evnt.Waiver_Required__c;
		camp.Marketing_Tags_Global__c = evnt.Marketing_Tags_Global__c;
		camp.Tactic_Owner_Category_Global__c = evnt.Tactic_Owner_Category_Global__c;
		camp.Tactic_Owner_Global__c = evnt.Tactic_Owner_Global__c;
		camp.State_Global__c = evnt.State_Global__c;
		camp.Local_Grassroots_Campaign__c = evnt.Local_Grassroots_Campaign__c;
		camp.Do_not_show_on_website_calendars__c = evnt.Do_not_show_on_website_calendars__c;
		camp.Autoresponder_Subject_Line__c = 'Thank you for registering for ' + evnt.Event_Title__c;
		camp.Recurring_Dates__c = evnt.Recurring_Dates__c;
		camp.RecurringEvent__c = evnt.RecurringEvent__c;
		
		return camp;
	} 
}