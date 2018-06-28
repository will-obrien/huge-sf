public with sharing class LeaderEventsController {
	List<Event_Leader__c> eventList;
	public String selectedEventId {get; set;}
   	public Event_Leader__c selectedEvent;
	public Date dtBegin {get; set;}
	private Integer offset = 0;
	public Boolean moreRows {get; set;}
	public Boolean lessRows {get; set;}
	private static final Integer rowLimit = 10;
	public String rowMessage;
	private Boolean scrollingBackwards = true;
	private Integer totalRows;
	public List<Event_Leader__c> getEventList() {
		if(eventList == null) {
			Id contactId = CampfireUtils.getUserContactId();
			if(dtBegin == null) {
				dtBegin = System.today().addDays(1);
			}
			eventList = [
				select
					Club_Event__r.Id,
					Club_Event__r.Date_Begin__c,
					Club_Event__r.Event_Title__c,
					Club_Event__r.Club_Entity__r.Name,
					Club_Event__r.Can_Take_Attendance__c,
					Club_Event__r.Status__c
				from Event_Leader__c
				where Contact__c = :contactId
				and Club_Event__r.Status__c in ('Active', 'At Capacity')
				and Club_Event__r.Date_Begin__c <= :dtBegin
				order by Club_Event__r.Date_Begin__c desc
				LIMIT :rowLimit OFFSET :offset
			];
			Integer totalCount = getTotalCount(contactId, dtBegin);
			Integer startRow, endRow;

			if(scrollingBackwards) {
				startRow = offset + 1;
				endRow = offset + rowLimit;
				if(endRow >= totalCount) {
					endRow = totalCount;
					moreRows = false;
				}
				else {
					moreRows = true;
				}
				if(startRow == 1) {
					lessRows = false;
				}
				else if(endRow <= totalCount) {
					lessRows = true;
				}
			}
			else {
				startRow = offset;
				endRow = offset + rowLimit;
				if(startRow <= 0) {
					startRow = 1;
					endRow = rowLimit;
					lessRows = false;
				}
				else {
					lessRows = true;
				}
                moreRows = startRow < totalCount - rowLimit;
			}
			if(totalCount == 0) {
				rowMessage = 'No events shown';
			} 
			else {
				rowMessage = 'Events ' + startRow.format() + ' through ' + endRow.format() + ' of ' + totalCount.format() + ' shown';
			}
		}	
		return eventList;
	}
	public String getRowMessage() {
		if(eventList == null) {
			getEventList();
		}
		return rowMessage;
	}
	private Integer getTotalCount(Id contactId, Date dtBegin) {
		if(totalRows == null) {
			AggregateResult[] rslt = [
				SELECT COUNT(Id) cnt
				from Event_Leader__c
				where Contact__c = :contactId
				and Club_Event__c != null
				and Club_Event__r.Status__c in ('Active', 'At Capacity')
				and Club_Event__r.Date_Begin__c <= :dtBegin
			];
			totalRows = (Integer)rslt[0].get('cnt');
		}
		return totalRows;		
	}
	public PageReference refreshList() {
		eventList = null;
		offset = 0;
		return null;
	}
	public PageReference getMore() {
		scrollingBackwards = true;
		offset = offset + rowLimit;
		eventList = null;
		getEventList();
		return null;
	}
	public PageReference getLess() {
		scrollingBackwards = false;
		offset = offSet - rowLimit;
		eventList = null;
		getEventList();
		return null;
	}
    public String getDtString() {
    	if(dtBegin == null) {
    		dtBegin = System.today().addDays(1);
    	}
    	return dtBegin.format();
    }
    public void setDtString(String input) {
        if(String.isEmpty(input)) {
    		dtBegin = System.today().addDays(1);
        }
        else {
        	dtBegin = Date.parse(input);
        }
    }
    public Event_Leader__c getSelectedEvent() {
    	for(Event_Leader__c evnt : eventList) {
    		if(evnt.Club_Event__c == selectedEventId) {
    			selectedEvent = evnt;
    			break;
    		}
    	}
    	return selectedEvent;
    }
    public PageReference attendanceComplete() {
    	List<Event_Registration__c> regList = [
    		select Id
    		from Event_Registration__c
    		where 
    			Club_Event__c = :selectedEventId
    			and Status__c = 'Registered'
    	];
    	List<Event_Registration__c> updtList = new List<Event_Registration__c>();
    	for(Event_Registration__c reg : regList) {
    		updtList.add(new Event_Registration__c(Id = reg.Id, Status__c = 'No Show'));
    	}
    	update updtList;
    	return null;
    }
	public PageReference participantList() {
		PageReference pageRef = new PageReference(CampfireUtils.getPageBase() + 'EventParticipantList');
		pageRef.getParameters().put('id', selectedEventId);
		pageRef.setRedirect(true);
		return pageRef;
	}
	public PageReference takeAttendance() {
		PageReference pageRef = new PageReference(CampfireUtils.getPageBase() + 'EventAttendance');
		pageRef.getParameters().put('id', selectedEventId);
		pageRef.setRedirect(true);
		return pageRef;
	}
	public String getPageBase() {
		return CampfireUtils.getPageBase();
	}
}