public without sharing class EventsCampaignTriggerHandler {
    private static Id eventsTypeId;
    private static String defaultClubEntityId;
    private static String userType = UserInfo.getUserType();
    public static Boolean checkLeaders = true;
    static {
        eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    }
    private static String getDefaultClubEntityId() {
    	if(defaultClubEntityId == null) {
    		List<Club_Entity__c> entList = [
    			select Id from Club_Entity__c where EntityId__c = 'CLUB'
    		];
    		if(entList.isEmpty()) {
    			defaultClubEntityId = null;
    		}
    		else {
    			defaultClubEntityId = entList.get(0).Id;
    		}
    	}
    	return defaultClubEntityId;
    }
    public static void beforeInsertUpdate(List<Campaign> newCampaigns, Map<Id, Campaign> oldMap) {
    	List<Campaign> eventList = new List<Campaign>();
    	Set<Id> eventIds = new Set<Id>();
    	for(Campaign camp : newCampaigns) {
    		if(camp.RecordTypeId == eventsTypeId) {
    			eventList.add(camp);
    			eventIds.add(camp.Id);
    		}
    	}
    	if( ! eventIds.isEmpty() ) {
	    	List<Event_Leader__c>ldrList = [select Id, Campaign__c, Email__c from Event_Leader__c where Campaign__c in :eventIds and Is_Primary_Leader__c = true];
	    	Set<Id> eventsWithLeaders = new Set<Id>();
	    	Map<Id, Event_Leader__c> ldrMap = new Map<Id, Event_Leader__c>();
	    	for(Event_Leader__c ldr : ldrList) {
	    		eventsWithLeaders.add(ldr.Campaign__c);
	    		ldrMap.put(ldr.Campaign__c, ldr);
	    	}
	    	editEvents(eventList, oldMap, eventsWithLeaders, ldrMap);
    	}
	}

    public static void afterInsert(List<Campaign> insertedCampaigns) {
    	String baseURL = null;
    	if(Test.isRunningTest()) {
			baseURL = 'http://www.test.org';    			
    	}
    	else {
			Map<String, SiteURL__c> urlMap = SiteURL__c.getAll();
			SiteURL__c siteURL = urlMap.get('EventsURL');
			baseURL = siteURL.BaseURL__c;
    	}
    	List<Campaign> campsToUpdate = new List<Campaign>();
    	Map<Id, String> campaignToURL = new Map<Id, String>();
    	for(Campaign camp : insertedCampaigns) {
    		if(camp.RecordTypeId == eventsTypeId) {
				String URL_to_Share = null;
    			if(camp.Display_Method__c == 'Salesforce Events Page') {
   					URL_to_Share = baseURL + '?formcampaignid=' + camp.Id;
    			}
    			else {
    				URL_to_Share = camp.External_URL__c;
    			}
				if(URL_to_Share != null) {
					Campaign campToUpdate = new Campaign(
						Id = camp.Id,
						URL_to_Share__c = URL_to_Share
					);
					campsToUpdate.add(campToUpdate);
					campaignToURL.put(campToUpdate.Id, campToUpdate.URL_to_Share__c);
				}
    		}
    	}
		if( ! campsToUpdate.isEmpty()) {
			update campsToUpdate;
			if(EventHelper.sourceObject == 'Campaign') {
				createClubEvents(insertedCampaigns, campaignToURL);
			}
		}
    }
	public static void afterUpdate(List<Campaign> updatedCampaigns) {
		if(EventHelper.sourceObject == 'Campaign') {
			List<Club_Event__c> eventsToUpdate = new List<Club_Event__c>();
			for(Campaign camp : updatedCampaigns) {
	    		if(camp.RecordTypeId == eventsTypeId && ! String.isEmpty(camp.Club_Event__c)) {
					Club_Event__c eventToUpdate = new Club_Event__c(
						Id = camp.Club_Event__c 
					);
					eventsToUpdate.add(moveData(eventToUpdate, camp));
				}
			}
			if( ! eventsToUpdate.isEmpty()) {
				update eventsToUpdate;
			}
		}
	}
	
    public static void beforeDelete(List<Campaign> oldCampaignList) {
    	Set<Id> idSet = new Set<Id>();
    	for(Campaign camp : oldCampaignList) {
    		if(camp.RecordTypeId == eventsTypeId) {
    			idSet.add(camp.Id);
    		}
    	}
    	if(idSet.isEmpty()) {
    		return;
    	}
    	List<Event_Leader__c> ldrList = [
    		select Id from Event_Leader__c
    		where Campaign__c in :idSet
    	];
		List<Event_Registration__c> regList = [
			select Id from Event_Registration__c
			where Campaign__c in :idSet
		];
		List<Club_Event__c> clubEventList = [
			select Id from Club_Event__c
			where Campaign__c in :idSet
		];

		if( ! ldrList.isEmpty()) {
			EventLeaderTriggerHandler.leadersChecked = true;
			delete ldrList;
		}
		if( ! regList.isEmpty()) {
			delete regList;
		}
		if( ! clubEventList.isEmpty()) {
			delete clubEventList;
		}
    }
	
	private static void editEvents(List<Campaign> eventList, Map<Id, Campaign>oldMap, Set<Id> eventsWithLeaders, Map<Id, Event_Leader__c> ldrMap) {
		for(Campaign evnt : eventList) {
			if( ! isValidTime(evnt.Start_Time__c)) {
				evnt.Start_Time__c.addError('Start Time must be in format h:mm AM/PM');
			}
			if(evnt.End_Date__c == null) {
				if( ! String.isEmpty(evnt.End_Time__c)) {
					evnt.End_Time__c.addError('If an End Time is entered, an End Date is required');
				}
			}
			else {
				if(evnt.End_Date__c < evnt.Start_Date__c) {
					evnt.End_Date__c.addError('End Date cannot be before Start Date');					
				}
				if(String.isEmpty(evnt.End_Time__c)) {
					evnt.End_Time__c.addError('If an End Date is entered, an End Time is required');
				}
			}
			if( ! String.isEmpty(evnt.End_Time__c)) {
				if( ! isValidTime(evnt.End_Time__c)) {
					evnt.End_Time__c.addError('End Time must be in format h:mm AM/PM');
				}
			}
			if(evnt.Status__c != 'In Development') {
				if(evnt.Publish_Date__c == null) {
					evnt.Publish_Date__c = System.today();
				}
				if(evnt.Unpublish_Date__c == null) {
					if(evnt.End_Date__c == null) {
						evnt.Unpublish_Date__c = evnt.Start_Date__c.addMonths(1);
					}
					else {
						evnt.Unpublish_Date__c = evnt.End_Date__c.addMonths(1); 
					}
				}
			}
	   		if(evnt.Require_Field_1__c) {
    			evnt.Display_Field_1__c = true;
    		}
    		if(evnt.Require_Field_2__c) {
    			evnt.Display_Field_2__c = true;
    		}
    		if(evnt.Require_Field_3__c) {
    			evnt.Display_Field_3__c = true;
    		}
    		if(evnt.Require_Field_4__c) {
    			evnt.Display_Field_4__c = true;
    		}
    		if(evnt.Require_Field_5__c) {
    			evnt.Display_Field_5__c = true;
    		}
    		if(evnt.Require_Phone_Number__c) {
    			evnt.Ask_for_Phone_Number__c = true;
    		}
    		if(evnt.Require_ZIP_Code__c) {
    			evnt.Ask_for_ZIP_Code__c = true;
    		}
    		if(evnt.Require_Street_Address__c) {
    			evnt.Ask_for_Street_Address__c = true;
    		}
    		if(String.isEmpty(evnt.Sponsor_Description__c)) {
    			if( ! String.isEmpty(evnt.Club_Entity__c)) {
    				evnt.Sponsor_Description__c = [select Name from Club_Entity__c where Id = :evnt.Club_Entity__c].Name;
    			}
    		}
    		if(evnt.Id == null) {
	    		if(String.isEmpty(evnt.Sponsor_Description__c)) {
	    			evnt.addError('A Sponsor Description is Required if no Club Entity is chosen');
	    		}
    		}
    		if(evnt.Send_RSVP_to_Leader__c && ( ! evnt.Registrations_Accepted__c)) {
    			evnt.addError('Registrations Accepted must be set to true in order to Send RSVP Notifications');
    		}
 			if(evnt.Status__c == 'Active' && EventHelper.sourceObject == 'Campaign' && checkLeaders) {
 				if( ! eventsWithLeaders.contains(evnt.Id)) {
					evnt.addError('To be made Active, an Event must have a Primary Leader');
				}
				else {
					if(evnt.Send_RSVP_to_Leader__c) {
						Event_Leader__c ldr = ldrMap.get(evnt.Id);
						if(ldr != null) {
							if(String.isEmpty(ldr.Email__c)) {
								evnt.addError('To Send RSVP notifications, you must specify Email of Primary Leader');
							}
						}
					}
				}
			}
			else if(evnt.Status__c == 'At Capacity' || evnt.Status__c == 'Cancelled') {
				Boolean invalidStatus = false;
				if(oldMap == null) {
					invalidStatus = true;
				}
				else {
					Campaign oldCamp = oldMap.get(evnt.Id);
					if(oldCamp != null) {
						if(evnt.Status__c != oldCamp.Status__c) {
							if(oldCamp.Status__c != 'Active' && oldCamp.Status__c != 'At Capacity') {
								invalidStatus = true;
							}
						}
					}
				}
				if(invalidStatus) {
					evnt.addError('Only Active Events can have Status changed to \'At Capacity\' or \'Cancelled\'');
				}
			}
			if( ! String.isEmpty(evnt.Id)) {
		    	String baseURL = null;
				if(evnt.Display_Method__c == 'Salesforce Events Page') {
			    	if(Test.isRunningTest()) {
						baseURL = 'http://www.test.org';    			
			    	}
			    	else {
						Map<String, SiteURL__c> urlMap = SiteURL__c.getAll();
						SiteURL__c siteURL = urlMap.get('EventsURL');
						baseURL = siteURL.BaseURL__c;
			    	}
					evnt.URL_to_Share__c = baseURL + '?formcampaignid=' + evnt.Id;
					evnt.External_URL__c = null;
				}
				else {
					if(String.isEmpty(evnt.External_URL__c)) {
						evnt.addError('An External URL is required if Display Method is not \"Salesforce Events Page\"');
					}
					else {
						evnt.URL_to_Share__c = evnt.External_URL__c;
					}
				}
			}
			if(String.isEmpty(evnt.Autoresponder_Subject_Line__c)) {
				evnt.Autoresponder_Subject_Line__c = 'Thank you for registering for ' + evnt.Event_Name__c;
			}
            //replace smart quotes with regular quotes
            if( ! String.isEmpty(evnt.Event_Name__c)) {
	            evnt.Event_Name__c = evnt.Event_Name__c.replaceAll('[\u2018\u2019\u201A\u201B\u2032\u2035]', '\'');
	 			evnt.Event_Name__c = evnt.Event_Name__c.replaceAll('[\u201C\u201D\u201E\u201F\u2033\u2036]','"');
            }
            if( ! String.isEmpty(evnt.Summary_Description__c)) {
				evnt.Summary_Description__c = evnt.Summary_Description__c.replaceAll('[\u2018\u2019\u201A\u201B\u2032\u2035]', '\''); 			
				evnt.Summary_Description__c = evnt.Summary_Description__c.replaceAll('[\u201C\u201D\u201E\u201F\u2033\u2036]','"');
            }
            if(evnt.Events_Category__c == 'Outing') {
            	evnt.Waiver_Required__c = true;
            }
            if(evnt.Club_Entity__c == null) {
            	evnt.Club_Entity__c = getDefaultClubEntityId();
            } 			
		}
	}
	//Check for format  hh:mm AM
	private static boolean isValidTime(String input) {
		if(String.isEmpty(input)) {
			return false;
		}
		//Must contain exactly 1 colon	
		if( ! input.contains(':')) {
			return false;
		}
		String[] parts = input.split(':');
		if(parts.size() != 2) {
			return false;
		}
		//Hour must be a number between 1 and 12 
		String hourString = parts[0];
		if(! hourString.isNumeric()) {
			return false;
		}
		Integer hourNumber = Integer.valueOf(hourString);
		if(hourNumber < 1 || hourNumber > 12) {
			return false;
		}
		//After colon, input must contain minutes, followed by space, followed by AM or PM
		String[] parts2 = parts[1].split(' ');
		if(parts2.size() != 2) {
			return false;
		}
		//Minutes must be a number between 0 and 59
		if(! parts2[0].isNumeric()) {
			return false;
		}
		if(Integer.valueOf(parts2[0]) > 59) {
			return false;
		}
		//Must specify AM or PM
		String amPm = parts2[1].trim().toUpperCase();
		if(amPm != 'AM' && amPm != 'PM') {
			return false;
		}
		return true;
	}
	private static void createClubEvents(List<Campaign> campList, Map<Id, String> urlMap) {
		List<Club_Event__c> evntList = new List<Club_Event__c>();
		for(Campaign camp : campList) {
    		if(camp.RecordTypeId == eventsTypeId) {
    			String URLtoShare = urlMap.get(camp.Id);
				Club_Event__c evnt = new Club_Event__c(
					Campaign__c = camp.Id,
					URL_to_Share__c = urlToShare
				);
				evntList.add(moveData(evnt, camp));
    		}
		}
		if( ! evntList.isEmpty()) {
			insert evntList;
			List<Campaign> campsToUpdate = new List<Campaign>();
			for(Club_Event__c evnt : evntList) {
				Campaign camp = new Campaign(
					Id = evnt.Campaign__c,
					Club_Event__c = evnt.Id
				);
				campsToUpdate.add(camp);
			}
			update campsToUpdate;
		}
	}
	private static Club_Event__c moveData(Club_Event__c evnt, Campaign camp) {
		evnt.Additional_Directions__c = camp.Additional_Directions__c;
		evnt.Additional_Info_URL__c = camp.Additional_Info_URL__c;
		evnt.Begin_Publication__c = camp.Publish_Date__c;
		evnt.Bring__c = camp.Bring__c;
		evnt.Cancel_Reason__c = camp.Cancel_Reason__c;
		evnt.Cancellation_Option__c = camp.Cancellation_Option__c;
		evnt.Cancellation_Policy_Description__c = camp.Cancellation_Policy_Description__c;
		evnt.Carpool__c = camp.Carpool__c;
		evnt.Club_Entity__c = camp.Club_Entity__c;
		evnt.Cost_Description__c = camp.Cost_Description__c;
		evnt.Date_Begin__c = camp.Start_Date__c;
		evnt.Date_End__c = camp.End_Date__c;
		evnt.Date_Tentative__c = camp.Date_Tentative__c;
		evnt.Display_Method__c = camp.Display_Method__c;
		evnt.URL_to_Share__c = camp.URL_to_Share__c;
		evnt.Entity_Specific_Level__c = camp.Entity_Specific_Level__c;
		evnt.Event_Category__c = camp.Events_Category__c;
		evnt.Location_Description__c = camp.Location_Description__c;
		evnt.Event_Location__Latitude__s = camp.Geocode__Latitude__s;
		evnt.Event_Location__Longitude__s = camp.Geocode__Longitude__s;
		if(evnt.Event_Location__Latitude__s != null && evnt.Event_Location__Longitude__s != null) {
			evnt.Show_on_Map__c = true;
		}
		else {
			evnt.Show_on_Map__c = false;
		}
		evnt.Event_Title__c = camp.Event_Name__c;
		evnt.Event_Type__c = camp.Events_Type__c;
		evnt.External_URL__c = camp.External_URL__c;
		evnt.Is_Club_Activity__c = camp.Sierra_Club_Activity__c;
		evnt.Level__c = camp.Level__c;
		evnt.Limit_Publication__c = camp.Limit_Publication__c;
		evnt.Long_Description__c = camp.Full_Description__c;
		evnt.Short_Description__c = camp.Summary_Description__c;
		evnt.Signup_Instructions__c = camp.Signup_Instructions__c;
		evnt.Signup_Restrictions__c = camp.Signup_Restrictions__c;
		evnt.Sponsor_Description__c = camp.Sponsor_Description__c;
		evnt.Status__c = camp.Status__c;
		evnt.Time_Begin__c = camp.Start_Time__c;
		evnt.Time_End__c = camp.End_Time__c;
		evnt.Time_Tentative__c = camp.Time_Tentative__c;
		evnt.Unpublished_Notes__c = camp.Unpublished_Notes__c;
		evnt.URL_Description__c = camp.URL_Description__c;
		evnt.URL_for_Additional_Information__c = camp.URL_for_Additional_Information__c;
		evnt.Full_Description__c = camp.Full_Description__c;
		evnt.Registrations_Accepted__c = camp.Registrations_Accepted__c;
		evnt.Registration_Cutoff__c = camp.Registration_Cutoff__c;
		evnt.Send_RSVP_to_Leader__c = camp.Send_RSVP_to_Leader__c;
		evnt.Ask_for_Additional_Attendees__c = camp.Ask_for_Additional_Attendees__c;
		evnt.Ask_for_Mobile_Phone__c = camp.Ask_for_Mobile_Phone__c;
		evnt.Ask_for_Phone_Number__c = camp.Ask_for_Phone_Number__c;
		evnt.Ask_for_Street_Address__c = camp.Ask_for_Street_Address__c;
		evnt.Ask_for_ZIP_Code__c = camp.Ask_for_ZIP_Code__c;
		evnt.Custom_Field_1_Label__c = camp.Custom_Field_1_Label__c;
		evnt.Custom_Field_2_Label__c = camp.Custom_Field_2_Label__c;
		evnt.Custom_Field_3_Label__c = camp.Custom_Field_3_Label__c;
		evnt.Custom_Field_4_Label__c = camp.Custom_Field_4_Label__c;
		evnt.Custom_Field_5_Label__c = camp.Custom_Field_5_Label__c;
		evnt.Display_Field_1__c = camp.Display_Field_1__c;
		evnt.Display_Field_2__c = camp.Display_Field_2__c;
		evnt.Display_Field_3__c = camp.Display_Field_3__c;
		evnt.Display_Field_4__c = camp.Display_Field_4__c;
		evnt.Display_Field_5__c = camp.Display_Field_5__c;
		evnt.Require_Field_1__c = camp.Require_Field_1__c;
		evnt.Require_Field_2__c = camp.Require_Field_2__c;
		evnt.Require_Field_3__c = camp.Require_Field_3__c;
		evnt.Require_Field_4__c = camp.Require_Field_4__c;
		evnt.Require_Field_5__c = camp.Require_Field_5__c;
		evnt.Require_Mobile_Phone__c = camp.Require_Mobile_Phone__c;
		evnt.Require_Phone_Number__c = camp.Require_Phone_Number__c;
		evnt.Require_Street_Address__c = camp.Require_Street_Address__c;
		evnt.Require_ZIP_Code__c = camp.Require_ZIP_Code__c;
		evnt.Require_Additional_Attendees__c = camp.Require_Additional_Attendees__c;
		evnt.Unpublish_Date__c = camp.Unpublish_Date__c;
		evnt.Campaign_Strategy_Global__c = camp.Campaign_Strategy_Global__c;
		evnt.Local_Campaign_Global__c = camp.Local_Campaign_Global__c;
		evnt.National_Campaign_Global__c = camp.National_Campaign_Global__c;
		evnt.Marketing_Interest_Area_Global__c = camp.Marketing_Interest_Area_Global__c;
		evnt.Waiver_Required__c = camp.Waiver_Required__c;
		evnt.Marketing_Tags_Global__c = camp.Marketing_Tags_Global__c;
		evnt.Tactic_Owner_Category_Global__c = camp.Tactic_Owner_Category_Global__c;
		evnt.Tactic_Owner_Global__c = camp.Tactic_Owner_Global__c;
		evnt.State_Global__c = camp.State_Global__c;
		evnt.Do_not_show_on_website_calendars__c = camp.Do_not_show_on_website_calendars__c;
		evnt.Local_Grassroots_Campaign__c = camp.Local_Grassroots_Campaign__c;
		evnt.RecurringEvent__c = camp.RecurringEvent__c;
		evnt.Recurring_Dates__c = camp.Recurring_Dates__c;

		return evnt;
	} 
}