public with sharing class EventTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public EventTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
        

    public void OnAfterInsert(Event[] newEvents){
        processEMGEvents(newEvents);
    }
    public void OnAfterUpdate(Event[] oldEvents, Event[] updatedEvents, Map<ID, Event> oldEventMap, Map<ID, Event> newEventMap){
        processEMGEvents(updatedEvents);
    }

    public void processEMGEvents(Event[] eventList){
        List<Lead> emgleadListToUpdate = new List<Lead>();
        List<Lead> jvleadListToUpdate = new List<Lead>();

        List<Contact> jvpcontactListToUpdate = new List<Contact>();
        for(Event evt : eventList){
            if(evt.Subject == 'EMG Event Evaluation' && 
               evt.StartDateTime != null && 
               evt.WhoId != null){
                if(((String)evt.WhoId).startsWith('00Q')){
                    emgleadListToUpdate.add(new Lead(Id = evt.WhoId,
                                                  Event_Evaluation_Appointment__c = evt.StartDateTime));
                }
            }
            if(evt.Subject != null && evt.Subject.contains('EMG JV Meeting')&& 
               evt.StartDateTime != null && 
               evt.WhoId != null){
                if(((String)evt.WhoId).startsWith('00Q')){
                    jvleadListToUpdate.add(new Lead(Id = evt.WhoId,
                                                  JV_Presentation_Appt__c = evt.StartDateTime,
                                                  JVP_Location_Address__c = evt.Location));
                }
            }

            if(evt.Subject != null && evt.Subject.contains('EMG JVP Meeting') && 
               (evt.StartDateTime != null || evt.Location != null) &&
               evt.WhoId != null){


                if(((String)evt.WhoId).startsWith('003')){
                    jvpcontactListToUpdate.add(new Contact(Id = evt.WhoId,
                                                  JVP_Appt__c  = evt.StartDateTime,
                                                  JVP_Location_Address__c = evt.Location));
                }
            }
        }
        if(emgleadListToUpdate.size() > 0) update emgleadListToUpdate;
        if(jvleadListToUpdate.size() > 0) update jvleadListToUpdate;
        if(jvpcontactListToUpdate.size() > 0) update jvpcontactListToUpdate;
    }
    /*
    public void OnBeforeInsert(Event[] newEvents){
    }
    
    
    @future public static void OnAfterInsertAsync(Set<ID> newEventIDs){
    }
    
    public void OnBeforeUpdate(Event[] oldEvents, Event[] updatedEvents, Map<ID, Event> oldEventMap, Map<ID, Event> newEventMap){
    }
    
    
    @future public static void OnAfterUpdateAsync(Set<ID> updatedEventIDs){
    }
    
    public void OnBeforeDelete(Event[] EventsToDelete, Map<ID, Event> EventMap){
        
    }
    
    public void OnAfterDelete(Event[] deletedEvents, Map<ID, Event> EventMap){
        
    }
    
    @future public static void OnAfterDeleteAsync(Set<ID> deletedEventIDs){
        
    }
    
    public void OnUndelete(Event[] restoredEvents){
        
    }
    
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }
    
    public boolean IsVisualforcePageContext{
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsWebServiceContext{
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsExecuteAnonymousContext{
        get{ return !IsTriggerContext;}
    }
    */
}