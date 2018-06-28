public with sharing class EventAttendanceController {
	@RemoteAction
	public static ClubEvent getEvent(String id) {
		ClubEvent event = new ClubEvent();
		List<Signup> signupList = new List<Signup>();
		List<Club_Event__c> eventList = [
			select 
				Id,
				Date_Begin__c,
				Event_Title__c,
				Club_Entity__r.Name,
				Sponsor_Description__c,
				Waiver_Required__c,
				Ask_for_Phone_Number__c,
				Ask_for_Street_Address__c,
				Ask_for_ZIP_Code__c,
				Require_Phone_Number__c,
				Require_Street_Address__c,
				Require_ZIP_Code__c
			from Club_Event__c
			where Id = :id
		];
		if( ! eventList.isEmpty()) {
			Club_Event__c selectedEvent = eventList.get(0);
			event.Id = selectedEvent.Id;
	    	String timeZone = System.UserInfo.getTimeZone().getID();
	    	Time zTime = Time.newInstance(0,0,0,0);
			event.dateBegin = DateTime.newInstance(selectedEvent.Date_Begin__c, zTime).format('MMMM d, yyyy', timeZone);
			event.title = selectedEvent.Event_Title__c;
			event.sponsor = selectedEvent.Sponsor_Description__c;
			event.waiverRequired = selectedEvent.Waiver_Required__c;
			event.askForPhone = selectedEvent.Ask_for_Phone_Number__c;
			event.askForZip = selectedEvent.Ask_for_ZIP_Code__c;
			event.askForAddress = selectedEvent.Ask_for_Street_Address__c;
			event.requireZip = selectedEvent.Require_ZIP_Code__c;
			event.requireAddress = selectedEvent.Require_Street_Address__c;
			event.requirePhone = selectedEvent.Require_Phone_Number__c;
			
			List<Event_Registration__c> registrationList = [
				select
					Id,
					Status__c,
					Waiver_Submitted__c,
					Waiver_is_Digital__c,
					First_Name__c,
					Last_Name__c,
					Email__c,
					Phone__c,
					Street__c,
					City__c,
					State__c,
					PostalCode__c,
					Image_Authorization_Declined__c
				from Event_Registration__c
				where Club_Event__c = :id
				order by Last_Name__c, First_Name__c
			];
			List<Signup> suList = new List<Signup>();
			for(Event_Registration__c reg : registrationList) {
				Signup su = new Signup();
				su.registrationId = reg.Id;
				su.firstName = reg.First_Name__c;
				su.lastName = reg.Last_Name__c;
				su.zip = reg.PostalCode__c;
				su.phone = reg.Phone__c;
				su.city = reg.City__c;
				su.state = reg.State__c;
				su.status = reg.Status__c;
				su.waiverSubmitted = reg.Waiver_Submitted__c;
				su.waiverIsDigital = reg.Waiver_is_Digital__c;
				suList.add(su);
			}
			event.signupList = suList;
		}
		return event;
	}
	@RemoteAction
	public static ClubEvent saveEvent(ClubEvent evnt) {
		Id campaignId;
		List<Club_Event__c> clubEventList = [
			select Campaign__c from Club_Event__c where Id = :evnt.Id
		];
		if( ! clubEventList.isEmpty() ) {
			campaignId = clubEventList.get(0).Campaign__c;
		}

		Map<Id, Event_Registration__c> IdToRegMap = new Map<Id, Event_Registration__c>([
			select Id, Status__c, Waiver_Id__c
			from Event_Registration__c 
			where Club_Event__c = :evnt.id 
		]);
		
		List<Event_Registration__c> regsToUpdateList = new List<Event_Registration__c>();
		List<Event_Registration__c> regsToInsertList = new List<Event_Registration__c>();
		for(Signup su : evnt.signupList) {
			Event_Registration__c regToUpsert = new Event_Registration__c();
			regToUpsert.Club_Event__c = evnt.id;
			
			if( String.isEmpty(su.registrationId) ) {
				regToUpsert.First_Name__c = su.firstName;
				regToUpsert.Last_Name__c = su.lastName;
				regToUpsert.Email__c = su.email;
				regToUpsert.PostalCode__c = su.zip;
				regToUpsert.Status__c = su.status;
				regToUpsert.Campaign__c = campaignId;
				regToUpsert.Phone__c = su.phone;
				regToUpsert.Street__c = su.street;
				regToUpsert.City__c = su.city;
				regToUpsert.State__c = su.state;
			}
			else {
				Event_Registration__c eventReg = IdToRegMap.get(su.registrationId);
				if(eventReg == null) {
					regToUpsert.Status__c = su.status;
				}
				else {
					regToUpsert.Id = su.registrationId;
					regToUpsert.Status__c = su.status;
				}
			}
			regToUpsert.Waiver_is_Digital__c = su.waiverIsDigital;
			regToUpsert.Waiver_Submitted__c = su.waiverSubmitted;
			regToUpsert.Image_Authorization_Declined__c = su.imageAuthorizationDeclined;
			regToUpsert.Is_Minor__c = su.isMinor;
			regToUpsert.Guardian_First_Name__c = su.guardianFirstName;
			regToUpsert.Guardian_Last_Name__c = su.guardianLastName;
			regToUpsert.Guardian_Email__c = su.guardianEmail;
			
			if(regToUpsert.Id == null) {
				regsToInsertList.add(regToUpsert);
			}
			else {
				regsToUpdateList.add(regToUpsert);
			}
		}

		update regsToUpdateList;
		insert regsToInsertList;
		
		List<rC_Connect__Batch_Upload__c> batchUploadList = new List<rC_Connect__Batch_Upload__c>();
		for(Event_Registration__c reg : regsToInsertList) {
			rC_Connect__Batch_Upload__c batch = new rC_Connect__Batch_Upload__c (
				rC_Connect__Address_Postal_Code__c = reg.PostalCode__c,
				rC_Connect__Contact_1_Email__c = reg.Email__c,
				rC_Connect__Contact_1_First_Name__c = reg.First_Name__c,
				rC_Connect__Contact_1_Last_Name__c = reg.Last_Name__c,
				rC_Connect__Contact_1_Phone_1__c = reg.Phone__c,
				rC_Connect__Address_Street_Line_1__c = reg.Street__c,
				rC_Connect__Address_State__c = reg.State__c,
				rC_Connect__Address_City__c = reg.City__c,
				Form_Campaign__c = campaignId,
				rC_Connect__Batch_Upload_Campaign_Matched__c = campaignId, 
				rC_Connect__Exclude_Giving__c = true,
				Event_Registration_Id__c = reg.Id
			);
			batchUploadList.add(batch);
		}
		insert batchUploadList;

		List<String> idList = new List<String>();
		List<Event_Registration__c> waiverList = [
			select Id
			from Event_Registration__c
			where 
				Club_Event__c = :evnt.Id
				and Waiver_Submitted__c = true
				and Waiver_is_Digital__c = true
				and Waiver_Id__c = null
		];

		Integer maxWaiverBatchSize = 50;
		if(Test.isRunningTest()) {
			maxWaiverBatchSize = 2;
		} 
		Integer counter = 0;
		for(Event_Registration__c reg : waiverList) {
			idList.add(reg.Id);
			counter ++;
			if(counter == maxWaiverBatchSize) {
				WaiverCreator creator = new WaiverCreator(idList);
				System.enqueueJob(creator);
				counter = 0;
				idList = new List<String>();
			}
		}
		if( ! idList.isEmpty() ) {
			WaiverCreator creator = new WaiverCreator(idList);
			System.enqueueJob(creator);
		}
		return getEvent(evnt.Id);
	}
	public class Signup {
		public String registrationId {get; set;}
		public String firstName {get; set;}
		public String lastName {get; set;}
		public String email {get; set;}
		public String street {get; set;}
		public String city {get; set;}
		public String state {get; set;}
		public String phone {get; set;}		
		public String zip {get; set;}
		public String status {get; set;}
		public Boolean waiverSubmitted {get; set;}
		public Boolean waiverIsDigital {get; set;}
		public Boolean imageAuthorizationDeclined {get; set;}
		public Boolean isMinor {get; set;}
		public String guardianFirstName {get; set;}
		public String guardianLastName {get; set;}
		public String guardianEmail {get; set;}
	}
	public class ClubEvent {
		public String id {get; set;}
		public String dateBegin {get; set;}
		public String title {get; set;}
		public String sponsor {get; set;}
		public Boolean waiverRequired {get; set;}
		public Boolean askForPhone {get; set;}
		public Boolean askForAddress {get; set;}
		public Boolean askForZip {get; set;}
		public Boolean requirePhone {get; set;}
		public Boolean requireAddress {get; set;}
		public Boolean requireZip {get; set;}
		public Signup[] signupList {get; set;}
	}
	public String getPageBase() {
		return CampfireUtils.getPageBase();
	}
	public String getSalesforceBase() {
		return System.Url.getSalesforceBaseUrl().toExternalForm();
	}
}