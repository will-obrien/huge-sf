@isTest
private class EventTagControllerTest {

    static testMethod void myUnitTest() {
    	BulkEntryController bec = new BulkEntryController();
    	EventTagController etc = new EventTagController();
    	etc.pageController = bec;

    	Date dtStart = System.today();
    	Date dtEnd = dtStart.addDays(30);
    	
    	Campaign camp = new Campaign(
    	    Name = 'Test Campaign',
			Events_Category__c = 'Activist Event',
    		National_Campaign_Global__c = 'Beyond Coal',
    		Tactic_Owner_Category_Global__c = 'Digital Dept',
    		Tactic_Owner_Global__c = 'AddUp',
			Campaign_Strategy_Global__c = 'Clean Energy',
			Local_Campaign_Global__c = 'My Generation',
			State_Global__c = 'CA',
			Promo_Description__c = 'Test Campaign',
			StartDate = dtStart.addDays(10)
    	);
    	insert camp;
    	
    	bec.selectedEvent = camp;
    	etc.camp = camp;
    	etc.selectedEventId = camp.Id;
    	
    	etc.setEventStartString(formatDate(dtStart));
    	etc.setEventEndString(formatDate(dtEnd));
    	etc.getEventStartString();
    	etc.getEventEndString();
    	
    	etc.entityName = 'Test';
    	etc.eventNameMatch = 'Test';
        etc.promoDescription = 'Test';
    	etc.searchEvents();
    	etc.getSelectedEvent();
    	etc.getRegistrationStatusOptions();
    	etc.saveTag();
    	etc.cancelTag();
    	etc.resetEvent();
    	etc.deleteTag();
    	
    	etc.eventStartString = null;
    	etc.getEventStartString();
    	etc.eventList = new List<Campaign>();
    	etc.setSelectedEvent();
    }
	private static String formatDate(Date input) {
		if(input == null) {
			return '';
		}
		DateTime dt = DateTime.newInstance(input.year(), input.month(), input.day());
		return dt.format('MM/dd/yyyy');
	}
}