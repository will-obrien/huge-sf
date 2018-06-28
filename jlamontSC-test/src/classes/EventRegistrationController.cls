public without sharing class EventRegistrationController {

	private Event_Registration__c reg;
	private Contact ctct;
	private Campaign camp;
	private Id sourceCampaignId;
	private Event_Leader__c eventLeader;
	private Boolean isRegistered = false;
    private static Id eventsTypeId;

	public Boolean acknowledged {get; set;}
	public Boolean canOpen {get; set;}
	public Boolean imageAuthorizationDeclined {get; set;}
	public Boolean agreementNotChecked {get; set;} {agreementNotChecked = false;}
	public Boolean isMinor {get; set;} {isMinor = false;}
	public String guardianFirstName {get; set;}
	public String guardianLastName {get; set;}
	public String guardianEmail {get; set;}
	public Boolean digitalWaiverCompleted {get; set;} {digitalWaiverCompleted = false;}

    static {
        eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    }
	
    public EventRegistrationController() {
    }

	public Event_Registration__c getRegistration() {
		if(reg == null) {
			getContact();
			if(ctct != null) {
				getCampaign();
				if(camp != null) {
					if(ctct.Id != null) {
						//If there already is a registration for Contact/Campaign combination, treat as anonymous user
						List<Event_Registration__c> regList = [
							select
								Campaign__c,
								City__c,
								Contact__c,
								Email__c,
								First_Name__c,
								Last_Name__c,
								Phone__c,
								PostalCode__c,
								State__c,
								Street__c,
								Custom_Field_1_Response__c,
								Custom_Field_2_Response__c,
								Custom_Field_3_Response__c,
								Custom_Field_4_Response__c,
								Custom_Field_5_Response__c,
								Additional_Attendees__c
							from Event_Registration__c
							where 
								Contact__c = :ctct.Id
								and Campaign__c = :camp.Id
						];
						if(regList.size() > 0) {
							ctct = new Contact();
						}
					}
				}
			}
			reg = new Event_Registration__c();
			reg.Source_Campaign__c = getSourceCampaignId();
			if(ctct != null) {
				if(getCampaign() != null) {
					reg.Campaign__c = getCampaign().Id;
				}
				reg.City__c = ctct.MailingCity;
				reg.Email__c = ctct.Email;
				reg.First_Name__c = ctct.FirstName;
				reg.Last_Name__c = ctct.LastName;
				reg.Phone__c = ctct.Phone;
				reg.PostalCode__c = ctct.MailingPostalCode;
				reg.State__c = ctct.MailingState;
				reg.Street__c = ctct.MailingStreet;
				reg.Mobile_Subscriber_Opt_In__c = false;
				reg.Mobile_Phone__c = ctct.MobilePhone;
			}
		}
		return reg;
	}
	public void setRegistration(Event_Registration__c registration) {
		this.reg = registration;
	}
	public Campaign getCampaign() {
		if(camp == null) {
			String campId = ApexPages.currentPage().getParameters().get('formcampaignid');
			if(campId == null) {
				camp = new Campaign();
			}
			else {
				List<Campaign> campList = [
					select
						Id,
						RecordTypeId,
					    Name,
						Description,
						Event_Name__c,
						Summary_Description__c,
						Full_Description__c,
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
						Require_Field_1__c,
						Require_Field_2__c,
						Require_Field_3__c,
						Require_Field_4__c,
						Require_Field_5__c,
						Require_Additional_Attendees__c,
						Require_Mobile_Phone__c,
						Ask_for_Phone_Number__c,
						Ask_for_Street_Address__c,
						Ask_for_Zip_Code__c,
						Ask_for_Additional_Attendees__c,
						Ask_for_Mobile_Phone__c,
						Require_Phone_Number__c,
						Require_Street_Address__c,
						Require_Zip_Code__c,
						Location_Description__c,
						Autoresponder_Subject_Line__c,
						Post_Event_Page_Content__c,
						RSVP_Page_Title__c,
						Geocode__Latitude__s,
						Geocode__Longitude__s,
						kwac__Thank_You_Page_Text__c,
						Sharing_Image__c,
						URL_to_Share__c,
						kwac__Twitter_Share_Text__c,
						Sharing_Title__c,
						Sharing_Description__c,
						Facebook_Pixel_Code__c,
						Autoresponder_Text__c,
						Autoresponder_Type__c,
						Sponsor_Description__c,
						Send_RSVP_to_Leader__c,
						Club_Event__c,
						Signup_Instructions__c,
						Cost_Description__c,
						Bring__c,
						Signup_Restrictions__c,
						Additional_Directions__c,
						Carpool__c,
						Cancellation_Option__c,
						Cancellation_Policy_Description__c,
						Date_Tentative__c,
						Time_Tentative__c,
						Level__c,
						Entity_Specific_Level__c,
						Events_Category__c,
						Registration_Cutoff__c,
						kwac__Thank_You_Page__c,
						RSVP_Button_Text__c,
						Video_URL__c,
						Additional_Info_URL__c,
						Waiver_Required__c,
						Political_Disclaimer__c,
                    	Candidate_Committee__c,
			 			URL_Description__c,
                    	Question_Type_1__c,
                    	Question_Type_2__c,
                    	Question_Type_3__c,
                    	Question_Type_4__c,
                    	Question_Type_5__c,
                    	Possible_Answers_1__c,
                    	Possible_Answers_2__c,
                    	Possible_Answers_3__c,
                    	Possible_Answers_4__c,
                    	Possible_Answers_5__c,
						Image_Attribution__c,
						Club_Entity__r.Address_Street__c,
						Club_Entity__r.Address_City__c,
						Club_Entity__r.Address_State__c,
						Club_Entity__r.Address_Postal_Code__c
					from Campaign
					where Id = :campId
				];
				if(campList.size() > 0) {
					camp = campList.get(0);
				}
				else {
					camp = new Campaign();
				}
			}
		}
		return camp;
	}
	private Id getSourceCampaignId() {
		String sourceCampaignId = ApexPages.currentPage().getParameters().get('id');
		if( ! String.isEmpty(sourceCampaignId)) {
			List<Campaign> sourceCampaignList = [
				select Id from Campaign where Id = :sourceCampaignId and IsActive = true
			];
			if(sourceCampaignList.size() == 0) {
				sourceCampaignId = null;
			}
		}
		return sourceCampaignId;
	}
	public Contact getContact() {
        if(ctct == null) {
            String token = ApexPages.currentPage().getParameters().get('data');
            if(token == null) {
            	ctct = new Contact();
            	return ctct;
            }
	        List<Contact> ctctList = [
	        	select
	        		Id,
	        		FirstName,
	        		LastName,
	        		Email,
	        		Phone,
	        		MailingPostalCode,
	        		MailingStreet,
	        		MailingCity,
	        		MailingState,
	        		rC_Bios__Preferred_Phone__c,
	        		MobilePhone,
	        		Mobile_Subscriber__c
	        	from Contact
	        	where rC_Connect__Public_Token__c = :token
	        ];
	        if(ctctList.size() > 0) {
	        	ctct = ctctList.get(0);
	        }
	        else {
            	ctct = new Contact();
	        }
        }
        return ctct;
	}
	public Boolean getIsMobileSubscriber() {
		return getContact().Mobile_Subscriber__c;
	}
	public Boolean getIsEventCampaign() {
		Campaign camp = getCampaign();
		if(camp != null) {
			if(camp.RecordTypeId == eventsTypeId) {
				return true;
			}
		}
		return false;
	}
	public Boolean getIsRegistered() {
		return isRegistered;
	}
	public Boolean getHasEventEnded() {
		Campaign camp = getCampaign();
		if(camp.End_Date__c == null) {
			return (System.today() > camp.Start_Date__c);
		}
		else {
			return (System.today() > camp.End_Date__c);
		}
	}
	public Boolean getHasEventStarted() {
		return (System.today() > camp.Start_Date__c);
	}
	public Boolean getIsRsvpEnded() {
		return (System.today() > camp.Registration_Cutoff__c);
	}
	public Boolean getIsPublished() {
		return (System.today() >= camp.Publish_Date__c && System.today() < camp.Unpublish_Date__c);
	}
    public Boolean getHasLevel() {
    	if(camp.Events_Category__c == 'Outing') {
    		if(! String.isEmpty(camp.Level__c)) {
    			return true;
    		}
    	}
    	return false;
    }
    public Boolean getHasFullDescription() {
    	if(camp.Full_Description__c != null) {
	    	if(camp.Full_Description__c.length() > 1) {
	    		if(camp.Full_Description__c.startsWith('<img') && (camp.Full_Description__c.endsWith('</img>') || camp.Full_Description__c.endsWith('</img><br> ') )) {
	    			return false;
	    		}
	    		else {
	    			return true;
	    		}
	    	}
    	}
    	return false;
    }
    public String getLevelDescription() {
    	String retVal = '';
    	if(getHasLevel()) {
			retVal = camp.Level__c;
			if( ! String.isEmpty(camp.Entity_Specific_Level__c)) {
				retVal = retVal + '(' + camp.Entity_Specific_Level__c + ')';
			}
    	}
    	return retVal;
    }
	
	public PageReference save() {
		boolean hasErrors = false;
		if(String.isEmpty(reg.First_Name__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'First Name is Required')) ;
			hasErrors = true;
		}
		if(String.isEmpty(reg.Last_Name__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Last Name is Required')) ;
			hasErrors = true;
		}
		if(String.isEmpty(reg.Email__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Email is Required')) ;
			hasErrors = true;
		}
		else {
			if( ! isValidEmail(reg.Email__c)) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Email')) ;
				hasErrors = true;
			}
		}
		if(camp.Require_Phone_Number__c && String.isEmpty(reg.Phone__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Phone is Required')) ;
			hasErrors = true;
		}
		else {
			if( ! String.isEmpty(reg.Phone__c)) {
				if( ! isValidPhone(reg.Phone__c)) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Phone')) ;
					hasErrors = true;
				}
			}
		}
		if(camp.Require_Street_Address__c &&
			(
				String.isEmpty(reg.Street__c) ||
				String.isEmpty(reg.City__c) ||
				String.isEmpty(reg.State__c) ||
				String.isEmpty(reg.PostalCode__c)
			) 
		)   {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A Complete Address is Required')) ;
				hasErrors = true;
		}
		else if(camp.Require_ZIP_Code__c && String.isEmpty(reg.PostalCode__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Postal Code is Required')) ;
			hasErrors = true;
		}
		if( ! String.isEmpty(reg.Mobile_Phone__c)) {
			if( ! isValidPhone(reg.Mobile_Phone__c)) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Mobile Phone')) ;
				hasErrors = true;
			}
		}
		if(reg.Mobile_Subscriber_Opt_In__c == true && String.isEmpty(reg.Mobile_Phone__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'To join Sierra Club\'s Mobile Action Network, you must provide your Mobile Phone Number')) ;
			hasErrors = true;
		}
		if(camp.Require_Field_1__c && String.isEmpty(reg.Custom_Field_1_Response__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a response for \'' + camp.Custom_Field_1_Label__c+ '\'')) ;
			hasErrors = true;
		}
		if(camp.Require_Field_2__c && String.isEmpty(reg.Custom_Field_2_Response__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a response for \'' + camp.Custom_Field_2_Label__c+ '\'')) ;
			hasErrors = true;
		}
		if(camp.Require_Field_3__c && String.isEmpty(reg.Custom_Field_3_Response__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a response for \'' + camp.Custom_Field_3_Label__c+ '\'')) ;
			hasErrors = true;
		}
		if(camp.Require_Field_4__c && String.isEmpty(reg.Custom_Field_4_Response__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a response for \'' + camp.Custom_Field_4_Label__c+ '\'')) ;
			hasErrors = true;
		}
		if(camp.Require_Field_5__c && String.isEmpty(reg.Custom_Field_5_Response__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a response for \'' + camp.Custom_Field_5_Label__c+ '\'')) ;
			hasErrors = true;
		}
		
		if(hasErrors) {
			return null;
		}
		if( ! String.isEmpty(reg.State__c)) {
			reg.State__c = reg.State__c.toUpperCase();
		}
		boolean createBatchUpload = false;
		boolean bypassZDM = false;
		boolean useContactId = false;
		if(getContact().Id == null) {
			createBatchUpload = true;
		}
		else {
			Contact oldContact = [
				select
	        		FirstName,
	        		LastName,
	        		Email,
	        		Phone,
	        		MailingPostalCode,
	        		MailingStreet,
	        		MailingCity,
	        		MailingState,
	        		Mobile_Subscriber__c
	        	from Contact
	        	where Id = :ctct.Id
			];
			if(reg.First_Name__c != oldContact.FirstName || reg.Last_Name__c != oldContact.LastName) {
				createBatchUpload = true;
				useContactId = false;
				if( ! camp.Ask_for_Phone_Number__c) {
					reg.Phone__c = '';
				}
				if( ! camp.Ask_for_Street_Address__c) {
					reg.Street__c = '';
					reg.City__c = '';
					reg.State__c = '';
				}
				if( ! (camp.Ask_for_Street_Address__c || camp.Ask_for_Zip_Code__c) ) {
					reg.PostalCode__c = '';
				}
			}
			else {
				useContactId = true;
				if( reg.Email__c != oldContact.Email ||
					reg.Phone__c != oldContact.Phone ||
					reg.PostalCode__c != oldContact.MailingPostalCode ||
					reg.Street__c != oldContact.MailingStreet ||
					reg.City__c != oldContact.MailingCity ||
					reg.State__c != oldContact.MailingState 
				) {
					createBatchUpload = true;
					if(	reg.PostalCode__c == oldContact.MailingPostalCode &&
						reg.Street__c == oldContact.MailingStreet &&
						reg.City__c == oldContact.MailingCity &&
						reg.State__c == oldContact.MailingState
					) {
						bypassZDM = true;
					}
				}
			}
		}
		if(reg.Additional_Attendees__c == null) {
			reg.Additional_Attendees__c = 0;
		}
		reg.Campaign__c = camp.Id;
		reg.Club_Event__c = camp.Club_Event__c;
		if(useContactId) {
			reg.Contact__c = ctct.Id;
		}
		else if( ! String.isEmpty(reg.Id)){
			reg = reg.clone(false, true);
			reg.Contact__c = null;
		}
		upsert reg;
		isRegistered = true;
		
		if(createBatchUpload) {
			rC_Connect__Batch_Upload__c batch = new rC_Connect__Batch_Upload__c (
				rC_Connect__Address_City__c = reg.City__c,
				rC_Connect__Address_Street_Line_1__c = reg.Street__c,
				rC_Connect__Address_State__c = reg.State__c,
				rC_Connect__Address_Postal_Code__c = reg.PostalCode__c,
				rC_Connect__Contact_1_Email__c = reg.Email__c,
				rC_Connect__Contact_1_First_Name__c = reg.First_Name__c,
				rC_Connect__Contact_1_Last_Name__c = reg.Last_Name__c,
				rC_Connect__Contact_1_Phone_1__c = reg.Phone__c,
				rC_Connect__Contact_1_Phone_2__c = reg.Mobile_Phone__c,
				rC_Connect__Contact_1_Phone_2_Type__c = (String.isEmpty(reg.Mobile_Phone__c) ? null : 'Mobile'),
				Form_Campaign__c = camp.Id,
				rC_Connect__Batch_Upload_Campaign_Matched__c = String.isEmpty(sourceCampaignId) ? camp.Id : sourceCampaignId, 
				rC_Connect__Exclude_Giving__c = true
			);
	
			if( ! useContactId) {
				batch.Event_Registration_Id__c = reg.Id;
			}

            if( ! String.isEmpty(reg.Mobile_Phone__c) ) {
				batch.rC_Connect__Contact_1_Preferred_Phone__c = 'Mobile';
			}
			
            batch.Bypass_ZDM__c = bypassZDM;
			
			insert batch;
		}
		if( (! String.isEmpty(getCampaign().Autoresponder_Type__c)) || getCampaign().Send_RSVP_to_Leader__c) {
			AcknowledgeEventRegistration.acknowledge(getCampaign(), getRegistration(), getEventLeader());
		}
		if(camp.Waiver_Required__c) {
			Boolean askForWaiver = true;
			String attendeeParm = ApexPages.currentPage().getParameters().get('addattendee');
			if(attendeeParm == 'true') {
				askForWaiver = false;
			}
			else {
				attendeeParm = ApexPages.currentPage().getParameters().get('mode');
				if(attendeeParm == 'addattendee') {
					askForWaiver = false;
				}
			}
			if(askForWaiver) {
				PageReference pageRef = Page.Waiver;
				pageRef.setRedirect(false);
				return pageRef;
			}
		}
		if( ! String.isEmpty(getCampaign().kwac__Thank_You_Page__c)) {
			PageReference pageRef = new PageReference(getCampaign().kwac__Thank_You_Page__c);
			pageRef.setRedirect(true);
			return pageRef; 
		}
		return null;
	}
	public Event_Leader__c getEventLeader() {
		Event_Leader__c leader;
		if(eventLeader == null) {
			List<Event_Leader__c> ldrList = 
				[select 
					Leader_Name__c,
					Contact__c, 
					Email__c, 
					Phone_or_Other_Contact_Information__c
				 from Event_Leader__c
				 where 
				    Campaign__c =  :getCampaign().Id 
				    and Is_Primary_Leader__c = true
				];
			if(ldrList.size() > 0) {
				leader = ldrList.get(0);
			}
		}
		return leader;
	}
	public Boolean getIsClubEvent() {
		return ! String.isEmpty(getCampaign().Club_Event__c); 
	}
	public String getCancellationPolicy() {
		String retVal = getCampaign().Cancellation_Option__c;
		if(retVal == 'Other') {
			retVal = getCampaign().Cancellation_Policy_Description__c;
		}
		return retVal;
	}
	public String getRSVPButtonText() {
		Boolean addAttendeeMode = false;
		String attendeeParm = ApexPages.currentPage().getParameters().get('addattendee');
		if(attendeeParm == 'true') {
			addAttendeeMode = true;
		}
		else {
			attendeeParm = ApexPages.currentPage().getParameters().get('mode');
			if(attendeeParm == 'addattendee') {
				addAttendeeMode = true;
			}
		}
		String buttonText;
		if(addAttendeeMode) {
			buttonText = 'Add Participant';
		}
		else if(getCampaign().Waiver_Required__c == true) {
			buttonText = 'RSVP and Sign Waiver';
		}
		else {
			buttonText = getCampaign().RSVP_Button_Text__c;
		}
		if(String.isEmpty(buttonText)) {
			buttonText = 'RSVP';
		}
		return buttonText;
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
  	public PageReference savePdf() {
		if( ! (canOpen && acknowledged) ) {
			agreementNotChecked = true;
			return null;
		}
		agreementNotChecked = false;
		Boolean hasErrors = false;
		if(isMinor) {
			if(String.isEmpty(guardianFirstName)) {
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'First Name is Required'));
				hasErrors = true;
			}
			if(String.isEmpty(guardianLastName)) {
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Last Name is Required'));
				hasErrors = true;
			}
			else if(guardianLastName.trim().length() < 2) {
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Last Name must be at least 2 characters'));
				hasErrors = true;
			}
			if(String.isEmpty(guardianEmail)) {
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Email is Required'));
				hasErrors = true;
			}
			else if( ! isValidEmail(guardianEmail.trim()) ) {
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Email'));
				hasErrors = true;
			}
			if(hasErrors) {
				return null;
			}
		}
		if(isMinor || imageAuthorizationDeclined) {
			Event_Registration__c regToUpdate = new Event_Registration__c(
				id=reg.Id
			);
			if(isMinor) {
				regToUpdate.Is_Minor__c = true;
				regToUpdate.Guardian_First_Name__c = guardianFirstName;
				regToUpdate.Guardian_Last_Name__c = guardianLastName;
				regToUpdate.Guardian_Email__c = guardianEmail;
			}
			if(imageAuthorizationDeclined) {
				regToUpdate.Image_Authorization_Declined__c = true;
			}
			update regToUpdate;
		}
		List<String> idList = new List<String>();
		idList.add(reg.Id);
		WaiverCreator creator = new WaiverCreator(idList);
		System.enqueueJob(creator);
		DigitalWaiverCompleted = true;
		
		return Page.details;
 	 }
 	 public PageReference paperWaiver() {
 	 	return Page.details;
 	 }
}