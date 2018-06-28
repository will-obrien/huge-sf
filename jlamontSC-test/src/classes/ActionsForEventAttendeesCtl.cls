public with sharing class ActionsForEventAttendeesCtl {
    private static Id offLineTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Offline').getRecordTypeId();
	public List<Wrapper> registrantList;
	public kweos__EOCS_Data__c action {get; set;} {action = new kweos__EOCS_Data__c();}
	private Campaign event;
	private Boolean hasErrors = false;

	private Campaign getEvent() {
		if(event == null) {
	        Id id = System.currentPageReference().getParameters().get('id');
			event = [select Id, Event_Name__c, Start_Date__c from Campaign where Id = :id];
			action.Action_Date__c = event.Start_Date__c;
		}
		return event;
	}	
	public String getEventTitle() {
		return getEvent().Event_Name__c;
	}
	public List<Wrapper> getRegistrantList() {
		if(registrantList == null) {
	        Id id = System.currentPageReference().getParameters().get('id');
	        List<Event_Registration__c> regList = [
	        	select
	        		Id,
	        		Contact__r.FirstName,
	        		Contact__r.LastName,
	        		Contact__c,
	        		Status__c
	        	from Event_Registration__c
	        	where 
	        		Campaign__c = :id
	        		and Contact__c != null
	        		and Status__c not in ('Cancelled', 'No Show')
	        	order by Last_Name__c, First_Name__c
	        ];
	        registrantList = new List<Wrapper>();
	        for(Event_Registration__c reg : regList) {
	        	Wrapper wrap = new Wrapper();
	        	wrap.id = reg.Id;
	        	wrap.firstName = reg.Contact__r.FirstName;
	        	wrap.lastName = reg.Contact__r.LastName;
	        	wrap.contactId = reg.Contact__c;
	        	wrap.status = reg.Status__c;
	        	wrap.isSelected = false;
	        	registrantList.add(wrap);
	        }
		}
		return registrantList;        
	}
	private void processList() {
		List<kweos__EOCS_Data__c> actionList = new List<kweos__EOCS_Data__c>();
		for(Wrapper wrap : registrantList) {
			if(wrap.isSelected) {
				kweos__EOCS_Data__c actionToAdd = new kweos__EOCS_Data__c();
				actionToAdd.RecordTypeId = offLineTypeId;
				actionToAdd.Action__c = action.Action__c;
				actionToAdd.Action_Status__c = action.Action_Status__c;
				actionToAdd.Action_Date__c = action.Action_Date__c;
				actionToAdd.kwac__Contact__c = wrap.contactId;
				actionToAdd.kwac__Related_Action__c = getEvent().Id;
				actionList.add(actionToAdd);
				wrap.isSelected = false;				
			}
		}
		if( ! actionList.isEmpty() ) {
			insert actionList;
		}
		action = new kweos__EOCS_Data__c();
		action.Action_Date__c = getEvent().Start_Date__c;
	}
	public PageReference save() {
		processList();
		String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
		return new PageReference(baseURL + '/' + getEvent().id);
	}
	public PageReference saveAndMore() {
		processList();
		return null;
	}
	public PageReference cancel() {
		String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
		return new PageReference(baseURL + '/' + getEvent().id);
	}
	public Class Wrapper {
		public Id id {get; set;}
		public String firstName {get; set;}
		public String lastName {get; set;}
		public Id contactId {get; set;}
		public String status {get; set;}
		public Boolean isSelected {get; set;}
	}
}