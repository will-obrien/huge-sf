public with sharing class ClubEventAdminController {
	public PageReference eventsAdded() {
		return Page.EventsAddedRequest;
	}
	public PageReference eventSummary() {
		return Page.EventSummaryRequest;
	}
	public PageReference eventsList() {
		return Page.ClubEventList;
	}
	public PageReference otherEntEvents() {
		return Page.OtherEntEvents;
	}
}