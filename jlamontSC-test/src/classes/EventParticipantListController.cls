public with sharing class EventParticipantListController {
	private Club_Event__c event;
	private List<Event_Registration__c> participantList;
	
	public Club_Event__c getEvent() {
		if(event == null) {
			Id id = ApexPages.currentPage().getParameters().get('id');
			List<Club_Event__c> eventList = [
				select 
					Id,
					Date_Begin__c,
					Event_Title__c,
					Club_Entity__r.Name,
					Can_Take_Attendance__c
				from Club_Event__c
				where Id = :id
			];
			if( ! eventList.isEmpty()) {
				event = eventList.get(0);
			}
		}
		return event;
	}
	public List<Event_Registration__c> getParticipantList() {
		if(participantList == null) {
			Club_Event__c clubEvent = getEvent();
			Id eventId = clubEvent.Id;
			participantList = [
				select
					Id,
					First_Name__c,
					Last_Name__c,
					Phone__c,
					Email__c,
					CreatedDate
				from Event_Registration__c
				where Club_Event__c = :eventId
				and Status__c != 'Cancelled'
				order by Last_Name__c, First_Name__c 
			];
		}
		return participantList;		
	}
	public String getPageBase() {
		return CampfireUtils.getPageBase();
	}
	public PageReference takeAttendance() {
		PageReference pageRef = Page.EventAttendance;
		pageRef.getParameters().put('id',getEvent().Id);
		pageRef.setRedirect(true);
		return pageRef;
	}
}