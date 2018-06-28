public without sharing class EventsAddedController {
    private Map<Id, EntityPermissions.EntityPermission> entityPermissionsMap;
    public List<SelectOption> entityOptions;
	public String reportOption {get; set;} {reportOption = 'CHAP';}
	public Id clubEntity;
	public String entityType;
	
	public List<EventData> events;
	
	public Date dtBegin {get; set;}
	public Date dtEnd {get; set;} {dtEnd = System.today();}
	public List<EventData> getEvents() {
		String queryString = 
			'select ' +		
			'Club_Entity__r.EntityId__c entityId, ' +
			'Club_Entity__r.Name entityName, ' +
			'CreatedBy.FirstName firstName, ' +
			'CreatedBy.LastName lastName, ' +
			'count(Id) eventCount, ' +
			'min(CreatedDate) dtEarliest, ' +
			'max(CreatedDate) dtLatest ' +
			'from Club_Event__c ' +
			'where CreatedDate >= :dtBegin ' +
			'and CreatedDate <= :dtEnd ';

		EntityPermissions.EntityPermission perm = getEntityPermissions().get(clubEntity);
		if(perm.entityType == 'Chapter') {
			if(reportOption == 'GRP') {
				queryString += 'and (Club_Entity__c = :clubEntity or Club_Entity__r.Parent_Chapter__c = :clubEntity) ';
			}
			else {
				queryString += 'and Club_Entity__c = :clubEntity ';
			}
		}
		queryString += 'group by Club_Entity__r.EntityId__c, Club_Entity__r.Name, CreatedBy.LastName, CreatedBy.FirstName ';
		queryString += 'order by Club_Entity__r.EntityId__c, Club_Entity__r.Name, CreatedBy.LastName, CreatedBy.FirstName';

		AggregateResult[] eventSummary = Database.query(queryString);

		events = new List<EventData>();
		Integer eventNum = 0;
		for(AggregateResult ev : eventSummary) {
			EventData evData = new EventData();
			evData.entityId = (String)ev.get('entityId');
			evData.entityName = (String)ev.get('entityName');
			evData.firstName = (String)ev.get('firstName');
			evData.lastName = (String)ev.get('lastName');
			evData.eventCount = (Integer)ev.get('eventCount');
			evData.dtEarliest = (DateTime)ev.get('dtEarliest');
			evData.dtLatest = (DateTime)ev.get('dtLatest');
			evData.eventNum = eventNum++;
			events.add(evData);
		}
		return events;
	}
    private Map<Id, EntityPermissions.EntityPermission> getEntityPermissions() {
        if(EntityPermissionsMap == null) {
            Id userId = UserInfo.getUserId();
            Id contactId;
            if(Test.isRunningTest()) {
            	contactId = EventsAddedControllerTest.contactId;
            }
            else if(UserInfo.getUserType() == 'Standard') {
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
        }
        return entityOptions;
    }
	public Id getClubEntity() {
		return clubEntity;
	}
	public String getEntityName() {
		EntityPermissions.EntityPermission perm = getEntityPermissions().get(clubEntity);
		return perm.name.substring(5);
	}
	public void setClubEntity(Id entityId) {
		this.clubEntity = entityId;
		EntityPermissions.EntityPermission perm = getEntityPermissions().get(entityId);
		entityType = perm.entityType;
	}
	public String getEntityType() {
		if(entityType == null) {
			EntityPermissions.EntityPermission perm = getEntityPermissions().get(getEntities().get(0).getValue());
			entityType = perm.entityType;
		}
		return entityType;
	}
	public void setEntityType(String entType) {
		this.entityType = entType;
	}
    public String getDtBeginString() {
    	if(dtBegin == null) {
    		return '';
    	}
    	String theDate = dtBegin.format();
    	return theDate;
    }
    public void setDtBeginString(String input) {
        if(String.isEmpty(input)) {
            dtBegin = null;
        }
        else {
	        dtBegin = Date.parse(input);
        }
    }
    public String getDtEndString() {
    	if(dtEnd == null) {
    		return '';
    	}
    	String theDate = dtEnd.format();
        return theDate; 
    }
    public void setDtEndString(String input) {
        if(String.isEmpty(input)) {
            dtEnd = null;
        }
        else {
	        dtEnd = Date.parse(input);
        }    
    }
    public PageReference displayReport() {
    	boolean hasErrors = false;
    	if(dtBegin == null) {
	        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Earliest Add Date is Required'));
			hasErrors = true;
    	}
    	if(dtEnd == null) {
	        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Latest Add Date is Required'));
			hasErrors = true;
    	}
    	if(hasErrors) {
    		return null;
    	}
    	return Page.EventsAddedReport;
    }
    public PageReference cancel() {
    	return Page.ClubEventAdministration;
    }
	public Class EventData {
		public String entityId {get; set;}
		public String entityName {get; set;}
		public String firstName {get; set;}
		public String lastName {get; set;}
		public Integer eventCount {get; set;}
		public DateTime dtEarliest {get; set;}
		public DateTime dtLatest {get; set;}
		public Integer eventNum {get; set;}
	}
}