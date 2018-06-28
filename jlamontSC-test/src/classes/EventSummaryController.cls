public without sharing class EventSummaryController {
	public Date dtBegin {get; set;}
	public Date dtEnd {get; set;} {dtEnd = System.today();}
    private Map<Id, EntityPermissions.EntityPermission> entityPermissionsMap;
    private String chapterName;
    public List<SelectOption> entityOptions;
	public Id clubEntity;
	public String entityType;
	public String reportOption {get; set;} {reportOption = 'CHAPONLY';}
	public List<EventData> events;
	public Club_Event__c clubEvent {get; set;} {clubEvent = new Club_Event__c();}
	public String addlCriteria;
	
	public List<EventData> getEvents() {
		String commonFields = 
			'Event_Category__c eventCategory, ' +
			'Event_Type__c eventType, ' +
			'count(Id) eventCount, ' +
			'min(Date_Begin__c) dtEarliest, ' +
			'max(Date_Begin__c) dtLatest, ' +
			'sum(Campaign__r.Event_Registration_Count__c) registeredCount, ' +
			'sum(Campaign__r.Cancelled_Count__c) cancelledCount, ' +
			'sum(Campaign__r.Attended_Count__c) attendedCount, ' +
			'sum(Campaign__r.NoShow_Count__c) noShowCount ';

		String whereClause =
			'Date_Begin__c >= :dtBegin ' +
			'and Date_Begin__c <= :dtEnd ';
		
		EntityPermissions.EntityPermission perm = getEntityPermissions().get(clubEntity);
		if(perm.entityType == 'Chapter' && reportOption == 'CHAPONLY') {
			whereClause += 'and Club_Entity__c = :clubEntity ';
		}
		else {
			whereClause += 'and (Club_Entity__c = :clubEntity or Club_Entity__r.Parent_Chapter__c = :clubEntity) ';
		}
		
		String nationalCampaign = clubEvent.National_Campaign_Global__c;
		String campaignStrategy = clubEvent.Campaign_Strategy_Global__c;
		String localCampaign = clubEvent.Local_Campaign_Global__c;
		if( ! String.isEmpty(nationalCampaign)) {
			whereClause += 'and National_Campaign_Global__c = :nationalCampaign ';
		}
		if( ! String.isEmpty(campaignStrategy)) {
			whereClause += 'and Campaign_Strategy_Global__c = :campaignStrategy ';
		}
		if( ! String.isEmpty(localCampaign)) {
			whereClause += 'and Local_Campaign_Global__c = :localCampaign ';
		}

		String queryString = 'select ';
		
		if(perm.entityType == 'Chapter' && (reportOption == 'CHAPONLY' || reportOption == 'CHAPINCLUDE')) {
			queryString += 
				commonFields + 
				'from Club_Event__c where ' + 
				whereClause + 
				'group by Event_Category__c, Event_Type__c';
			chapterName = getEntityName();
		}
		else {
			queryString +=
				'Club_Entity__r.EntityId__c entityId, ' +
				'Club_Entity__r.Name entityName, ' +
				commonFields +
				'from Club_Event__c where ' + 
				whereClause + 
				'group by Club_Entity__r.EntityId__c, Club_Entity__r.Name, Event_Category__c, Event_Type__c ' +
				'order by Club_Entity__r.EntityId__c, Club_Entity__r.Name, Event_Category__c, Event_Type__c'; 
		}
		
		System.debug('queryString:' + queryString);
		AggregateResult[] eventSummary = Database.query(queryString);		
		
		if( ! eventSummary.isEmpty()) {
			//Initialize variables and populate with first entity and category
			events = new List<EventData>();
			Integer entityCount = 0;
			Integer categoryCount = 0;
			Decimal categoryCancelledCount = 0;
			Decimal categoryAttendedCount = 0;
			Decimal categoryNoShowCount = 0;
			Decimal categoryRegisteredCount = 0;
			Decimal entityCancelledCount = 0;
			Decimal entityAttendedCount = 0;
			Decimal entityNoShowCount = 0;
			Decimal entityRegisteredCount = 0;
			DateTime dtEntityEarliest = null;
			DateTime dtEntityLatest = null;
			DateTime dtCategoryEarliest = null;
			DateTime dtCategoryLatest = null;

			//Grand totals used for report option CHAPSEPARATE
			Integer gtEventCount = 0;
			DateTime gtDtEarliest = null;
			DateTime gtDtLatest = null;
			Decimal gtRegisteredCount = 0;
			Decimal gtCancelledCount = 0;
			Decimal gtAttendedCount = 0;
			Decimal gtNoShowCount = 0;

			String lastEntityName;
			if(reportOption == 'CHAPONLY' || reportOption == 'CHAPINCLUDE') {
				lastEntityName = chapterName;
			}
			else {
				lastEntityName = (String)eventSummary.get(0).get('entityId') + '-' + (String)eventSummary.get(0).get('entityName');
			}
			String lastCategory = (String)eventSummary.get(0).get('eventCategory');
			String lastType = (String)eventSummary.get(0).get('eventType');
				
			//Process all rows
			for(AggregateResult ev : eventSummary) {
				String entityName;
				if(reportOption == 'CHAPONLY' || reportOption == 'CHAPINCLUDE') {
					entityName = chapterName;
				}
				else {
					entityName = (String)ev.get('entityId') + '-' + (String)ev.get('entityName');
				}
				String eventCategory = (String)ev.get('eventCategory');
				String eventType = (String)ev.get('eventType');
				Integer eventCount = (Integer)ev.get('eventCount');
				DateTime dtEarliest = (DateTime)ev.get('dtEarliest');
				DateTime dtLatest = (DateTime)ev.get('dtLatest');
				Decimal registeredCount = (Decimal)ev.get('registeredCount');
				if(registeredCount == null) {
					registeredCount = 0;
				}
				Decimal attendedCount = (Decimal)ev.get('attendedCount');
				if(attendedCount == null) {
					attendedCount = 0;
				}
				Decimal cancelledCount = (Decimal)ev.get('cancelledCount');
				if(cancelledCount == null) {
					cancelledCount = 0;
				}
				Decimal noShowCount = (Decimal)ev.get('noShowCount');
				if(noShowCount == null) {
					noShowCount = 0;
				}

				EventData evData = new EventData();
				if(entityName != lastEntityName) {//Entity control break
					//Add Category total line
					evData.isCategoryTotal = true;
					evData.eventCount = categoryCount;
					evData.eventCategory = lastCategory;
					evData.dtEarliest = dtCategoryEarliest;
					evData.dtLatest = dtCategoryLatest;
					evData.registered = categoryRegisteredCount - categoryAttendedCount - categoryNoShowCount;
					evData.attended = categoryAttendedCount;
					evData.noShow = categoryNoShowCount;
					evData.cancelled = categoryCancelledCount;
					events.add(evData);
					//Reset Category totals
					categoryCount = 0;
					categoryRegisteredCount = 0;
					categoryAttendedCount = 0;
					categoryNoShowCount = 0;
					lastCategory = eventCategory;
					dtCategoryEarliest = null;
					dtCategoryLatest = null;
						
					//Add Entity total line			
					evData = new EventData();
					evData.isEntityTotal = true;
					evData.eventCount = entityCount;
					evData.entityName = lastEntityName;
					evData.dtEarliest = dtEntityEarliest;
					evData.dtLatest = dtEntityLatest;
					evData.attended = entityAttendedCount;
					evData.registered = entityRegisteredCount - entityAttendedCount - entityNoShowCount;
					evData.cancelled = entityCancelledCount;
					evData.noShow = entityNoShowCount;
					events.add(evData);
					//Reset Entity totals
					entityCount = 0;
					entityAttendedCount = 0;
					entityRegisteredCount = 0;
					entityCancelledCount = 0;
					entityNoShowCount = 0;
					lastEntityName = entityName;
					dtEntityEarliest = null;
					dtEntityLatest = null;
					
					//Add blank line
					evData = new EventData();
					events.add(evData);
					evData = new EventData();
				}
				else if(eventCategory != lastCategory) {//Category control break
					//Add Category total line
					evData.isCategoryTotal = true;
					evData.eventCount = categoryCount;
					evData.registered = categoryRegisteredCount - categoryAttendedCount - categoryNoShowCount;
					evData.attended = categoryAttendedCount;
					evData.cancelled = categoryCancelledCount;
					evData.noShow = categoryNoShowCount;
					evData.eventCategory = lastCategory;
					evData.dtEarliest = dtCategoryEarliest;
					evData.dtLatest = dtCategoryLatest;
					events.add(evData);
					//Reset Category totals
					categoryCount = 0;
					categoryAttendedCount = 0;
					categoryCancelledCount = 0;
					categoryNoShowCount = 0;
					categoryRegisteredCount = 0;
					lastCategory = eventCategory;
					dtCategoryEarliest = null;
					dtCategoryLatest = null;
					
					//Add blank line
					evData = new EventData();
					events.add(evData);
					evData = new EventData();
				}
					
				//Create detail line
				evData.entityName = entityName;
				evData.eventCategory = eventCategory;
				evData.eventType = eventType;
				evData.eventCount = eventCount;
				evData.registered = registeredCount - attendedCount - noShowCount;
				evData.attended = attendedCount;
				evData.cancelled = cancelledCount;
				evData.noShow = noShowCount;
				evData.dtEarliest = dtEarliest;
				evData.dtLatest = dtLatest;
				
				//If first row for Entity, show Entity Name
				if(entityCount == 0) {
					evData.printEntityName = true;
				}
				else {
					evData.printEntityName = false;
				}
				//If first row for Category, show Category
				if(categoryCount == 0) {
					evData.printCategory = true;
				}
				else {
					evData.printCategory = false;
				}
				//Add detail line
				events.add(evData);
					
				//Add to summary totals
				entityCount += eventCount;
				categoryCount += eventCount;

				categoryCancelledCount += cancelledCount;
				categoryAttendedCount += attendedCount;
				categoryNoShowCount += noShowCount;
				categoryRegisteredCount += registeredCount;

				entityCancelledCount += cancelledCount;
				entityAttendedCount += attendedCount;
				entityNoShowCount += noShowCount;
				entityRegisteredCount += registeredCount;

				gtEventCount += eventCount;
				gtRegisteredCount += registeredCount;
				gtAttendedCount += attendedCount;
				gtCancelledCount += cancelledCount;
				gtNoShowCount += noShowCount;

				if(dtCategoryEarliest == null || dtEarliest < dtCategoryEarliest) {
					dtCategoryEarliest = dtEarliest;
				}
				if(dtEntityEarliest == null || dtEarliest < dtEntityEarliest) {
					dtEntityEarliest = dtEarliest;
				}
				if(dtCategoryLatest == null || dtLatest > dtCategoryLatest) {
					dtCategoryLatest = dtLatest;
				}
				if(dtEntityLatest == null || dtLatest > dtEntityLatest) {
					dtEntityLatest = dtLatest;
				}
				if(gtDtEarliest == null || dtEarliest < gtDtEarliest) {
					gtDtEarliest = dtEarliest;
				}
				if(gtDtLatest == null || gtDtLatest > gtDtLatest) {
					gtDtLatest = dtLatest;
				}
			}
			//Final Category summary
			EventData evData = new EventData();
			evData.isCategoryTotal = true;
			evData.eventCategory = lastCategory;
			evData.eventCount = categoryCount;
			evData.dtEarliest = dtCategoryEarliest;
			evData.dtLatest = dtCategoryLatest;

			evData.registered = categoryRegisteredCount - categoryAttendedCount - categoryNoShowCount;
			evData.attended = categoryAttendedCount;
			evData.noShow = categoryNoShowCount;
			evData.cancelled = categoryCancelledCount;

			events.add(evData);
				
			//Final Entity summary					
			evData = new EventData();
			evData.isEntityTotal = true;
			evData.entityName = lastEntityName;
			evData.eventCount = entityCount;
			evData.dtEarliest = dtEntityEarliest;
			evData.dtLatest = dtEntityLatest;

			evData.attended = entityAttendedCount;
			evData.registered = entityRegisteredCount - entityAttendedCount - entityNoShowCount;
			evData.cancelled = entityCancelledCount;
			evData.noShow = entityNoShowCount;

			events.add(evData);
				
			if(reportOption == 'CHAPSEPARATE') {
				//Grand totals					
				evData = new EventData();
				evData.isGrandTotal = true;
				evData.eventCount = gtEventCount;
				evData.dtEarliest = gtDtEarliest;
				evData.dtLatest = gtDtLatest;

				evData.attended = gtAttendedCount;
				evData.registered = gtRegisteredCount - gtAttendedCount - gtNoShowCount;
				evData.cancelled = gtCancelledCount;
				evData.noShow = gtNoShowCount;
				
				events.add(evData);
			}
		}
		addlCriteria = null;
		return events;
	}
	
    private Map<Id, EntityPermissions.EntityPermission> getEntityPermissions() {
        if(EntityPermissionsMap == null) {
            Id userId = UserInfo.getUserId();
            Id contactId;
            if(Test.isRunningTest()) {
            	contactId = EventSummaryControllerTest.contactId;
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
    public String getReportTitle() {
    	String title = 'Event Summary for ' + getEntityName();
		EntityPermissions.EntityPermission perm = getEntityPermissions().get(clubEntity);
		if(perm.entityType == 'Chapter') {
			if(reportOption == 'CHAPONLY') {
				title += ' (Chapter Activities Only)';
			}
			else if(reportOption == 'CHAPINCLUDE') {
				title += ' Including Groups and Activity Sections';
			}
		}
		
		return title;
    }
    public String getAddlCriteria() {
    	if(addlCriteria == null) {
			List<String> criteriaList = new List<String>();
			if( ! String.isEmpty(clubEvent.National_Campaign_Global__c)) {
				criteriaList.add('National Campaign: ' + clubEvent.National_Campaign_Global__c);
			}
			if( ! String.isEmpty(clubEvent.Campaign_Strategy_Global__c)) {
				criteriaList.add('Campaign Strategy: ' + clubEvent.Campaign_Strategy_Global__c);
			}
			if( ! String.isEmpty(clubEvent.Local_Campaign_Global__c)) {
				criteriaList.add('Campaign Strategy: ' + clubEvent.Local_Campaign_Global__c);
			}
			String criteriaString = '';
			for(String str : criteriaList) {
				if(criteriaString.length() > 0) {
					criteriaString += ', ';
				}
				criteriaString += str;
			}
			if(criteriaString.length() > 0) {
				addlCriteria = criteriaString;
			}
    	}
    	return addlCriteria;
    }
    public Boolean getHasAddlCriteria() {
    	return ! String.isEmpty(getAddlCriteria());		
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
    	return Page.EventSummaryReport;
    }
    public PageReference cancel() {
    	return Page.ClubEventAdministration;
    }

	public Class EventData {
		public String entityName {get; set;}
		public String eventCategory {get; set;}
		public String eventType {get; set;}
		public Integer eventCount {get; set;}
		public DateTime dtEarliest {get; set;}
		public DateTime dtLatest {get; set;}
		public Decimal registered {get; set;}
		public Decimal cancelled {get; set;}
		public Decimal attended {get; set;}
		public Decimal noShow {get; set;}
		public Boolean isEntityTotal {get; set;} {isEntityTotal = false;}
		public Boolean isCategoryTotal {get; set;} {isCategoryTotal = false;}
		public Boolean isGrandTotal {get; set;} {isGrandTotal = false;}
		public Boolean printEntityName {get; set;} {printEntityName = false;}
		public Boolean printCategory {get; set;} {printCategory = false;}
		public Boolean getIsTotal() {
			return isEntityTotal || isCategoryTotal || isGrandTotal;
		}
	}
}