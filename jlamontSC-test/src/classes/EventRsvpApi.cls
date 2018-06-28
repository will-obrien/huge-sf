@RestResource(urlMapping='/EventRsvpApi/*')
global without sharing class EventRsvpApi {
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();

	@HttpPost
	global static RsvpResult rsvp(Registration input) {
		RsvpResult result = new RsvpResult();
		Contact cont;
		Campaign camp;
		Event_Leader__c eventLeader;
		Event_Registration__c reg;
		
		if( ! String.isEmpty(input.contactId)) {
			cont = getContact(input.contactId);
			if(cont == null) {
				result.errorList.add('Invalid Contact Id');
			}
		}
		if( ! String.isEmpty(input.campaignId)) {
			camp = getCampaign(input.campaignId);
			if(camp == null) {
				result.errorList.add('Invalid Campaign Id');
			}
			else {
				if(camp.RecordTypeId != eventsTypeId) {
					result.errorList.add('Campaign is not an Event Campaign');					
				}
				else  {
					if( ! camp.Registrations_Accepted__c ) {
						result.errorList.add('Registrations not accepted');
					}
					else if( (camp.Status__c != 'Active') ) {
						result.errorList.add('Registrations not accepted - status: ' + camp.Status__c);
					}
					else if(camp.End_Date__c != null) { 
						if(camp.End_Date__c < System.today()) {
							result.errorList.add('Event End Date is Past');
						}
					}
					if(System.today() < camp.Publish_Date__c || System.today() > camp.Unpublish_Date__c) {
						result.errorList.add('Event is no longer published');
					}
				}
				if(result.errorList.isEmpty()) {
					if(String.isEmpty(input.sourceCampaignId)) {
						input.sourceCampaignId = input.campaignId;
					}
					else if( getCampaign(input.sourceCampaignId) == null) {
						input.sourceCampaignId = input.campaignId; 
					}
				}
			}
		}
		if(String.isEmpty(input.campaignId) && (input.eventId == null || input.eventId == 0)) {
			result.errorList.add('Either a Campaign Id or an EventId is required');
		}
		if(result.errorList.isEmpty()) {
			if(cont != null) {
				if(camp != null) {
					if(hasRegistered(camp, cont)) {
						result.errorList.add('Contact has already registered for this Event');
					}
				}
				else if(input.EventId != null && input.eventId > 0) {
					if(hasOptedIn(input.eventId, cont)) {
						result.errorList.add('Contact has already Opted In for this Event');
					}
				}
			}
		}
		if(cont == null) {
			if(String.isEmpty(input.firstName)) {
				result.errorList.add('Required field missing - First Name');
			}
			if(String.isEmpty(input.lastName)) {
				result.errorList.add('Required field missing - Last Name');
			}
			if(String.isEmpty(input.email)) {
				result.errorList.add('Required field missing - Email');
			}
			else if( ! isValidEmail(input.email)) {
				result.errorList.add('Invalid Email Address: ' + input.email);
			}
			if( ! String.isEmpty(input.phone)) {
				if( ! isValidPhone(input.phone)) {
					result.errorList.add('Invalid Phone: ' + input.phone);
				}
			}
		}
		if(String.isEmpty(input.sourceURL)) {
			result.errorList.add('Required field missing - Source URL');
		}
		if( ! result.errorList.isEmpty()) {
			return result;
		}
		try {
			if(cont == null) {
				createBatchUpload(input);
			}
			
			if(camp == null) {
				createEventOptIn(input, cont);
			}
			else {
				createEventRegistration(input, camp, cont);
			}
			result.success = true;		
		}
		catch(Exception e) {
			result.errorList.add('Internal Error: ' + e.getMessage());	
			result.errorList.add(e.getStackTraceString());	
		}
		
		return result;
	}
	private static void createBatchUpload(Registration reg) {
		rC_Connect__Batch_Upload__c batch = new rC_Connect__Batch_Upload__c (
			rC_Connect__Address_City__c = reg.City,
			rC_Connect__Address_Street_Line_1__c = reg.Street,
			rC_Connect__Address_State__c = reg.State,
			rC_Connect__Address_Postal_Code__c = reg.PostalCode,
			rC_Connect__Address_Country_Name__c = reg.country,
			rC_Connect__Contact_1_Email__c = reg.Email,
			rC_Connect__Contact_1_First_Name__c = reg.FirstName,
			rC_Connect__Contact_1_Last_Name__c = reg.LastName,
			rC_Connect__Contact_1_Phone_1__c = reg.Phone,
			rC_Connect__Exclude_Giving__c = true
		);
		if( ! String.isEmpty(reg.campaignId)) {
			batch.Form_Campaign__c = reg.campaignId;
		}
		
		insert batch;
	}
	private static void createEventRegistration(Registration input, Campaign camp, Contact ctct) {
		Event_Registration__c reg = new Event_Registration__c(
			Campaign__c = camp.Id, 
			Source_URL__c = input.sourceURL,
			Source_Campaign__c = input.sourceCampaignId,
			Club_Event__c = camp.Club_Event__c
		);
		if(ctct == null) { 
			reg.City__c = input.City;
			reg.Email__c = input.Email;
			reg.First_Name__c = input.firstName;
			reg.Last_Name__c = input.lastName;
			reg.Phone__c = input.Phone;
			reg.PostalCode__c = input.postalCode;
			reg.State__c = input.state;
			reg.Street__c = input.street;
		}
		else {
			reg.Contact__c = ctct.Id;
			reg.City__c = ctct.MailingCity;
			reg.Email__c = ctct.Email;
			reg.First_Name__c = ctct.FirstName;
			reg.Last_Name__c = ctct.LastName;
			reg.Phone__c = ctct.Phone;
			reg.PostalCode__c = ctct.MailingPostalCode;
			reg.State__c = ctct.MailingState;
			reg.Street__c = ctct.MailingStreet;
		}
		insert reg;
		AcknowledgeEventRegistration.acknowledge(camp, reg, getEventLeader(camp));
	}
	private static void createEventOptIn(Registration reg, Contact cont) {
		if( ! String.isEmpty(reg.sourceCampaignId)) {
			if(getCampaign(reg.sourceCampaignId) == null) {
				reg.sourceCampaignId = null;
			}
		}
		Event_OptIn__c oi = new Event_OptIn__c(
			EventId__c = reg.eventId, 
			Source_URL__c = reg.sourceURL,
			Source_Campaign__c = reg.sourceCampaignId
		);
		if(cont == null) {
			oi.City__c = reg.city;
			oi.Country__c = reg.country;
			oi.Email__c = reg.email;
			oi.First_Name__c = reg.firstName;
			oi.Last_Name__c = reg.lastName;
			oi.Phone__c = reg.phone;
			oi.PostalCode__c = reg.postalCode;
			oi.State__c = reg.state;
			oi.Street__c = reg.street;
		}
		else {
			oi.Contact__c = cont.Id;
		}
		insert oi;
	}
	private static Boolean hasRegistered(Campaign camp, Contact ctct) {
		List<Event_Registration__c> regList = [
			select Id 
			from Event_Registration__c
			where 
				Contact__c = :ctct.Id
				and Campaign__c = :camp.Id
		];
		return ( ! regList.isEmpty());
	}
	private static Boolean hasOptedIn(Integer eventId, Contact ctct) {
		List<Event_OptIn__c> optInList = [
			select Id from Event_OptIn__c where EventId__c = :eventId and Contact__c = :ctct.Id
		];
		return ( ! optInList.isEmpty());
	}
	
	private static Event_Leader__c getEventLeader(Campaign camp) {
		Event_Leader__c leader;
		List<Event_Leader__c> ldrList = 
			[select
				Contact__c, 
				Leader_Name__c,
				Email__c, 
				Phone_or_Other_Contact_Information__c
			 from Event_Leader__c
			 where 
			    Campaign__c = :camp.Id 
			    and Is_Primary_Leader__c = true
			];
			
		if(ldrList.size() > 0) {
			leader = ldrList.get(0);
		}
		return leader;
	}
	
	private static Contact getContact(String id) {
		Contact ctct;
		List<Contact> contactList = [
        	select
        		Id,
        		FirstName,
        		LastName,
        		Email,
        		Phone,
        		MailingPostalCode,
        		MailingStreet,
        		MailingCity,
        		MailingState
        	from Contact
        	where Id = :id
		];
		if( ! contactList.isEmpty()) {
			ctct = contactList.get(0);
		}
		return ctct;
	}	
	
	private static Campaign getCampaign(String id) {
		Campaign cmp;
		List<Campaign> campaignList = [
			select
				Id,
				RecordTypeId,
				Description,
				Event_Name__c,
				Status__c,
				Start_Date__c,
				Start_Time__c,
				End_Date__c,
				End_Time__c,
				Time_Zone__c,
				Registrations_Accepted__c,
				Publish_Date__c,
				Unpublish_Date__c,
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
				Location_Description__c,
				Autoresponder_Subject_Line__c,
				Geocode__Latitude__s,
				Geocode__Longitude__s,
				Autoresponder_Text__c,
				Autoresponder_Type__c,
				Sponsor_Description__c,
				URL_to_Share__c,
				Send_RSVP_to_Leader__c,
				Club_Event__c,
            	Club_Entity__r.Address_Street__c,
            	Club_Entity__r.Address_City__c,
            	Club_Entity__r.Address_State__c,
            	Club_Entity__r.Address_Postal_Code__c
			from Campaign
			where Id = :id
		];
		if( ! campaignList.isEmpty()) {
			cmp = campaignList.get(0);
		}
		return cmp;
	}
	private static Boolean isValidEmail(String email) {
		String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(email);
		return MyMatcher.matches();
	}
	private static Boolean isValidPhone(String phone) {
		Boolean res = true;
		String phoneRegex = '\\D*?(\\d\\D*?){10}';
		Pattern MyPattern = Pattern.compile(phoneRegex);
		Matcher MyMatcher = MyPattern.matcher(phone);
		return MyMatcher.matches();
	}
	global class Registration {
		public Integer eventId {get; set;}
		public String contactId {get; set;}
		public String campaignId {get; set;}
		public String sourceURL {get; set;}
		public String email {get; set;}
		public String firstName {get; set;}
		public String lastName {get; set;}
		public String street {get; set;}
		public String city {get; set;}
		public String state {get; set;}
		public String postalCode {get; set;}
		public String country {get; set;}
		public String phone {get; set;}
		public String sourceCampaignId {get; set;}
	}
	global class RsvpResult {
		public Boolean success = false;
		public List<String> errorList = new List<String>();
	}
}