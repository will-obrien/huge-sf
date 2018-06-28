public without sharing class UpdateRecurringEvents implements Queueable {
	private Id originalEventId;
	private Boolean isNewlyCancelled;
	private List<Event_Leader__c> originalLeadersToUpdate;
	private List<Event_Leader__c> originalLeadersToDelete;
	private Set<Id> campaignIds = new Set<Id>();
	
	public UpdateRecurringEvents (Id eventId, Boolean isNewlyCancelled, List<Event_Leader__c> leadersToUpdate, List<Event_Leader__c> leadersToDelete) {
		this.originalEventId = eventId;
		this.isNewlyCancelled = isNewlyCancelled;
		this.originalLeadersToUpdate = leadersToUpdate;
		this.originalLeadersToDelete = leadersToDelete;
	}
	
	public void execute(QueueableContext context) {
		//originalCamp is the Campaign that the user just saved
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
		
		//campList contains future recurring instances
		List<Campaign> campList = [
			select Id, Club_Event__c, Start_Date__c
			from Campaign
			where 
				RecurringEvent__c = :originalCamp.RecurringEvent__c
				and Id != :originalEventId
				and Start_Date__c >= :System.today()
				and Start_Date__c > :originalCamp.Start_Date__c
		];
		
		List<Campaign> campaignsToUpdate = new List<Campaign>();
		
		//Create updates for all Campaigns in campList
		//Also, create set of Ids that are to be updated
		for(Campaign camp : campList) {
			Campaign newCamp = originalCamp.clone(false, true);
			newCamp.Id = camp.Id;
			newCamp.Club_Event__c = camp.Club_Event__c;
			newCamp.Start_Date__c = camp.Start_Date__c;
			if(originalCamp.End_Date__c != null) {
				newCamp.End_Date__c = newCamp.Start_Date__c;
			}
			campaignsToUpdate.add(newCamp);
			campaignIds.add(newCamp.Id);
		}

		//Update Campaigns
		if( ! campaignsToUpdate.isEmpty() ) {
			update campaignsToUpdate;
		}
		
		//Create map to correlate original leader list with a RecurringEventLeader Id
		Map<Id, Event_Leader__c> ldrMap = new Map<Id, Event_Leader__c>();
		for(Event_Leader__c ldr : originalLeadersToUpdate) {
			ldrMap.put(ldr.RecurringEventLeader__c, ldr);
		}
		
		//Get all leaders for updated Campaigns
		List<Event_Leader__c> allLeaders = [
			select Id, Club_Event__c, Campaign__c, RecurringEventLeader__c from Event_Leader__c
			where Campaign__c in :campaignIds
		];
		
		//Create list of leader to update or insert
		List<Event_Leader__c> leadersToUpsert = new List<Event_Leader__c>();
		Set<Id> recurringIds = new Set<Id>();
		
		//Add leaders update
		for(Event_Leader__c ldr : allLeaders) {
			Event_Leader__c originalLeader = ldrMap.get(ldr.RecurringEventLeader__c);
			if(originalLeader != null) {
				Event_Leader__c evLdr = originalLeader.clone(false, true);
				evLdr.Id = ldr.Id;
				evLdr.Campaign__c = ldr.Campaign__c;
				evLdr.Club_Event__c = ldr.Club_Event__c;
				leadersToUpsert.add(evLdr);
				recurringIds.add(ldr.RecurringEventLeader__c);
			}
		}
		
		//Add leaders to insert
		for(Event_Leader__c ldr : originalLeadersToUpdate) {
			if( ! recurringIds.contains(ldr.RecurringEventLeader__c)) {
				for(Campaign camp : campaignsToUpdate) {
					Event_Leader__c newLdr = ldr.clone(false, true);
					newLdr.Campaign__c = camp.Id;
					newLdr.Club_Event__c = camp.Club_Event__c;
					leadersToUpsert.add(newLdr);
				}
			}
		}
		
		EventLeaderTriggerHandler.leadersChecked = true;
		if(originalLeadersToDelete != null) {
			//Create list of leaders to delete
			Set<Id> recurringLeaderIdsToDelete = new Set<Id>();
			for(Event_Leader__c ldr : originalLeadersToDelete) {
				recurringLeaderIdsToDelete.add(ldr.RecurringEventLeader__c);
			}
			List<Event_Leader__c> leadersToDelete = [
				select Id from Event_Leader__c
				where RecurringEventLeader__c in :recurringLeaderIdsToDelete
				and Campaign__c in :campaignIds
			];
			
			//Delete leaders
			if( ! leadersToDelete.isEmpty() ) {
				delete leadersToDelete;
			}
		}
		//Upsert leaders
		if( ! leadersToUpsert.isEmpty() ) {
			upsert leadersToUpsert;
		}
		if(originalCamp.Status__c == 'Cancelled') {
			if(isNewlyCancelled) {
				sendCancellationNotices();
			}
		}
	}
    private void sendCancellationNotices() {
    	Map<Id, Club_Event__c> eventMap = new Map<Id, Club_Event__c>();
    	List<Club_Event__c> eventList = [
    		select Campaign__c, Event_Title__c, Date_Begin__c, Time_Begin__c,  Cancel_Reason__c
    		from Club_Event__c
    		where Campaign__c in :campaignIds
    	];
    	for(Club_Event__c clubEvent : eventList) {
    		eventMap.put(clubEvent.Campaign__c, clubEvent);
    	}
		List<Event_Registration__c> allRegistrations = [
			select
				Campaign__c,
				Contact__c,
				First_Name__c,
				Last_Name__c,
				Full_Name__c,
				Email__c
			from Event_Registration__c
			where Campaign__c in :campaignIds
			order by Campaign__c	
		];
		if(allRegistrations.isEmpty()) {
			return;
		}
		List <Event_Registration__c> regList = new List<Event_Registration__c>();		
		String lastCampaignId = allRegistrations.get(0).Campaign__c;
		
		for(Event_Registration__c reg : allRegistrations) {
			if(reg.Campaign__c != lastCampaignId) {
				Club_Event__c event = eventMap.get(lastCampaignId);
				ClubEventCancellationEmail.send(event, regList);
				regList.clear();
				lastCampaignId = reg.Campaign__c;
			}
			regList.add(reg);
		}
		Club_Event__c event = eventMap.get(lastCampaignId);
		ClubEventCancellationEmail.send(event, regList);
    }
}