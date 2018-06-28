/*
EventRegistrationTriggerHandler

Called by EventRegistrationTrigger - after delete, after insert, after update

Keeps up-to-date counts on Event Campaigns of Registrations for the Event that are not Cancelled.

Mark Maslow - January 2016

July 2016 - Maslow
Change owner id to Cast Iron to enable regular users to delete registration

January 2017 - Maslow
If lookup to Club Event is missing, get it from Campaign and add it before inserting

Add counts on Campaign for Attended, No Show, Cancelled

April 2017 - Tami Lau
Added deleteBatchUpload method
*/
public without sharing class EventRegistrationTriggerHandler {
    private static final Id castironUserId = UserLookup.getId('ciron');
	public static void handleChange() {
		List<Event_Registration__c> regList;
		if(Trigger.isDelete) {
			regList = Trigger.old;
		}
		else if(Trigger.isInsert){
			regList = Trigger.new;
			if(Trigger.isBefore) {
				Set<Id> campaignIdSet = new Set<Id>();
				for(Event_Registration__c reg : regList) {
					reg.OwnerId = castironUserId;
					if(String.isEmpty(reg.Club_Event__c)) {
						campaignIdSet.add(reg.Campaign__c);
					}
				}
				if( ! campaignIdSet.isEmpty() ) {
					Map<Id, Campaign> campaignToClubEventMap = new Map<Id, Campaign>([
						select Id, Club_Event__c
						from Campaign
						where Id in :campaignIdSet
					]);
					for(Event_Registration__c reg : regList) {
						Campaign camp = campaignToClubEventMap.get(reg.Campaign__c);
						if(camp != null) {
							reg.Club_Event__c = camp.Club_Event__c;
						}
					}
				}
				return;
			}
		}
		else {
			regList = new List<Event_Registration__c>();
			for(sObject obj : Trigger.new) {
				Event_Registration__c reg = (Event_Registration__c)obj;
				Event_Registration__c oldReg = (Event_Registration__c)Trigger.oldMap.get(reg.Id);
				if(oldReg != null) {
					if(reg.Campaign__c != oldReg.Campaign__c) {
						regList.add(reg);
						regList.add(oldReg);	
					}
					else {
						if(reg.Status__c != oldReg.Status__c) {
					    	regList.add(reg);
					    }
					}
				}
			}
		}
		Set<Id> idSet = new Set<Id>();
		for(Event_Registration__c reg : regList) {
			if(reg.Campaign__c != null) {
				idSet.add(reg.Campaign__c);
			}
		}
		if( ! idSet.isEmpty() ) {
			SummarizeRegistrations(idSet);
		}

		List<UpsertMobileIntegrationRequests.MobileIntegrationParameters> contactList = new List<UpsertMobileIntegrationRequests.MobileIntegrationParameters>();
		if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) ) {
			List<Event_Registration__c> eventRegList = Trigger.new;
			for(Event_Registration__c reg : eventRegList) {
				if(Trigger.isInsert) {
					if(reg.Mobile_Subscriber_Opt_In__c == true) {
						if( ! String.isEmpty(reg.Contact__c) ) {
							if( ! String.isEmpty(reg.Mobile_Phone__c)) {
								UpsertMobileIntegrationRequests.MobileIntegrationParameters parms = new UpsertMobileIntegrationRequests.MobileIntegrationParameters(
									reg.Contact__c,
									reg.Mobile_Phone__c,
									'Event Registration'
								);
								parms.eventRegistrationId = reg.Id;
								contactList.add(parms);
							}
						}
					}
				}
				else if(Trigger.isUpdate) {
					if(reg.Mobile_Subscriber_Opt_In__c == true) {
						if( ! String.isEmpty(reg.Contact__c) ) {
							if( ! String.isEmpty(reg.Mobile_Phone__c)) {
								Event_Registration__c oldReg = (Event_Registration__c) Trigger.oldMap.get(reg.Id);
								if(String.isEmpty(oldReg.Contact__c) || String.isEmpty(oldReg.Phone__c)) {
									UpsertMobileIntegrationRequests.MobileIntegrationParameters parms = new UpsertMobileIntegrationRequests.MobileIntegrationParameters(
										reg.Contact__c,
										reg.Mobile_Phone__c,
										'Event Registration'
									);
									parms.eventRegistrationId = reg.Id;
									contactList.add(parms);
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
	@future
	public static void SummarizeRegistrations(Set<Id> campIds) {
		//Ensure that all campaigns to summarize actually exist
		//(Deleting campaigns deletes all registrations for deleted campaigns)
		List<Campaign> campaignIdList = [
			select Id
			from Campaign
			where Id in :campIds
		];
		Set<Id> campaignIds = new Set<Id>();
		for(Campaign camp : campaignIdList) {
			campaignIds.add(camp.Id);
		}
		if(campaignIds.isEmpty()) {
			return;
		}
		List<Campaign> campList = new List<Campaign>();
		AggregateResult[] groupedResults = [
  			SELECT
  				Campaign__c,
  				sum(RegisteredCount__c)registered,
  				sum(CancelledCount__c)cancelled,
  				sum(AttendedCount__c)attended,
  				sum(NoShowCount__c)noshow 
  			FROM Event_Registration__c
  			WHERE Campaign__c IN :campaignIds
  			GROUP BY Campaign__c
  		];
  		Set<Id> campaignsWithResults = new Set<Id>();
  		for (AggregateResult ar : groupedResults) {
  			Decimal notCancelledCount =
  				(Decimal)ar.get('registered') +
  				(Decimal)ar.get('attended') + 
  				(Decimal)ar.get('noshow');
  			Campaign camp = new Campaign(
  				Id = (Id)ar.get('Campaign__c'),
  				Event_Registration_Count__c = notCancelledCount,
  				Cancelled_Count__c = (Decimal)ar.get('cancelled'),
  				Attended_Count__c = (Decimal)ar.get('attended'),
  				NoShow_Count__c = (Decimal)ar.get('noshow')
  			);
  			campaignsWithResults.add(camp.Id);
  			campList.add(camp);
  		}
  		for(Id campId : campaignIds) {
  			if( ! campaignsWithResults.contains(campId) ) {
  				Campaign camp = new Campaign(
	  				Id = campId,
	  				Event_Registration_Count__c = 0,
	  				Cancelled_Count__c = 0,
	  				Attended_Count__c = 0,
	  				NoShow_Count__c = 0
  				);
  				campList.add(camp);
  			}
  		}
  		if( ! campList.isEmpty() ) {
			update campList;
  		}
	}
    
	//if the deleted Event Registration had a corresponding batch upload, delete the batch upload
    public static void deleteBatchUpload(List<Event_Registration__c> regs) {
        
        List<String> regIDs = new List<String>();
        for (Event_Registration__c r : regs) {
            regIDs.add(string.valueOf(r.Id));
        }

		List<rC_Connect__Batch_Upload__c> batchUploads = new List<rC_Connect__Batch_Upload__c>([SELECT Id FROM rC_Connect__Batch_Upload__c WHERE Event_Registration_Id__c IN :regIDs]);
		
        if (batchUploads.size() > 0) {
            delete batchUploads;
        }
		       
    }    
}