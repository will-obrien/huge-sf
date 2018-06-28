public without sharing class ClubEventController {
    public Club_Event__c clubEvent;
    private Map<Id, EntityPermissions.EntityPermission> entityPermissionsMap;
    private boolean categoryChanged=false;
    List<SelectOption> entityOptions;
    public List<EventLeader> leaderList;
    public List<EventRegistration> registrationList;
    public String contactSearchValue { get; set; }
    public List<Contact> foundContacts { get; set; }
    public Integer selectedRow;
    public Integer selectedRegistrationRow;
    public Event_Registration__c selectedRegistration { get; set; }
    public Id selectedId { get; set; }
    public Integer searchResultSize { get; set; }
    public List<Event_Leader__c> leadersToDelete;
    public boolean isCopy = false;
    public String sponsorDescription;
    private boolean entityChanging = false;
    public boolean saveSuccessful { get; set; } {saveSuccessful = false;}
    public String ldrAddOption;
    public List<SelectOption> registrationStatusOptions;
    public List<SelectOption> localCampaignOptions;
    public static final Integer maxSearchResults = 200;
    public Date originalDtBegin;
    public String previousStatus;
    private String previousClubEntity;
    public Boolean datesConfirmed {get; set;} {datesConfirmed = false;}
    public Boolean updateSingleEvent {get; set;} {updateSingleEvent = false;}
    public Boolean returnAfterSave {get; set;} {returnAfterSave = false;}
    public String futureDates {get; set;}
    private transient String entityName;
    private transient String entityType;

	public Club_Event__c getClubEvent() {
        if(ClubEvent == null) {
            String copy = ApexPages.currentPage().getParameters().get('copy');
            Id id = ApexPages.currentPage().getParameters().get('id');
            if(id == null && copy == null) {
                ClubEvent = new Club_Event__c();
                ClubEvent.Display_Method__c = 'Salesforce Events Page';
                ClubEvent.Show_on_Map__c = true;
                ClubEvent.Is_Club_Activity__c = true;
            }
            else {
                ClubEvent = retrieveClubEvent(id);
                if(copy != null) {
                    if(copy == 'true') {
                        Club_Event__c EventCopy = ClubEvent.clone(false, true, false, false);
                        isCopy = true;
                        EventCopy.Campaign__c = null;
                        EventCopy.Date_Begin__c = null;
                        EventCopy.Date_End__c = null;
                        EventCopy.Registration_Cutoff__c = null;
                        EventCopy.Begin_Publication__c = null;
                        EventCopy.Unpublish_Date__c = null;
                        EventCopy.Status__c = 'In Development';
                        EventCopy.RecurringEvent__c = null;
                        EventCopy.Recurring_Dates__c = null;
                        List<Event_Leader__c> ldrList = new List<Event_Leader__c>([
                            select Contact__c, Contact__r.Name, Phone_or_Other_Contact_Information__c, Email__c, Leader_Name__c, Club_Event__c, Is_Primary_Leader__c
                            from Event_Leader__c
                            where Club_Event__c = :ClubEvent.Id
                            order by Is_Primary_Leader__c desc, Contact__r.Name
                        ]);
                        List<Event_Leader__c> ldrCopy = ldrList.deepClone(false, false, false);
                        Integer row = 0;
                        leaderList = new List<EventLeader>();
                        for(Event_Leader__c ldr : ldrCopy) {
                            ldr.Club_Event__c = null;
                            leaderList.add(new EventLeader(ldr, ldr.Contact__r.Name, row));
                            row++;
                        }
                        ClubEvent = EventCopy;
                    }
                }
            }
            originalDtBegin = ClubEvent.Date_Begin__c;
            previousStatus = ClubEvent.Status__c;
            previousClubEntity = ClubEvent.Club_Entity__c;
        }
        return ClubEvent;
	}
	private Club_Event__c retrieveClubEvent(String id) {
		List<Club_Event__c> eventList = [
			select
				Id,
				Additional_Directions__c,
				Additional_Info_URL__c,
				Begin_Publication__c,
				Bring__c,
				Cancel_Reason__c,
				Cancellation_Option__c,
				Cancellation_Policy_Description__c,
				Carpool__c,
				Club_Entity__c,
				Club_Entity__r.Type__c,
				Club_Entity__r.Name,
				Cost_Description__c,
				Date_Begin__c,
				Date_End__c,
				Date_Tentative__c,
				Display_Method__c,
				Entity_Specific_Level__c,
				Event_Category__c,
				Event_Location__c,
				Event_Location__Latitude__s,
				Event_Location__Longitude__s,
				Event_Title__c,
				Event_Type__c,
				External_URL__c,
				Is_Club_Activity__c,
				Level__c,
				Limit_Publication__c,
				Location_Description__c,
				Long_Description__c,
				Short_Description__c,
				Show_on_Map__c,
				Signup_Instructions__c,
				Signup_Restrictions__c,
				Sponsor_Description__c,
				Status__c,
				Time_Begin__c,
				Time_End__c,
				Time_Tentative__c,
				Unpublished_Notes__c,
				URL_Description__c,
				URL_for_Additional_Information__c,
				URL_to_Share__c,
				Full_Description__c,
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
				Campaign__c,
				Deletion_Allowed__c,
				Campaign_Strategy_Global__c,
				National_Campaign_Global__c,
				Local_Campaign_Global__c,
				Waiver_Required__c,
				Marketing_Tags_Global__c,
				Tactic_Owner_Category_Global__c,
				Tactic_Owner_Global__c,
				State_Global__c,
				Local_Grassroots_Campaign__c,
				Show_Participants__c,
				Do_not_show_on_website_calendars__c,
				Recurring_Dates__c,
				RecurringEvent__c,
				Club_Entity__r.Newly_Activated_Outings_Email__c
			from Club_Event__c
			where Id = :id
		];
		if(eventList.isEmpty()) {
			clubEvent = new Club_Event__c();
		}
		else {
			clubEvent = eventList.get(0);
		}
        originalDtBegin = ClubEvent.Date_Begin__c;
        previousStatus = ClubEvent.Status__c;
        previousClubEntity = ClubEvent.Club_Entity__c;
        if(ClubEvent.Event_Category__c == 'Outing') {
        	ClubEvent.Waiver_Required__c = true;
        }
		return clubEvent;
	}
    public String getSponsorDescription() {
        Club_Event__c evnt = getClubEvent();
        if(String.isEmpty(evnt.Sponsor_Description__c)) {
            if(getEntityOptionsSize() == 1) {
                SelectOption opt = getEntities()[0];
                return opt.getLabel().substring(5);
            }
            if(evnt.Club_Entity__c == null) {
                return '';
            } 
            String name = getEntityPermissions().get(evnt.Club_Entity__c).name;
            if(name == null) {
                return '';
            }
            return name.substring(5); 
        }
        return evnt.Sponsor_Description__c;
    }
    public void setSponsorDescription(String sponsorDescription) {
        if(entityChanging) {
            entityChanging = false;
        }
        else {
            getClubEvent().Sponsor_Description__c = sponsorDescription;
        }       
    }
    public String getClubEntity() {
        return getClubEvent().Club_Entity__c;
    }
    public void setClubEntity(String entId) {
        Club_Event__c evnt = getClubEvent();
        if(evnt.Club_Entity__c != entId) {
            evnt.Sponsor_Description__c = '';
            localCampaignOptions = null;
            entityChanging = true;
        }
        evnt.Club_Entity__c = entId;
    }
    private Map<Id, EntityPermissions.EntityPermission> getEntityPermissions() {
        if(EntityPermissionsMap == null) {
            Id userId = UserInfo.getUserId();
            Id contactId;
            if(UserInfo.getUserType() == 'Standard') {
            	contactId = [select Contact__c from User_Lookups__c where User__c = :userId].Contact__c;
            }
            else {
	            contactId = [select ContactId from User where Id=:userId].ContactId;
            }
            List<EntityPermissions.EntityPermission> permList = EntityPermissions.getPermissions(contactId);
            entityPermissionsMap = new Map<Id, EntityPermissions.EntityPermission>();
            for(EntityPermissions.EntityPermission perm : permList) {
                entityPermissionsMap.put(perm.clubEntityId, perm);
            }
        }
        return entityPermissionsMap;
    }
    public List<SelectOption> getEntities() {
        if(entityOptions == null) {
            entityOptions = new List<SelectOption>();
            for(EntityPermissions.EntityPermission perm : getEntityPermissions().values()) {
                entityOptions.add(new SelectOption(perm.clubEntityId, perm.name));
            }
            entityOptions = QuickSort.sortOptionList(entityOptions);
            if(clubEvent.Club_Entity__c == null) {
                if(entityOptions.size() > 1) {
                    entityOptions.add(0, new SelectOption('', '--None--'));
                }
            }
        }
        return entityOptions;
    }
    public Integer getEntityOptionsSize() {
        return getEntities().size();
    }
    
    public List<SelectOption> getStatusOptions() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Club_Event__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : ple) {
            if(entry.getValue() == 'Active') {
                if(includeActiveOption()) {
                    options.add(new SelectOption(entry.getLabel(), entry.getValue()));
                }
            }
            else {
            	Boolean includeOption = false;
            	Club_Event__c ce = getClubEvent();
            	if(ce.Id == null) {
            		includeOption = true;
            	}
            	else {
            		if(ce.Deletion_Allowed__c) {
            			includeOption = true;
            		}
            		else {
            			if(entry.getValue() == 'Active' || entry.getValue() == 'At Capacity' || entry.getValue() == 'Cancelled') {
            				includeOption = true;
            			}
            		}
            	}
            	if(includeOption) {
                	options.add(new SelectOption(entry.getLabel(), entry.getValue()));
            	}
            }
        }
        return options; 
    }
    public List<SelectOption> getCategoryOptions() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Club_Event__c.Event_Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : ple) {
            if(entry.getValue() == 'Outing') {
                if(clubEvent.Event_Category__c == 'Outing' || includeOutingCategory()) {
                    options.add(new SelectOption(entry.getLabel(), entry.getValue()));
                }
            }
            else {
                options.add(new SelectOption(entry.getLabel(), entry.getValue()));
            }
        }
        if(clubEvent.Event_Category__c == null) {
            options.add(0, new SelectOption('','--None--'));
        }
        if(categoryChanged) {
            clubEvent.Event_Type__c = null;
            categoryChanged = false;
        }
        return options; 
    }
    public List<SelectOption> getTypeOptions() {
        List<SelectOption> options = new List<SelectOption>();
        String eventCategory = clubEvent.Event_Category__c;
        if(eventCategory == null) {
            options.add(new SelectOption('','--None--'));
            return options;
        }
        List<Club_Event_Type__c> typeList = new List<Club_Event_Type__c>([
            select Type__c from Club_Event_Type__c where Category__c = :eventCategory
            order by Type__c
        ]);
        for(Club_Event_Type__c eventType : typeList) {
            options.add(new SelectOption(eventType.Type__c, eventType.Type__c));
        }
        if(clubEvent.Event_Type__c == null) {
            options.add(0, new SelectOption('','--None--'));
        }
        return options;
    }
    public PageReference categoryChanged() {
        categoryChanged = true;
        if(clubEvent.Event_Category__c == 'Outing') {
        	clubEvent.Waiver_Required__c = true;
        }
        return null;
    }
    private boolean includeActiveOption() {
        if(previousStatus == 'Active' || clubEvent.Event_Category__c != 'Outing') {
            return true;
        }
        EntityPermissions.EntityPermission permission = getEntityPermissions().get(clubEvent.Club_Entity__c);
        if(permission == null) {
            return false;
        }
        if(permission.clubEventPermissionOutings == 'Administrator') {
            return true;
        }
        return false;
    }
    private boolean includeOutingCategory() {
        if(getEntityOptionsSize() == 1) {
            clubEvent.Club_Entity__c = entityOptions[0].getValue();
        }
        if(clubEvent.Club_Entity__c == null) {
            return false;
        }
        EntityPermissions.EntityPermission permission = getEntityPermissions().get(clubEvent.Club_Entity__c);
        if(permission == null) {
            return false;
        }
        if(permission.clubEventPermissionOutings == 'None') {
            return false;
        }
        return true;
    }
    public String getDtBegin() {
    	if(getClubEvent().Date_Begin__c == null) {
    		return '';
    	}
    	String theDate = clubEvent.Date_Begin__c.format() + ' ' + ClubEvent.Time_Begin__c;
    	return theDate;
    }
    public String getDtBeginString () {
    	return getClubEvent().Date_Begin__c.format();
    }
    public void setDtBeginString(String input) {
    	//need a setter to use with inputHidden
    }
    public void setDtBegin(String input) {
        if(String.isEmpty(input)) {
            getClubEvent().Date_Begin__c = null;
        }
        else {
	        DateTime dt = DateTime.parse(input);
	        getClubEvent().Date_Begin__c = dt.date();
	        getClubEvent().Time_Begin__c = extractTime(dt);
        }
    }
    public String getDtEnd() {
    	if(getClubEvent().Date_End__c == null) {
    		return '';
    	}
    	String theDate = getClubEvent().Date_End__c.format() + ' ' + getClubEvent().Time_End__c;
        return theDate; 
    }
    public void setDtEnd(String input) {
        if(String.isEmpty(input)) {
            getClubEvent().Date_End__c = null;
        }
        else {
	        DateTime dt = DateTime.parse(input);
	        getClubEvent().Date_End__c = dt.date();
	        getClubEvent().Time_End__c = extractTime(dt);
        }    
    }
    public String getBeginPublication() {
    	if(getClubEvent().Begin_Publication__c == null) {
    		return '';
    	}
    	String theDate = getClubEvent().Begin_Publication__c.format();
        return theDate; 
    }
    public void setBeginPublication(String input) {
        if(String.isEmpty(input)) {
            getClubEvent().Begin_Publication__c = null;
        }
        else {
	        Date dt = Date.parse(input);
	        getClubEvent().Begin_Publication__c = dt;
        }    
    }
    public String getRegistrationCutoff() {
    	if(getClubEvent().Registration_Cutoff__c == null) {
    		return '';
    	}
    	String theDate = getClubEvent().Registration_Cutoff__c.format();
        return theDate; 
    }
    public void setRegistrationCutoff(String input) {
        if(String.isEmpty(input)) {
            getClubEvent().Registration_Cutoff__c = null;
        }
        else {
	        Date dt = Date.parse(input);
	        getClubEvent().Registration_Cutoff__c = dt;
        }    
    }

    public String getPageTitle() {
        String title = 'New Sierra Club Event';
        Club_Event__c activity = getClubEvent();
        if(activity != null) {
            if( ! String.isEmpty(activity.Event_Title__c)) {
                title = activity.Event_Title__c;
            }
        }
        return title; 
    }
    public PageReference saveAndReturn() {
    	returnAfterSave = true;
    	PageReference pageRef = save();
    	if(pageRef != null) {
    		return pageRef;
    	}
    	if(saveSuccessful) {
   			return getListPage();
    	}
    	return null;
    }
    public PageReference save() {
        boolean hasErrors = false;
        Club_Event__c activity = getClubEvent();
        if(activity.Club_Entity__c == null) {
            activity.Club_Entity__c.addError('Entity is Required');
            hasErrors = true;
        }
        if(String.isEmpty(activity.Event_Category__c)) {
            activity.Event_Category__c.addError('Category is Required');
            hasErrors = true;
        }
        if(activity.Event_Type__c == null) {
            activity.Event_Type__c.addError('Type is Required');
            hasErrors = true;
        }
        if(String.isEmpty(activity.Event_Title__c)) {
            activity.Event_Title__c.addError('Event Title is Required');
            hasErrors = true;
        }
        if(activity.Date_Begin__c == null) {
            activity.Date_Begin__c.addError('Begin Date is Required');
            hasErrors = true;
        }
        else if(originalDtBegin != null) {
        	if(System.today() > originalDtBegin) {
        		if(activity.Date_Begin__c != originalDtBegin) {
	        		if(activity.Status__c == 'Active' || activity.Status__c == 'At Capacity' || activity.Status__c == 'Cancelled') {
	        			activity.Date_Begin__c.addError('This event has past, and the Begin Date can no longer be changed');
	        			hasErrors = true;
	        		}
        		}
        	}
        }
        if(String.isEmpty(activity.Status__c)) {
            activity.Status__c.addError('Status is Required');
            hasErrors = true;
        }
        if(String.isEmpty(activity.Short_Description__c)) {
            activity.Short_Description__c.addError('Short Description is Required');
            hasErrors = true;
        }
        if(activity.Show_on_Map__c) {
        	if(activity.Event_Location__Latitude__s == null) {
        		activity.Event_Location__Latitude__s.addError('To show on map, Latitude is required');
	            hasErrors = true;
        	}
        	if(activity.Event_Location__Longitude__s == null) {
        		activity.Event_Location__Latitude__s.addError('To show on map, Longitude is required');
        		hasErrors = true;
        	}
        	if(String.isEmpty(activity.Location_Description__c)) {
        		activity.Location_Description__c.addError('To show on map, a Location Description is required');
	            hasErrors = true;
        	}
        }
        if(activity.Send_RSVP_to_Leader__c) {
        	if( ! activity.Registrations_Accepted__c) {
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Registrations Accepted must be set to true in order to Send RSVP Notifications to Leader'));
        		hasErrors = true;
        	}
        }
        boolean hasPrimaryLeader = false;
        Event_Leader__c primaryLdr;
        for(EventLeader el : getLeaderList()) {
        	if(el.isPopulated()) {
	            Event_Leader__c ldr = el.Leader;
	            
	            if(ldr.Is_Primary_Leader__c) {
	                hasPrimaryLeader = true;
	                primaryLdr = el.leader;
	            }
	            if(String.isEmpty(ldr.Leader_Name__c)) {
	                ldr.addError('All Leaders Must have a Name');
	                hasErrors = true;
	            }
	            if(String.isEmpty(ldr.Phone_or_Other_Contact_Information__c) && String.isEmpty(ldr.Email__c)) {
	                ldr.addError('All Leaders must have Contact Information or Email Address');
	                hasErrors = true;
	            }
	            if( ! String.isEmpty(ldr.Email__c)) {
		            if( ! isValidEmail(ldr.Email__c)) {
		            	ldr.addError('Invalid email address: ' + ldr.Email__c);
		            	hasErrors = true;
		            }
	            }
        	}
        }
        if (activity.Status__c != 'In Development') {
        	if ( ! hasPrimaryLeader ) {
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There must be a Primary Leader'));
	            hasErrors = true;
        	}
        	else if(String.isEmpty(primaryLdr.Email__c)) {
        		if(activity.Send_RSVP_to_Leader__c) {
		            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Primary Leader has no email address - cannot send RSVP notifications to Leader'));
		            hasErrors = true;
        		}
        	}
        }
        if(activity.Status__c == 'Cancelled') {
        	if(String.isEmpty(activity.Cancel_Reason__c)) {
        		activity.Cancel_Reason__c.addError('A Cancellation Reason is required when Status is "Cancelled"');
        		hasErrors = true;
        	}
        }
        if(activity.Display_Method__c == 'External URL') {
        	if(activity.Registrations_Accepted__c) {
        		activity.Display_Method__c.addError('Registrations cannot be accepted when Display Method is "External URL"');
        		hasErrors = true;
        	}
        	if(String.isEmpty(activity.External_URL__c)) {
        		activity.External_URL__c.addError('External URL is Required when Display Method is "External URL"');
        		hasErrors = true;
        	}
        	if( ! hasErrors) {
        		activity.URL_to_Share__c = activity.External_URL__c;
        	}
        }
        else {
        	activity.External_URL__c = null;
        	activity.URL_to_Share__c = null;
        }
        
        if(hasErrors) {
        	saveSuccessful = false;
            return null;
        }

		if(activity.Status__c != 'In Development' && activity.Begin_Publication__c == null) {
			activity.Begin_Publication__c = System.today();
		}
		if(activity.Begin_Publication__c != null) {
			if(activity.Date_End__c == null) {
		        if(activity.Begin_Publication__c > activity.Date_Begin__c) {
		            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Begin Publication Date cannot be after Begin Date'));
		    		hasErrors = true;
		        }
			}
		    else if(activity.Begin_Publication__c > activity.Date_End__c) {
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Begin Publication Date cannot be after End Date'));
	    		hasErrors = true;
		    }
		}
		if(activity.Registrations_Accepted__c) {
			if(activity.Registration_Cutoff__c != null) {
				if(activity.Registration_Cutoff__c < activity.Begin_Publication__c) {
		            ApexPages.addmessage(
		            	new ApexPages.message(
		            		ApexPages.severity.ERROR,'Registration Cutoff must be after Begin Publication')
		            	);
		            hasErrors = true;
				}
			}			
		}

		if(activity.Date_End__c != null) {
			if(activity.Date_End__c > activity.Date_Begin__c) {
				if(! String.isEmpty(activity.Recurring_Dates__c)) {
					List<DateTime> dateTimeList = (List<DateTime>)System.Json.deserialize(activity.Recurring_Dates__c, List<DateTime>.class);
					if(dateTimeList.size() > 1) {
			            ApexPages.addmessage(
			            	new ApexPages.message(
			            		ApexPages.severity.ERROR,'Recurring multi-day events are not supported')
			            	);
			            hasErrors = true;
					}
				}
			}
		}

        if(hasErrors) {
        	saveSuccessful = false;
            return null;
        }
		
		if(String.isEmpty(activity.RecurringEvent__c)) {
			if(isNewlyActive() && ( ! datesConfirmed )) {
				if(! String.isEmpty(activity.Recurring_Dates__c)) {
					List<DateTime> dateTimeList = (List<DateTime>)System.Json.deserialize(activity.Recurring_Dates__c, List<DateTime>.class);
					if(dateTimeList.size() > 1) {
						PageReference pageRef = Page.ClubEventEntryConfirmDates;
						pageRef.setRedirect(false);
						return pageRef;
					}
				}
			}
		}
		else if ( ! updateSingleEvent ) {
			if(activity.Status__c == 'Active' || activity.Status__c == 'Cancelled' || activity.Status__c == 'At Capacity') {
				if( ! datesConfirmed ) {
					List<DateTime> dateTimeList1 = (List<DateTime>)System.Json.deserialize(activity.Recurring_Dates__c, List<DateTime>.class);
					if(dateTimeList1.size() > 1) {
						List<DateTime> dateTimeList2 = new List<DateTime>();
						for(DateTime dt : dateTimeList1) {
							if(dt.Date() > activity.Date_Begin__c && dt.Date() >= System.today()) {
								dateTimeList2.add(dt);
							}
						}
						if( ! dateTimeList2.isEmpty()) {
							futureDates = System.Json.serialize(dateTimeList2);
							PageReference pageRef = Page.ClubEventEntryRecurringUpdate;
							pageRef.setRedirect(false);
							return pageRef;
						}
					}
				}
			}
		}

		if(activity.Date_End__c == null) {
			activity.Time_End__c = null;
		}
		if(activity.Require_Phone_Number__c) {
			activity.Ask_for_Phone_Number__c = true;
		}
		if(activity.Require_ZIP_Code__c) {
			activity.Ask_for_ZIP_Code__c = true;
		}
		if(activity.Require_Street_Address__c) {
			activity.Ask_for_Street_Address__c = true;
		}
		if(activity.Require_Mobile_Phone__c) {
			activity.Ask_for_Mobile_Phone__c = true;
		}
		if(activity.Require_Additional_Attendees__c) {
			activity.Ask_for_Additional_Attendees__c = true;
		}
		if(activity.Require_Field_1__c) {
			activity.Display_Field_1__c = true;
		}
		if(activity.Require_Field_2__c) {
			activity.Display_Field_2__c = true;
		}
		if(activity.Require_Field_3__c) {
			activity.Display_Field_3__c = true;
		}
		if(activity.Require_Field_4__c) {
			activity.Display_Field_4__c = true;
		}
		if(activity.Require_Field_5__c) {
			activity.Display_Field_5__c = true;
		}
		if(activity.Event_Category__c == 'Outing') {
			activity.Waiver_Required__c = true;
		}
		
		if( ( ! String.isEmpty(activity.Campaign__c) ) && String.isEmpty(activity.URL_to_Share__c) && activity.Display_Method__c == 'Salesforce Events Page') {
	    	String baseURL = null;
	    	if(Test.isRunningTest()) {
				baseURL = 'http://www.test.org';    			
	    	}
	    	else {
				Map<String, SiteURL__c> urlMap = SiteURL__c.getAll();
				SiteURL__c siteURL = urlMap.get('EventsURL');
				baseURL = siteURL.BaseURL__c;
	    	}
			activity.URL_to_Share__c = baseURL + '?formcampaignid=' + activity.Campaign__c;
		}

		RecurringEvent__c recurringEvent;
		if(String.isEmpty(activity.RecurringEvent__c)) {
			if(isNewlyActive()) {
				if(! String.isEmpty(activity.Recurring_Dates__c)) {
					List<DateTime> dateTimeList = (List<DateTime>)System.Json.deserialize(activity.Recurring_Dates__c, List<DateTime>.class);
					if(dateTimeList.size() > 1) {
						recurringEvent = new RecurringEvent__c();
					}
				}
			}
		}

        if( ! String.isEmpty(activity.Bring__c) ) {
			activity.Bring__c = activity.Bring__c.replaceAll('\\P{Print}', '');
        }
        if( ! String.isEmpty(activity.Additional_Directions__c) ) {
			activity.Additional_Directions__c = activity.Additional_Directions__c.replaceAll('\\P{Print}', '');
		}
        if( ! String.isEmpty(activity.Cancellation_Policy_Description__c) ) {
	        activity.Cancellation_Policy_Description__c = activity.Cancellation_Policy_Description__c.replaceAll('\\P{Print}', '');
		}
        if( ! String.isEmpty(activity.Carpool__c) ) {
			activity.Carpool__c = activity.Carpool__c.replaceAll('\\P{Print}', '');
		}
        if( ! String.isEmpty(activity.Cost_Description__c) ) {
			activity.Cost_Description__c = activity.Cost_Description__c.replaceAll('\\P{Print}', '');
		}
        if( ! String.isEmpty(activity.Short_Description__c) ) {
			activity.Short_Description__c = activity.Short_Description__c.replaceAll('\\P{Print}', '');
		}
        if( ! String.isEmpty(activity.Signup_Instructions__c) ) {
			activity.Signup_Instructions__c = activity.Signup_Instructions__c.replaceAll('\\P{Print}', '');
		}
        if( ! String.isEmpty(activity.Signup_Restrictions__c) ) {
			activity.Signup_Restrictions__c = activity.Signup_Restrictions__c.replaceAll('\\P{Print}', '');
        }
				
		EventHelper.sourceObject = 'ClubEvent';
		try {
        	upsert activity;
		}
		catch(DmlException e) {
			ApexPages.addMessages(e);
			saveSuccessful = false;
			return null;
		}
		catch(Exception e) {
			String errorMessage = e.getMessage();
            ApexPages.addmessage(
            	new ApexPages.message(
            		ApexPages.severity.ERROR,errorMessage)
            	);
			saveSuccessful = false;
			return null;
		}

		Campaign camp;

		if(String.isEmpty(activity.Campaign__c)) {		
			Club_Event__c evnt = [SELECT Name, CreatedDate FROM Club_Event__c WHERE Id=:activity.Id];
			String campName = ClubEventTriggerHandler.getCampaignId(evnt);
			camp = [SELECT Id, URL_to_Share__c FROM Campaign WHERE Name = :campName];
		}

		if(recurringEvent != null || camp != null) {
			if(recurringEvent != null) {
				insert recurringEvent;
				activity.RecurringEvent__c = recurringEvent.id;
			}
			if(camp != null) {
				activity.Campaign__c = camp.Id;
				activity.URL_to_Share__c = camp.URL_to_Share__c;
			}
			update activity;
		}

        List<Event_Leader__c> leadersToUpdate = new List<Event_Leader__c>();
        Map<Integer, RecurringEventLeader__c> recurringEventLeaderMap = new Map<Integer, RecurringEventLeader__c>();
        for(EventLeader ldr : leaderList) {
        	if(ldr.isPopulated()) {
            	if(ldr.leader.Club_Event__c == null) {
                	ldr.leader.Club_Event__c = activity.Id;
            	}
	            if(ldr.leader.Campaign__c == null) {
	            	ldr.leader.Campaign__c = activity.Campaign__c;
	            }
	            if(recurringEvent != null && ldr.leader.RecurringEventLeader__c == null) {
	            	recurringEventLeaderMap.put(ldr.row, new RecurringEventLeader__c());
	            }
	            leadersToUpdate.add(ldr.leader);
        	}
        }
        List<RecurringEventLeader__c> recurringEventLeaderList = recurringEventLeaderMap.values();
        if( ! recurringEventLeaderList.isEmpty() ) {
        	insert recurringEventLeaderList;
        }
        if( recurringEvent != null && ( ! recurringEventLeaderList.isEmpty() )) {
        	for(EventLeader ldr : leaderList) {
	        	if(ldr.isPopulated()) {
	        		if(ldr.leader.RecurringEventLeader__c == null) {
	        			ldr.leader.RecurringEventLeader__c = recurringEventLeaderMap.get(ldr.row).Id;
	        		}
	        	}
        	}
        }
        upsert leadersToUpdate;

        if(leadersToDelete != null) {
            if(leadersToDelete.size() > 0) {
                delete leadersToDelete;
            }
        }
        
        Club_Event__c ev = getClubEvent();
        if(ev.Club_Entity__c == previousClubEntity) {
        	entityName = ev.Club_Entity__r.Name;
    		entityType = ev.Club_Entity__r.Type__c;
    	}
    	else {
   			Club_Entity__c clubEntity = [select Name, Type__c from Club_Entity__c where Id = :ev.Club_Entity__c];
   			entityName = clubEntity.Name;
   			entityType = clubEntity.Type__c;
    	}
        
        Boolean notifyLeader = isNewlyApproved() || isNewlyDisapproved() || isNewlyChangesRequired();
        if(isNewlyActive() || isNewlyPendingOuting() || notifyLeader) {
        	ClubEventLeaderEmail.send(activity, primaryLdr, entityName, isNewlyActive(), notifyLeader);
        }
		else if(isNewlyCancelled()) {
			List<EventRegistration> regList = getRegistrationList();
			if( ! regList.isEmpty()) {
				List<Event_Registration__c> evRegList = new List<Event_Registration__c>();
				for(EventRegistration reg : regList) {
					evRegList.add(reg.registration);
				}
				ClubEventCancellationEmail.send(activity, evRegList); 
			}
		}
		
		if(! String.isEmpty(activity.Recurring_Dates__c)) {
			List<DateTime> dateTimeList = (List<DateTime>)System.Json.deserialize(activity.Recurring_Dates__c, List<DateTime>.class);
			List<Date> dateList = new List<Date>();
			for(DateTime dt : dateTimeList) {
				dateList.add(dt.date());
			}
		}
		
        if(datesConfirmed) {
			if(isNewlyActive()) {
				CreateRecurringEvents creator = new CreateRecurringEvents(clubEvent.Campaign__c);
				Id jobId = System.enqueueJob(creator);
			}
			else {
				UpdateRecurringEvents updater = new UpdateRecurringEvents(clubEvent.Campaign__c, isNewlyCancelled(), leadersToUpdate, leadersToDelete);
				Id jobId = System.enqueueJob(updater);
			}
        }
        
        clubEvent = retrieveClubEvent(clubEvent.Id);
        saveSuccessful = true;
        originalDtBegin = ClubEvent.Date_Begin__c;
        previousStatus = ClubEvent.Status__c;
        previousClubEntity = ClubEvent.Club_Entity__c;
        
     	datesConfirmed = false;
		updateSingleEvent = false;
        
        return null;
    }
    public PageReference cancel() {
        return getListPage();
    }
    public PageReference confirmSave() {
    	datesConfirmed = true;
    	save();
    	if(returnAfterSave) {
    		return getListPage();
    	}
    	return Page.ClubEventEntry;
    }
    public PageReference cancelSave() {
    	return Page.ClubEventEntry;
    }
    public PageReference updateOneEventOnly() {
    	datesConfirmed = false;
		updateSingleEvent = true;
    	save();
    	if(returnAfterSave) {
    		return getListPage();
    	}
    	return Page.ClubEventEntry;
    }
    public PageReference updateFutureEvents() {
    	datesConfirmed = true;
		updateSingleEvent = false;
    	save();
    	if(returnAfterSave) {
    		return getListPage();
    	}
    	return Page.ClubEventEntry;
    }
    public List<EventLeader> getLeaderList() {
        Id eventId = getClubEvent().Id;
        if(leaderList == null) {
            if(eventId == null) {
                leaderList = new List<EventLeader>();
            }
            else {
                leaderList = new List<EventLeader>();
                List<Event_Leader__c> ldrList = new List<Event_Leader__c>([
                    select 
                    	Contact__c, 
                    	Contact__r.Name, 
                    	Phone_or_Other_Contact_Information__c, 
                    	Email__c, 
                    	Leader_Name__c, 
                    	Club_Event__c,
                    	Campaign__c, 
                    	Is_Primary_Leader__c,
                    	RecurringEventLeader__c
                    from Event_Leader__c
                    where Club_Event__c = :eventId
                    order by Is_Primary_Leader__c desc, Contact__r.Name
                ]);
                Integer row = 0;
                for(Event_Leader__c ldr : ldrList) {
                    leaderList.add(new EventLeader(ldr, ldr.Contact__r.Name, row));
                    row++;
                }
            }
        }
        return leaderList;
    }
    public Boolean getIsNewlyCancelled() {
    	return isNewlyCancelled();
    } 
    public Boolean isNewlyCancelled() {
		if(previousStatus == null) {
			return false;
		}
		if(previousStatus == 'Active' || previousStatus == 'At Capacity') {
			if(getClubEvent().Status__c == 'Cancelled') {
				return true;
			}
		}
		return false;
    }
    public Boolean isNewlyPendingOuting() {
    	Club_Event__c ev = getClubEvent();
    	if(ev.Event_Category__c == 'Outing' && ev.Status__c == 'Pending Approval') {
    		if(entityType == 'Chapter' || entityType == 'Group' || entityType == 'Activity Sections') {
    			if(previousStatus == null) {
    				return true;
    			}
    			return ! (previousStatus == 'Pending Approval');
    		}
    	}
		return false;
    }
    public Boolean isNewlyChangesRequired() {
    	Club_Event__c ev = getClubEvent();
    	if(ev.Status__c == 'Changes Required') {
    		if(previousStatus == null) {
    			return true;
    		}
    		return ! (previousStatus == 'Changes Required');
    	}
		return false;
    }
    public Boolean isNewlyApproved() {
    	Club_Event__c ev = getClubEvent();
    	if(ev.Status__c == 'Active') {
    		if(previousStatus != null) {
    			if(previousStatus == 'Pending Approval' || previousStatus == 'Changes Required' || previousStatus == 'Disapproved') {
    				return true;
    			}
    		}
    	}
		return false;
    }
    public Boolean isNewlyActive() {
    	Club_Event__c ev = getClubEvent();
    	if(ev.Status__c == 'Active') {
    		if(previousStatus == null || previousStatus == 'In Development') {
    			return true;
    		}
    		if(isNewlyApproved()) {
    			return true;
    		}
    	}
    	return false;
    }
    public Boolean isNewlyDisapproved() {
    	Club_Event__c ev = getClubEvent();
    	if(ev.Status__c == 'Disapproved') {
    		if(previousStatus == null) {
    			return true;
    		}
    		return ! (previousStatus == 'Disapproved');
    	}
		return false;
    }
    public List<EventRegistration> getRegistrationList() {
        Id eventId = getClubEvent().Id;
        if(registrationList == null) {
        	if(eventId == null) {
        		registrationList = new List<EventRegistration>();
        	}
        	else {
        		List<Event_Registration__c> regList = [
        			select
        				First_Name__c,
        				Last_Name__c,
        				Full_Name__c,
        				Status__c,
        				Email__c,
        				Phone__c,
        				Mobile_Phone__c,
        				PostalCode__c,
        				Street__c,
        				City__c,
        				State__c,
        				Contact__c,
        				Additional_Attendees__c,
        				Custom_Field_1_Response__c,
        				Custom_Field_2_Response__c,
        				Custom_Field_3_Response__c,
        				Custom_Field_4_Response__c,
        				Custom_Field_5_Response__c,
        				CreatedDate,
        				Waiver_Submitted__c
        			from Event_Registration__c
        			where Club_Event__c = :eventId
        			order by Last_Name__c, First_Name__c	
        		];
        		registrationList = new List<EventRegistration>();
        		Integer row = 0;
        		for(Event_Registration__c reg : regList) {
        			registrationList.add(new EventRegistration(reg, row));
        			row++;
        		}
        	}
        }
        return registrationList;
    }
    public PageReference resetRegistrationList() {
    	registrationList = null;
    	return null;
    }
    public PageReference addLeader() {
        List<EventLeader> ldrList = getLeaderList();
        Event_Leader__c ldr = new Event_Leader__c(Club_Event__c=clubEvent.Id);
        if(ldrList.isEmpty()) {
        	ldr.Is_Primary_Leader__c = true;
        }
        ldrList.add(new EventLeader(ldr, '', ldrList.size()));
        return null;
    }
    public PageReference deleteLeader() {
    	Event_Leader__c leaderToDelete = leaderList.get(selectedRow).leader;
    	if(leaderToDelete.Id != null) {
	        if(leadersToDelete == null) {
	            leadersToDelete = new List<Event_Leader__c>();
	        }
	        leadersToDelete.add(leaderToDelete);
    	}
        leaderList.remove(selectedRow);
        Integer row = 0;
        for(EventLeader leader : leaderList) {
            leader.row = row;
            row++;
        }
        return null;
    }
    public Integer getLeaderListSize() {
        return getLeaderList().size();
    }
    public Integer getMaxSearchResults() {
    	return maxSearchResults;
    }
    public PageReference adjustPrimaryLeader() {
        Event_Leader__c selectedLeader = getLeaderList().get(selectedRow).leader;
        if(selectedLeader.Is_Primary_Leader__c) {
            for(EventLeader ldr : getLeaderList()) {
                if(ldr.row != selectedRow) {
                    ldr.leader.Is_Primary_Leader__c = false;
                }
            }
        }
        return null;
    }
    public PageReference searchContacts() {
        if(contactSearchValue == null) {
            return null;
        }
        if(contactSearchValue.length() < 2) {
        	return null;
        }
        String searchValue = contactSearchValue.replaceAll(' ', '* ');
        searchValue = searchValue + '*';
        String searchquery='FIND \'' + searchValue + 
            '\' IN ALL FIELDS RETURNING Contact(id, AccountId, AttnFlag__c, name, Email, MailingStreet, MailingCity, MailingState, MailingPostalCode, Phone ORDER BY LastName, FirstName) LIMIT ' + maxSearchResults;
        List<List<SObject>>searchList=search.query(searchquery);
        
        List<Contact> resultList = ((List<Contact>)searchList[0]);
        
        Set<Id> accountIds = new Set<Id>();
        for(Contact ctct : resultList) {
        	accountIds.add(ctct.AccountId);
        }
        
        Map<Id, Account> accountMap = new Map<Id, Account>([
        	select Id, Membership__c from Account where Id in :accountIds 
        ]);
        
        for(Contact ctct : resultList) {
        	ctct.AttnFlag__c = false;
        	Account acct = accountMap.get(ctct.AccountId);
        	if(acct != null) {
        		if(acct.Membership__c != null) {
        			ctct.AttnFlag__c = true;
        		}
        	}
        }
		        
        foundContacts = (resultList);
        searchResultSize = foundContacts.size();
        contactSearchValue = null;
        return null;
    }
    public PageReference cancelSearchContacts() {
        contactSearchValue = null;
        foundContacts = null;
        searchResultSize = null;
        return null;
    }
    public boolean getHasSearchResults() {
        if(foundContacts == null) {
            return false;
        }
        if(foundContacts.size() > 0) {
            return true;
        }
        return false;
    }
	public String extractTime(DateTime dt) {
	    String[] parts = dt.format().split(' ');
	    return parts[1] + ' ' + parts[2];
	}
    public PageReference setSelectedLeader() {
    	if(ldrAddOption == 'Existing') {
    		addLeader();
    		selectedRow = getLeaderList().size() - 1;
    	}
        EventLeader wrapper = getLeaderList().get(selectedRow);
        Contact ct = [select Id, Name, Email, Phone from Contact where Id = :selectedId LIMIT 1];
        wrapper.displayName = ct.Name;
        Event_Leader__c ldr = wrapper.leader;
        ldr.Contact__c = selectedId;
        ldr.Phone_or_Other_Contact_Information__c = ct.Phone;
        ldr.Email__c = ct.Email;
        ldr.Leader_Name__c = ct.Name;
        
        foundContacts = null;
        contactSearchValue = null;
        searchResultSize = null;
        
        return null;
    }
    public class EventLeader {
        public Event_Leader__c leader { get; set; }
        public Integer row { get; set; }
        public String displayName { get; set; }
        public EventLeader(Event_Leader__c leader, String displayName, Integer row) {
            this.leader = leader;
            this.displayName = displayName;
            this.row = row;
        }
        public Boolean isPopulated() {
        	if(leader == null) {
        		return false;
        	}
			else {
				if(
					String.isEmpty(leader.Contact__c) &&
					String.isEmpty(leader.Email__c) &&
					String.isEmpty(leader.Leader_Name__c) &&
					String.isEmpty(leader.Phone_or_Other_Contact_Information__c) 
				) {
					return false;						
				}
			}
			return true;        	
        }         
    }
    public class EventRegistration {
    	public Event_Registration__c registration { get; set; }
    	public Integer row { get; set; }
    	public EventRegistration(Event_Registration__c registration, Integer row) {
    		this.registration = registration;
    		this.row = row;
    	}
    }
    private PageReference getListPage() {
        return Page.ClubEventList;
    }
    public String getBaseUrl() {
        return URL.getSalesforceBaseUrl().toExternalForm() + '/campfire';
    }
    public PageReference setSelectedRegistrationRow(Integer row) {
    	selectedRegistrationRow = row;
    	EventRegistration reg = registrationList.get(row);
    	selectedRegistration = reg.registration;
    	return null;
    }
	public void setSelectedRow(Integer row) {
		selectedRow = row;
	}
	public Integer getSelectedRow() {
		return selectedRow;
	}

    public Integer getSelectedRegistrationRow() {
    	return selectedRegistrationRow;
    }
    public List<SelectOption> getRegistrationStatusOptions() {
    	if(registrationStatusOptions == null) {
	        registrationStatusOptions = new List<SelectOption>();
			Schema.DescribeFieldResult statusFieldDescription = Event_Registration__c.Status__c.getDescribe();
			for(Schema.Picklistentry entry : statusFieldDescription.getPicklistValues()) {
				registrationStatusOptions.add(new SelectOption(entry.getValue(), entry.getLabel()));
			}
    	}
		return registrationStatusOptions; 
    }
    public List<SelectOption> getLocalCampaignOptions() {
    	if(localCampaignOptions == null) {
    		List<SelectOption> optionList = new List<SelectOption>();
   			optionList.add(new SelectOption('', '-- None --'));
    		Id entityId = getClubEvent().Club_Entity__c;
    		if(entityId != null) {
    			List<Local_Grassroots_Campaign__c> campOptions = [
    				select Id, Name 
    				from Local_Grassroots_Campaign__c
    				where Club_Entity_Team__c = :entityId
    				order by Name
    			];
    			for(Local_Grassroots_Campaign__c camp : campOptions) {
    				optionList.add(new SelectOption(camp.Id, camp.Name));
    			}
    		}
    		localCampaignOptions = optionList;
    	}
    	return localCampaignOptions;
    }
    public PageReference registrationStatusChanged() {
    	saveSelectedRegistration();
    	return null;
    }
    public PageReference saveSelectedRegistration() {
    	update selectedRegistration;
    	registrationList = null;
    	return null;
    }
    public Integer getRegListSize() {
    	return getRegistrationList().size();
    }
    public String getLdrAddOption() {
    	if(ldrAddOption == null) {
    		ldrAddOption = 'Existing';
    	}
    	return ldrAddOption;
    }
    public void setLdrAddOption(String option) {
    	ldrAddOption = option;
    }
    public PageReference exportRegistrants() {
        return page.ClubEventRegistrantList;
    }
    private static Boolean isValidEmail(String email) {
		String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(email);
		return MyMatcher.matches();
	}
	public PageReference sendEmail() {
		PageReference pageRef = Page.SendEventEmailNew;
		pageRef.getParameters().put('eventid', getClubEvent().Campaign__c);
		pageRef.getParameters().put('clubEventId', getClubEvent().id);
		return pageRef;
	}
    public List<RegistrantExportRow> getRegistrantExportList() {
    	List<RegistrantExportRow> rowList = new List<RegistrantExportRow>();
    	for(EventRegistration reg : getRegistrationList()) {
    		RegistrantExportRow row = new RegistrantExportRow();
    		row.dtCreated = reg.registration.CreatedDate;
    		row.firstName = reg.registration.First_Name__c;
    		row.lastName = reg.registration.Last_Name__c;
    		row.street = reg.registration.Street__c;
    		row.city = reg.registration.City__c;
    		row.state = reg.registration.State__c;
    		row.postalCode = reg.registration.PostalCode__c;
    		row.email = reg.registration.Email__c;
    		row.phone = reg.registration.Phone__c;
    		row.mobilePhone = reg.registration.Mobile_Phone__c;
    		row.status = reg.registration.Status__c;
    		row.additionalAttendees = (Integer)reg.registration.Additional_Attendees__c;
          	row.response1 = reg.registration.Custom_Field_1_Response__c;
          	row.response2 = reg.registration.Custom_Field_2_Response__c;
          	row.response3 = reg.registration.Custom_Field_3_Response__c;
          	row.response4 = reg.registration.Custom_Field_4_Response__c;
          	row.response5 = reg.registration.Custom_Field_5_Response__c;
          	row.dtCreated = reg.registration.CreatedDate;
    		rowList.add(row);
    	}
    	return rowList;
    }
    public class RegistrantExportRow {
        private String timeZone = System.UserInfo.getTimeZone().getID();
        private Time zTime = Time.newInstance(0,0,0,0);
    	public String firstName {get; set;}
    	public String lastName {get; set;}
    	public String street {get; set;}
    	public String city {get; set;}
    	public String state {get; set;}
    	public String postalCode {get; set;}
    	public String email {get; set;}
    	public String phone {get; set;}
    	public String mobilePhone {get; set;}
    	public String status {get; set;}
  		public Integer additionalAttendees {get; set;}
  		public String response1 {get; set;}
  		public String response2 {get; set;}
  		public String response3 {get; set;}
  		public String response4 {get; set;}
  		public String response5 {get; set;}
		public DateTime dtCreated {get; set;}

        public String getCreatedDate() {
        	return dtCreated.format('MM/dd/yyyy', timeZone);
        }
    }
    private class RecurringDates {
    	List<Date> dateList;
    }
}