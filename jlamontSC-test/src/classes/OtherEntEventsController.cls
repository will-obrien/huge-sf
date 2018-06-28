public with sharing class OtherEntEventsController {
	public Id clubEntityId;
	public String sponsoringEntityId {get; set;}
	public String earliestDateString {get; set;}
	public String latestDateString {get; set;}
    private Map<Id, EntityPermissions.EntityPermission> entityPermissionsMap;
    private List<SelectOption> entityOptions;
    private List<Other_Entity_Event__c> otherEntityEvents;
    public List<EventWrapper> searchResults {get; set;} {searchResults = new List<EventWrapper>();}
    public Boolean noSearchResults {get; set;} {noSearchResults = false;}
    private Set<Id> otherEntityEventIds = new Set<Id>();

	public PageReference searchEvents() {
		Boolean hasErrors = false;
	    Club_Entity__c sponsoringEntity;
		if(String.isEmpty(sponsoringEntityId)) {
	        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Sponsoring Entity Id is Required'));
	        hasErrors = true;
		}
		else {
			List<Club_Entity__c> entList = [
				select Id from Club_Entity__c where EntityId__c = :sponsoringEntityId
			];
			if(entList.isEmpty()) {
		        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Sponsoring Entity Not Found'));
		        hasErrors = true;
			}
			else {
				sponsoringEntity = entList.get(0);
			}
		}
		Date earliestDate, latestDate;
		if(String.isEmpty(earliestDateString)) {
	        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Earliest Date is Required'));
	        hasErrors = true;
		}
		else {
			try {
				earliestDate = DateTime.parse(earliestDateString + ' 12:00 AM').date();
			}
			catch (Exception e) {
				System.debug('Exception: ' + e.getMessage());
		        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Earliest Date is Not a Valid Date'));
		        hasErrors = true;
			}
		}
		if(String.isEmpty(latestDateString)) {
	        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Latest Date is Required'));
	        hasErrors = true;
		}
		else {
			try {
				latestDate = DateTime.parse(latestDateString + ' 12:00 AM').date();
			}
			catch (Exception e) {
		        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Latest Date is Not a Valid Date'));
		        hasErrors = true;
			}
		}
		System.debug('hasErrors: ' + hasErrors);
		if(hasErrors) {
			return null;
		}
		List<Club_Event__c> eventList = [
			select
				Id,
				Date_Begin__c,
				Event_Title__c,
				Event_Category__c,
				Event_Type__c
			from Club_Event__c
			where
				Club_Entity__c = :sponsoringEntity.Id
				and Status__c = 'Active'
				and Date_Begin__c >= :earliestDate
				and Date_Begin__c <= :latestDate
		];
		searchResults.clear();
		for(Club_Event__c ev : eventList) {
			searchResults.add(new EventWrapper(ev));
		}
		noSearchResults = searchResults.isEmpty();
		return null;
	}
	public PageReference cancelSearch() {
		searchResults = new List<EventWrapper>();
		sponsoringEntityId = '';
		earliestDateString = '';
		latestDateString = '';
		noSearchResults = false;
		return null;
	}
	public PageReference entityChanged() {
		otherEntityEvents = null;
		return null;
	}
	public PageReference addSelected() {
		List<Other_Entity_Event__c> selectedEvents = new List<Other_Entity_Event__c>();
		for(EventWrapper wrap : searchResults) {
			if(wrap.isChecked) {
				if(! otherEntityEventIds.contains(wrap.Event.Id)) {
					Other_Entity_Event__c oee = new Other_Entity_Event__c(
						Club_Entity__c = clubEntityId,
						Club_Event__c = wrap.Event.Id
					);
					selectedEvents.add(oee);
				}
			}
		}
		if( ! selectedEvents.isEmpty() ) {
			insert selectedEvents;
			otherEntityEvents = null;	
		}
		return null;
	}
	public List<Other_Entity_Event__c> getOtherEntityEvents() {
		if(otherEntityEvents == null) {
			otherEntityEvents = [
				select 
					Id, 
					Club_Event__r.Event_Title__c, 
					Club_Event__r.Club_Entity__r.EntityId__c, 
					Club_Event__r.Club_Entity__r.Name, 
					Club_Event__r.Date_Begin__c 
				from Other_Entity_Event__c 
				where Club_Entity__c = :getClubEntityId()
				order by Club_Event__r.Date_Begin__c
			];
		}
		otherEntityEventIds.clear();
		for(Other_Entity_Event__c oee : otherEntityEvents) {
			otherEntityEventIds.add(oee.Club_Event__c);
		}
		return otherEntityEvents;
	}
	
    public List<SelectOption> getEntities() {
        if(entityOptions == null) {
            entityOptions = new List<SelectOption>();
            for(EntityPermissions.EntityPermission perm : getEntityPermissions().values()) {
                entityOptions.add(new SelectOption(perm.clubEntityId, perm.name));
            }
            entityOptions = QuickSort.sortOptionList(entityOptions);
            if(clubEntityId == null) {
            	clubEntityId = entityOptions.get(0).getValue();
            }
        }
        return entityOptions;
    }
    public Id getClubEntityId() {
    	if(clubEntityId == null) {
    		clubEntityId = getEntities().get(0).getValue();
    	}
    	return clubEntityId;
    }
    public void setClubEntityId (Id entityId) {
    	this.clubEntityId = entityId;
    }
    public PageReference deleteEvent() {
        Id id = System.currentPageReference().getParameters().get('id');
        Other_Entity_Event__c eventToDelete = new Other_Entity_Event__c(Id = id);
        delete eventToDelete;
        otherEntityEvents = null;
        return null;
    }
    public PageReference adminPage() {
    	return Page.ClubEventAdministration;
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
    public Class EventWrapper {
    	public Boolean isChecked {get; set;}
    	public Club_Event__c event {get; set;}
    	public EventWrapper(Club_Event__c event) {
    		this.event = event;
    		this.isChecked = false;
    	}
    }
}