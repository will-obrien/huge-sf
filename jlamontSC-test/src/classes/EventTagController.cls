public with sharing class EventTagController {
    public Date eventStart, eventEnd;
    public String eventStartString;
    public String eventEndString;
    public String eventNameMatch {get; set;}
    public String entityName {get; set;}
    public String promoDescription {get; set;}
    public String localGrassrootsCampName {get; set;}
    public List<Campaign> eventList {get; set;}
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    public Campaign selectedEvent {get; set;}
    public Campaign camp {get; set;} {camp = new Campaign(); camp.RecordTypeId = eventsTypeId;}
    public String eventRegistrationStatus {get; set;}
    public Id selectedEventId {get; set;}
    public List<SelectOption> registrationStatusOptions;
    public BulkEntryController pageController { get;
        set {
            if(value != null) {
                pageController = value;
                pageController.setEvTagController(this);
            }
        }
    }
    public Campaign getSelectedEvent() {
        if(selectedEvent == null) {
            selectedEvent = pageController.selectedEvent;
            eventRegistrationStatus = pageController.selectedEventRegistrationStatus;
        }
        return selectedEvent;
    }
    public String getEventStartString() {
        return eventStartString;
    }
    public void setEventStartString(String dt) {
        eventStartString = dt;
        if( ! String.isEmpty(eventStartString)) {
            eventStart = Date.parse(eventStartString);
        }
    }
    public String getEventEndString() {
        return eventEndString;
    }
    public void setEventEndString(String dt) {
        eventEndString = dt;
        if( ! String.isEmpty(eventEndString)) {
            eventEnd = Date.parse(eventEndString);
        }
    }
    public void searchEvents() {
        String eventsCategory, nationalCampaign, strategy, local, state, tacticOwnerCategory, tacticOwner;
        String soql =
            'SELECT Id, Name, Promo_Description__c, Status__c, Start_Date__c, Club_Entity__r.Name, Events_Category__c, Events_Type__c, Club_Event__c, Event_Name__c ' +
            'FROM Campaign ' +
            'WHERE RecordTypeId=:eventsTypeId ' +
            'AND (Status__c = \'Active\' OR Status__c = \'At Capacity\' OR Status__c = \'In Development\') ';
        if(eventStart != null) {
            soql += 'AND Start_Date__c >= :eventStart ';
        }
        if(eventEnd != null) {
            soql += 'AND Start_Date__c <= :eventEnd ';
        }
        if( ! String.isEmpty(entityName)) {
            soql += 'AND Club_Entity__r.Name LIKE \'%' + entityName.trim() + '%\' '; 
        }
        if( ! String.isEmpty(eventNameMatch)) {
            soql += 'AND Name = :eventNameMatch '; 
        }
        if( ! String.isEmpty(promoDescription)) {
            soql += 'AND Promo_Description__c LIKE \'%' + promoDescription.trim() + '%\' '; 
        }
        if(camp.Events_Category__c != null) {
            eventsCategory = camp.Events_Category__c;
            soql += 'AND Events_Category__c = :eventsCategory ';
        }
        if(camp.Tactic_Owner_Category_Global__c != null) {
            tacticOwnerCategory = camp.Tactic_Owner_Category_Global__c;
            soql += 'AND Tactic_Owner_Category_Global__c = :tacticOwnerCategory ';
        }
        if(camp.Tactic_Owner_Global__c != null) {
            tacticOwner = camp.Tactic_Owner_Global__c;
            soql += 'AND Tactic_Owner_Global__c = :tacticOwner ';
        }
        if(camp.State_Global__c != null) {
            state = camp.State_Global__c;
            soql += 'AND State_Global__c = :state ';
        }
        if(camp.National_Campaign_Global__c != null) {
            nationalCampaign = camp.National_Campaign_Global__c;
            soql += 'AND National_Campaign_Global__c = :nationalCampaign ';
        }
        if(camp.Campaign_Strategy_Global__c != null) {
            strategy = camp.Campaign_Strategy_Global__c;
            soql += 'AND Campaign_Strategy_Global__c = :strategy ';
        }
        if(camp.Local_Campaign_Global__c != null) {
            local = camp.Local_Campaign_Global__c;
            soql += 'AND Local_Campaign_Global__c = :local ';
        }
        if(! String.isEmpty(localGrassrootsCampName)) {
            soql += 'AND Local_Grassroots_Campaign__r.Name LIKE \'%' + localGrassrootsCampName.trim() + '%\' ';
        }
        soql += 'ORDER BY Name ';
        System.debug('soql:' + soql);
        eventList = Database.query(soql);
        System.debug('eventList: ' + eventList);
    }
    public void setSelectedEvent() {
        for(Campaign ev : eventList) {
            if(ev.Id == selectedEventId) {
                selectedEvent = ev;
                registrationStatusOptions = null;
                break;
            }           
        }
        if(selectedEvent != null) {
            eventList = null;
        }
    }
    public List<SelectOption> getRegistrationStatusOptions() {
        if(registrationStatusOptions == null) {
            if(selectedEvent == null) {
                return null;
            }
            registrationStatusOptions = new List<SelectOption>();
            Schema.DescribeFieldResult statusFieldDescription = Event_Registration__c.Status__c.getDescribe();
            for(Schema.Picklistentry entry : statusFieldDescription.getPicklistValues()) {
                registrationStatusOptions.add(new SelectOption(entry.getLabel(), entry.getValue()));
            }
        }
        return registrationStatusOptions; 
    }
    public void resetEvent() {
        eventList = null;
        selectedEvent = null;
    }
    public void saveTag() {
        pageController.selectedEvent = selectedEvent;
        pageController.selectedEventRegistrationStatus = eventRegistrationStatus;
    }
    public void cancelTag() {
        selectedEvent = null;
        eventRegistrationStatus = null;
        eventList = null;
    }
    public void deleteTag() {
        pageController.selectedEvent = null;
        pageController.selectedEventRegistrationStatus = null;
    }
}