public without sharing class ClubEventListController {
    public String earliestDateString {get; set;}
    public String latestDateString {get; set;}
    public String earliestChangeDateString {get; set;}
    public String latestChangeDateString {get; set;}
    public String leaderName {get; set;}
    public String eventTitlePattern {get; set;}
    public String eventTitle {get; set;}
    public String eventStatus {get; set;}
    public String eventSponsor {get; set;}
    public String eventCategory {get; set;}
    public Date earliestDate, latestDate, earliestChangeDate, latestChangeDate;
    private Map<Id, EntityPermissions.EntityPermission> entityPermissionsMap;
    public Integer activityListSize {get; set;}
    public transient List<Club_Event__c> activityList;
    public transient Set<Id> entityPermissionsSet;
    private transient Set<Id> selectedActivityIds;
    public List<SelectOption> sponsorOptions;
    public List<SelectOption> categoryOptions;
    private Id contactId;
    
    public ClubEventListController() {
        earliestDateString = System.Date.today().addMonths(-1).format();
        earliestDate = Date.parse(earliestDateString);
        getActivityList();
    }
    public List<Club_Event__c> getActivityList() {
        if(activityList == null) {
        	Set<Id> eventIdSet = new Set<Id>();
            List<Club_Event__c> activities = Database.query(getSoql());
            
            for(Club_Event__c ev : activities) {
            	eventIdSet.add(ev.Id);
            }
            
            Set<Id>eventLeaderSet = new Set<Id>();
            List<Event_Leader__c> eventLeaderList = [
            	select Club_Event__c from Event_Leader__c 
            	where 
            		Club_Event__c in :eventIdSet
            		and Contact__c = :contactId
            ];
            for(Event_Leader__c ldr : eventLeaderList) {
            	eventLeaderSet.add(ldr.Club_Event__c);
            }
            
            activityList = new List<Club_Event__c>();
            Set<Id> filteredIdSet = new Set<Id>();
            for(Club_Event__c ev : activities) {
                EntityPermissions.EntityPermission perm = entityPermissionsMap.get(ev.Club_Entity__c);
                boolean includeActivity = false;
                if(perm != null) {
                    if(ev.Event_Category__c == 'Outing') {
                        if(perm.clubEventPermissionOutings == 'Administrator') {
                            includeActivity = true;
                        }
                        else {
                            if(ev.OwnerId == UserInfo.getUserId()) {
                                includeActivity = true;
                            }
                            else if(eventLeaderSet.contains(ev.Id)) {
                            	includeActivity = true;
                            }
                        } 
                    }
                    else {
                        if(perm.clubEventPermissionNonOutings == 'Administrator') {
                            includeActivity = true;
                        }
                        else {
                            if(ev.OwnerId == userInfo.getUserId()) {
                                includeActivity = true;
                            }
                            else if(eventLeaderSet.contains(ev.Id)) {
                            	includeActivity = true;
                            }
                        }
                    }
                    if(includeActivity) {
                        activityList.add(ev);
                        filteredIdSet.add(ev.Id);
                    }
                }
            }
            //If Leader Name filter was entered, check names of all leaders
            if(activityList.size() > 0 && ( ! String.isEmpty(leaderName)) ) {
                String leaderNamePattern = '%' + leaderName.toLowerCase() + '%';
                List<Event_Leader__c> ldrList = new List<Event_Leader__c>([
                    select Club_Event__c from Event_Leader__c
                    where 
                        Club_Event__c in :filteredIdSet
                        and Leader_Name__c like :leaderNamePattern
                ]);
                Set<Id> ldrIdSet = new Set<Id>();
                for(Event_Leader__c ldr : ldrList) {
                    ldrIdSet.add(ldr.Club_Event__c);
                }
                //Now filter list of activities by leader name
                List<Club_Event__c> filteredList = new List<Club_Event__c>();
                for(Club_Event__c evnt : activities) {
                    if(ldrIdSet.contains(evnt.Id)) {
                        filteredList.add(evnt);
                    }
                }
                activityList = filteredList;
            }
            activityListSize = activityList.size();
        }
        return activityList;
    }
    private Set<Id> getSelectedActivityIds() {
    	if(selectedActivityIds == null) {
    		selectedActivityIds = new Set<Id>();
    		for(Club_Event__c ev : getActivityList()) {
    			selectedActivityIds.add(ev.Id);
    		}
    	}
    	return selectedActivityIds;
    }
    private String getSoql() {
        entityPermissionsSet = getEntityPermissions().keySet();
        String soql = 
            'SELECT Id, Event_Title__c, Club_Entity__r.Name, Event_Category__c, CreatedById, Status__c, Date_Begin__c, Date_End__c, LastModifiedDate, ' +
            'Club_Entity__r.EntityId__c, Unpublished_Notes__c, Event_Type__c, Sponsor_Description__c, Signup_Restrictions__c, ' +
            'Signup_Instructions__c, Short_Description__c, Location_Description__c, Level__c, Event_Location__c, Entity_Specific_Level__c, ' +
            'Cost_Description__c, Carpool__c, Cancellation_Option__c, Cancellation_Policy_Description__c, Bring__c, Additional_Directions__c, ' +
            'Deletion_Allowed__c, Time_Begin__c, Time_End__c, Date_Tentative__c, Time_Tentative__c, OwnerId ' +
            'FROM Club_Event__c ' +
            'where Club_Entity__c in :entityPermissionsSet ';
        
        List<String> filterList = new List<String>();
        if(earliestDate != null) {
            String criteria = 'and Date_Begin__c >= :earliestDate ';
            filterList.add(criteria);
        }
        if(latestDate != null) {
            String criteria = 'and Date_Begin__c <= :latestDate ';
            filterList.add(criteria);
        }
        if(earliestChangeDate != null) {
            String criteria = 'and LastModifiedDate >= :earliestChangeDate ';
            filterList.add(criteria);
        }
        if(latestChangeDate != null) {
            String criteria = 'and LastModifiedDate <= :latestChangeDate ';
            filterList.add(criteria);
        }
        if( ! String.isEmpty(eventStatus)) {
            String criteria = 'and Status__c = :eventStatus ';
            filterList.add(criteria);
        }
        if( ! String.isEmpty(eventTitle)) {
            eventTitlePattern = '%' + eventTitle + '%';
            String criteria = 'and Event_Title__c like :eventTitlePattern ';
            filterList.add(criteria);
        }
        if( ! String.isEmpty(eventSponsor)) {
            String criteria = 'and Club_Entity__c = :eventSponsor ';
            filterList.add(criteria);
        }
        if( ! String.isEmpty(eventCategory)) {
            String criteria = 'and Event_Category__c = :eventCategory ';
            filterList.add(criteria);
        }
        
        for(String str : filterList) {
            soql += str;
        }
        soql += 'ORDER BY Date_Begin__c DESC';
        return soql;
    }
    
    private void parseDates() {
        if(String.isEmpty(earliestDateString)) {
            earliestDate = null;
        }
        else {
            earliestDate = Date.parse(earliestDateString);
        }
        if(String.isEmpty(latestDateString)) {
            latestDate = null;
        }
        else {
            latestDate = Date.parse(latestDateString);
        }
        if(String.isEmpty(earliestChangeDateString)) {
            earliestChangeDate = null;
        }
        else {
            earliestChangeDate = Date.parse(earliestChangeDateString);
        }
        if(String.isEmpty(latestChangeDateString)) {
            latestChangeDate = null;
        }
        else {
            latestChangeDate = Date.parse(latestChangeDateString);
        }
    }
    public PageReference filterEvents() {
        try {
            parseDates();
            getActivityList();
        }
        catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        return null;
    }
    public PageReference resetFilter() {
        latestDate = null;
        earliestChangeDate = null;
        latestChangeDate = null;  
        latestDateString = '';
        earliestChangeDateString = '';
        latestChangeDateString = '';
        leaderName = '';
        eventTitle = '';
        eventStatus = '';
        eventSponsor = '';
        eventCategory = '';
        earliestDateString = System.Date.today().addMonths(-1).format();
        earliestDate = Date.parse(earliestDateString);
        getActivityList();
        return null;
    }
    public String getBaseUrl() {
        return URL.getSalesforceBaseUrl().toExternalForm();
    }
    public PageReference newActivity() {
        return page.ClubEventEntry;
    }
    public PageReference administration() {
    	return page.ClubEventAdministration;
    }
    public PageReference deleteActivity() {
        Id id = System.currentPageReference().getParameters().get('id');
        List<Event_Registration__c> regList = [
        	select Id from Event_Registration__c where Club_Event__c = :id
        	limit 1
        ];
        if(regList.size() > 0) {
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The event you selected to delete has registrations, so cannot be deleted'));
        	return null;
        }
        Club_Event__c activityToDelete = new Club_Event__c(Id = id);
        delete activityToDelete;
        activityList = null;
        return null;
    }
    public List<SelectOption> getStatusOptions() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Club_Event__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : ple) {
            options.add(new SelectOption(entry.getLabel(), entry.getValue()));
        }
        options.add(0, new SelectOption('','Any'));
        return options; 
    }
    public List<SelectOption> getSponsorOptions() {
        if(sponsorOptions == null) {
            sponsorOptions = new List<SelectOption>();
            for(EntityPermissions.EntityPermission perm : getEntityPermissions().values()) {
                sponsorOptions.add(new SelectOption(perm.clubEntityId, perm.name));
            }
            sponsorOptions = QuickSort.sortOptionList(sponsorOptions);
            sponsorOptions.add(0, new SelectOption('', 'Any'));
        }
        return sponsorOptions;
    }
    public List<SelectOption> getCategoryOptions() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Club_Event__c.Event_Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : ple) {
            options.add(new SelectOption(entry.getLabel(), entry.getValue()));
        }
        options.add(0, new SelectOption('','Any'));
        return options; 
    }
    public String getListTitle() {
        if(activityListSize == 0) {
            return '';
        } 
        return activityListSize + ' Club Event' + ((activityListSize > 1) ? 's' : '') + ' Listed';
    }
    public PageReference createCSV() {
        return page.ExportCSV;
    }
    public PageReference createPrintView() {
    	return page.ClubEventPrintView;
    }
    public PageReference createRegistrationList() {
    	return page.ClubEventRegistrationList;
    }
    public PageReference createRegistrationSummary() {
    	return page.ClubEventRegistrationSummary;
    }
    private Map<Id, EntityPermissions.EntityPermission> getEntityPermissions() {
        if(EntityPermissionsMap == null) {
            Id userId = UserInfo.getUserId();
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
    public List<Event_Registration__c> getRegistrationList() {
    	List<Event_Registration__c> regList = [
    		select
    			Club_Event__r.Date_Begin__c,
    			Club_Event__r.Event_Title__c,
    			First_Name__c,
    			Last_Name__c,
    			Street__c,
    			City__c,
    			State__c,
    			PostalCode__c,
    			Email__c,
    			Phone__c
    		from Event_Registration__c
    		where Club_Event__c = :getSelectedActivityIds()
    		order by Club_Event__r.Date_Begin__c, Club_Event__r.Event_Title__c, Last_Name__c, First_Name__c
    	];
    	return regList;
    }
    public List<RegistrantExportRow> getRegistrantExportList() {
    	List<RegistrantExportRow> rowList = new List<RegistrantExportRow>();
    	for(Event_Registration__c reg : getRegistrationList()) {
    		RegistrantExportRow row = new RegistrantExportRow();
    		row.dtBegin = reg.Club_Event__r.Date_Begin__c;
    		row.eventTitle = reg.Club_Event__r.Event_Title__c;
    		row.firstName = reg.First_Name__c;
    		row.lastName = reg.Last_Name__c;
    		row.street = reg.Street__c;
    		row.city = reg.City__c;
    		row.state = reg.State__c;
    		row.postalCode = reg.PostalCode__c;
    		row.email = reg.Email__c;
    		row.phone = reg.Phone__c;
    		rowList.add(row);
    	}
    	return rowList;
    }
    public List<RegistrationSummaryRow> getRegistrationSummaryList() {
    	AggregateResult[] groupedResults = [
    		select 
    			Club_Event__c, 
    			Club_Event__r.Event_Title__c title,
    			Club_Event__r.Date_Begin__c dtBegin,
    			Club_Event__r.Status__c status, 
    			sum(RegisteredCount__c) registered, 
    			sum(AttendedCount__c) attended, 
    			sum(CancelledCount__c) cancelled
			from Event_Registration__c
    		where Club_Event__c = :getSelectedActivityIds()
			group by Club_Event__c, Club_Event__r.Event_Title__c, Club_Event__r.Date_Begin__c, Club_Event__r.Status__c
    	];
		Map<Id, RegistrationSummaryRow> eventRegMap = new Map<Id, RegistrationSummaryRow>();
    	for(AggregateResult ar : groupedResults) {
    		RegistrationSummaryRow row = new RegistrationSummaryRow();
    		row.dtBegin = (Date)ar.get('dtBegin');
    		row.eventTitle = (String)ar.get('title');
    		row.eventStatus = (String)ar.get('status');
    		row.registered = ((Decimal)ar.get('registered')).intValue();
    		row.attended = ((Decimal)ar.get('attended')).intValue();
    		row.cancelled = ((Decimal)ar.get('cancelled')).intValue();
    		eventRegMap.put((Id)ar.get('Club_Event__c'), row);
    	}
    	List<Event_Leader__c> ldrList = [
    		select Club_Event__c, Leader_Name__c
    		from Event_Leader__c
    		where
    			Is_Primary_Leader__c = true 
    			and Club_Event__c in :eventRegMap.keySet()
    	];
    	for(Event_Leader__c ldr : ldrList) {
    		RegistrationSummaryRow row = eventRegMap.get(ldr.Club_Event__c);
    		if(row != null) {
    			row.leaderName = ldr.Leader_Name__c;
    		}
    	}
    	return eventRegMap.values();
    }
    
    public List<ExportRow> getExportList() {
        //Create and populate eventToLeaderMap to correlate Event with set of Leaders
        Set<Id>idSet = new Set<Id>();
        List<Club_Event__c> eventList = getActivityList();
        for(Club_Event__c evnt : eventList) {
            idSet.add(evnt.Id);
        }
        List<Event_Leader__c> ldrList = new List<Event_Leader__c>([
            select Club_Event__c, Leader_Name__c, Email__c, Phone_or_Other_Contact_Information__c, Is_Primary_Leader__c From Event_Leader__c 
            where Club_Event__c in :idSet
            order by Club_Event__c, Is_Primary_Leader__c desc, Leader_Name__c
        ]);
        Map<Id, Set<Event_Leader__c>> eventToLeaderMap = new Map<Id, Set<Event_Leader__c>>();
        Id lastEventId;
        Set<Event_Leader__c> ldrSet = new Set<Event_Leader__c>();
        if(ldrList.size() > 0) {
            lastEventId = ldrList.get(0).Club_Event__c;
        }
        for(Event_Leader__c ldr : ldrList) {
            if(ldr.Club_Event__c != lastEventId) {
                eventToLeaderMap.put(lastEventId, ldrSet);
                ldrSet = new Set<Event_Leader__c>();
                lastEventId = ldr.Club_Event__c;
            }
            ldrSet.add(ldr);
        }
        eventToLeaderMap.put(lastEventId, ldrSet);
        
        List<ExportRow> retList = new List<ExportRow>();
        for(Club_Event__c ev : getActivityList()) {
            ExportRow row = new ExportRow();
            row.title = ev.Event_Title__c;
            row.dtBegin = ev.Date_Begin__c;
            row.dtEnd = ev.Date_End__c;
            row.timeBegin = ev.Time_Begin__c;
            row.timeEnd = ev.Time_End__c;
            row.EntityId = ev.Club_Entity__r.EntityId__c;
            row.EntityName = ev.Club_Entity__r.Name;
            row.leaderSet = eventToLeaderMap.get(ev.Id);
            row.SponsorDescription = ev.Sponsor_Description__c;
            row.Location = ev.Location_Description__c;
            row.Status = ev.Status__c;
            row.Category = ev.Event_Category__c;
            row.Type = ev.Event_Type__c;
            row.Level = ev.Level__c;
            row.EntityLevel = ev.Entity_Specific_Level__c;
            row.Description = ev.Short_Description__c;
            row.Cost = ev.Cost_Description__c;
            row.SignupRestrictions = ev.Signup_Restrictions__c;
            row.SignupInstructions = ev.Signup_Instructions__c;
            row.Bring = ev.Bring__c;
            row.AdditionalDirections = ev.Additional_Directions__c;
            row.CancellationPolicy = ev.Cancellation_Policy_Description__c;
            row.CancellationOption = ev.Cancellation_Option__c;
            row.Carpool = ev.Carpool__c;
            row.UnpublishedNotes = ev.Unpublished_Notes__c;
            row.ShortDescription = ev.Short_Description__c;
            row.TimeBegin = ev.Time_Begin__c;
            row.TimeEnd = ev.Time_End__c;
            row.dateTentative = ev.Date_Tentative__c;
            row.timeTentative = ev.Time_Tentative__c;
            retList.add(row);
        }
        retList.sort();
        return retList;
    }
    public class ExportRow implements Comparable {
        public String Title {get; set;}
        public Date dtBegin {get; set;}
        public Date dtEnd {get; set;}
        public String timeBegin {get; set;}
        public String timeEnd {get; set;}
        public String EntityId {get; set;}
        public String EntityName {get; set;}
        public String SponsorDescription {get; set;}
        public String Location {get; set;}
        public String Status {get; set;}
        public String Category {get; set;}
        public String Type {get; set;}
        public String Level {get; set;}
        public String EntityLevel {get; set;}
        public String Description {get; set;}
        public String Cost {get; set;}
        public String SignupRestrictions {get; set;}
        public String SignupInstructions {get; set;}
        public String Bring {get; set;}
        public String AdditionalDirections {get; set;}
        public String CancellationPolicy {get; set;}
        public String CancellationOption {get; set;}
        public String Carpool {get; set;}
        public String UnpublishedNotes {get; set;}
        public String ShortDescription {get; set;}
        public Boolean dateTentative {get; set;}
        public Boolean timeTentative {get; set;}
        public Set<Event_Leader__c> leaderSet {get; set;}

        private String timeZone = System.UserInfo.getTimeZone().getID();
        private Time zTime = Time.newInstance(0,0,0,0);
        
        public String getBeginDateForm1() {
        	return DateTime.newInstance(dtBegin, zTime).format('yyyyMMdd', timeZone) + ' ' + timeBegin;
        }
        public String getBeginDateDisplay() {
        	return DateTime.newInstance(dtBegin, zTime).format('EEEE, MMMM d, yyyy', timeZone);
        }
        public String getBeginTime() {
            return timeBegin;
        }
        public String getBeginDateForm2() {
        	return DateTime.newInstance(dtBegin, zTime).format('MM/dd/yyyy', timeZone);
        }
        public String getEndDateForm1() {
            if(dtEnd == null) {
                return '';
            }
        	return DateTime.newInstance(dtEnd, zTime).format('yyyyMMdd', timeZone) + ' ' + timeEnd;
        }
        public String getEndDateDisplay() {
            if(dtEnd == null) {
                return '';
            }
        	return DateTime.newInstance(dtEnd, zTime).format('EEEE, MMMM d, yyyy', timeZone);
        }
        public String getEndTime() {
            if(timeEnd == null) {
                return '';
            }
            return timeEnd; 
        }
        public String getEndDateForm2() {
            if(dtEnd == null) {
                return '';
            }
        	return DateTime.newInstance(dtEnd, zTime).format('MM/dd/yyyy', timeZone);
        }
        public String getDisplayDate() {
        	String displayDate = DateTime.newInstance(dtBegin, zTime).format('EEEE, MMMM d, yyyy');
        	displayDate += ', ' + timeBegin;
        	if(dtEnd != null) {
        		displayDate += ' to ';
        		if(dtBegin == dtEnd) {
        			displayDate += timeEnd; 
        		}
        		else {
        			displayDate += DateTime.newInstance(dtBegin, zTime).format('EEEE, MMMM d, yyyy');
        			displayDate += ', ' + timeEnd; 
        		}
        	}
        	if(dateTentative) {
        		displayDate += ' (Date Tentative)';
        	}
        	if(timeTentative) {
        		displayDate += ' (Time Tentative)';
        	}
        	return displayDate;
        }
        public String getPrimaryLeader() {
            if(leaderSet == null) {
                return '';
            }
            String primaryLeader = '';
            for(Event_Leader__c ldr : leaderSet) {
                if(ldr.Is_Primary_Leader__c) {
                    primaryLeader = ldr.Leader_Name__c + ' ' + (ldr.Phone_or_Other_Contact_Information__c == null ? '' : ldr.Phone_or_Other_Contact_Information__c) + ' ' + ldr.Email__c;
                    break; 
                }
            }
            return primaryLeader;
        }
        public List<String> getAllLeadersPrintView() {
            List<String> ldrList = new List<String>();
            if(leaderSet == null) {
                return ldrList;
            }
            ldrList.add(getPrimaryLeader());
            for(Event_Leader__c ldr : leaderSet) {
                if( ! ldr.Is_Primary_Leader__c ) {
                    String ldrString = ldr.Leader_Name__c + ' ' + (ldr.Phone_or_Other_Contact_Information__c == null ? '' : ldr.Phone_or_Other_Contact_Information__c) + ' ' + ldr.Email__c;
                    ldrList.add(ldrString);
                }
            }
            return ldrList;
        }
        public String getAllLeaders() {
            if(leaderSet == null) {
                return '';
            }
            String allLeaders = getPrimaryLeader();
            for(Event_Leader__c ldr : leaderSet) {
                if( ! ldr.Is_Primary_Leader__c ) {
                    if(allLeaders.length() > 0) {
                        allLeaders += ', ';
                    }
                    allLeaders += ldr.Leader_Name__c + ' ' + (ldr.Phone_or_Other_Contact_Information__c == null ? '' : ldr.Phone_or_Other_Contact_Information__c) + ' ' + ldr.Email__c;
                }
            }
            return allLeaders;
        }
        public String getCancellation() {
            if(CancellationOption == 'Other') {
                return CancellationPolicy;
            }
            return CancellationOption;
        }
        public Integer compareTo(Object compareTo) {
        	ExportRow row = (ExportRow)compareTo;
        	if(dtBegin == row.dtBegin) return 0;
        	if(dtBegin > row.dtBegin) return 1;
        	return -1;
        }
    }
    public PageReference eventLeadership() {
    	return Page.LeaderEvents;
    }
    public class RegistrantExportRow {
        private String timeZone = System.UserInfo.getTimeZone().getID();
        private Time zTime = Time.newInstance(0,0,0,0);
    	public Date dtBegin {get; set;}
    	public String eventTitle {get; set;}
    	public String firstName {get; set;}
    	public String lastName {get; set;}
    	public String street {get; set;}
    	public String city {get; set;}
    	public String state {get; set;}
    	public String postalCode {get; set;}
    	public String email {get; set;}
    	public String phone {get; set;}
  
        public String getBeginDate() {
        	return DateTime.newInstance(dtBegin, zTime).format('MM/dd/yyyy', timeZone);
        }
    }
    public class RegistrationSummaryRow {
        private String timeZone = System.UserInfo.getTimeZone().getID();
        private Time zTime = Time.newInstance(0,0,0,0);
    	public Date dtBegin {get; set;}
    	public String eventTitle {get; set;}
    	public String eventStatus {get; set;}
    	public String leaderName {get; set;}
    	public Integer registered {get; set;}
    	public Integer attended {get; set;}
    	public Integer cancelled {get; set;}

        public String getBeginDate() {
        	return DateTime.newInstance(dtBegin, zTime).format('MM/dd/yyyy', timeZone);
        }
    }
}