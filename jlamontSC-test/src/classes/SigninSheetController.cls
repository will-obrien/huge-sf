public with sharing class SigninSheetController {
	public Id eventId;
    public Club_Event__c clubEvent;
    public List<Event_Registration__c> regList;
    private static final Integer LINES_PER_PAGE = 7;

	public Club_Event__c getClubEvent() {
		if(clubEvent == null) {
			if(eventId == null) {
				eventId = ApexPages.currentPage().getParameters().get('id');
			}
			if(eventId != null) {
				List<Club_Event__c> eventList = [
					select Event_Title__c from Club_Event__c where Id=:eventId
				];
				if( ! eventList.isEmpty() ) {
					clubEvent = eventList.get(0);
				}
			}
		}
		return clubEvent;
	}
	public List<Event_Registration__c> getRegList() {
		if(eventId == null) {
			eventId = ApexPages.currentPage().getParameters().get('id');
		}
		if(regList == null) {
			if(eventId == null) {
				regList = new List<Event_Registration__c>();
			}
			else {
				regList = [
					select
						First_Name__c,
						Last_Name__c,
						Full_Name__c,
						CreatedDate,
						Street__c,
						City__c,
						State__c,
						PostalCode__c,
						Phone__c,
						Email__c,
						Waiver_Submitted__c,
						Waiver_is_Digital__c
					from Event_Registration__c
					where Club_Event__c = :eventId
					order by Last_Name__c, First_Name__c
				];
				if( ! regList.isEmpty() ) {
					Integer blankLines = LINES_PER_PAGE - (Math.mod(regList.size(), LINES_PER_PAGE));
					if(blankLines > 0) {
						for(Integer idx=0; idx < blankLines; idx++) {
							regList.add(new Event_Registration__c());
						}
					}
				}
			}
			for(Integer idx=0; idx < LINES_PER_PAGE; idx++) {
				regList.add(new Event_Registration__c());
			}
		}
		return regList;
	}
}