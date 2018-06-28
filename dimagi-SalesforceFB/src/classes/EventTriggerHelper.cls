public class EventTriggerHelper{
    public static void createEventOnOpportunity(List<Event> eventList) {
        
        if(CheckRecursive.firstRun){
            CheckRecursive.firstrun=false;
            
            Set<Id> contactIds = new Set<Id>();
            Map<Id,Set<Id>> contactIdOppIdMap = new Map<Id,Set<Id>>();


            for(Event theEvent : eventList) {
                if(theEvent.WhoId != null) {
                    contactIds.add(theEvent.WhoId);
                }
            }
            
                
            for(OpportunityContactRole contactRole : [Select id,ContactId,Contact.Name,OpportunityId from OpportunityContactRole where ContactId IN :contactIds]) {
                if(contactIdOppIdMap.containsKey(contactRole.ContactId)) {
                    Set<Id> tempSet = new Set<Id>(contactIdOppIdMap.get(contactRole.ContactId));
                    tempSet.add(contactRole.OpportunityId);
                    contactIdOppIdMap.put(contactRole.ContactId,tempSet);
                }else{
                    contactIdOppIdMap.put(contactRole.ContactId,new Set<Id>{contactRole.OpportunityId});
                }
            }
            
            List<Event> eventsToCreate = new List<Event>();
            for(Event theEvent : eventList) {
                if(theEvent.WhoId != null && contactIdOppIdMap.containsKey(theEvent.WhoId)) {
                    for(Id theOppId :  contactIdOppIdMap.get(theEvent.WhoId)) {
                        if(theEvent.WhatId != theOppId) {
                            Event newTask = new Event(
                                IsAllDayEvent = theEvent.IsAllDayEvent,
                                OwnerId = theEvent.OwnerId,
                                ActivityDate = theEvent.ActivityDate,
                                Description = theEvent.Description,
                                DurationInMinutes = theEvent.DurationInMinutes,
                                EndDateTime = theEvent.EndDateTime,
                                EventSubtype = theEvent.EventSubtype,
                                Location = theEvent.Location,
                                WhoId = theEvent.WhoId,
                                IsPrivate = theEvent.IsPrivate,
                                WhatId = theOppId,
                                ShowAs = theEvent.ShowAs,
                                StartDateTime = theEvent.StartDateTime,
                                Subject = theEvent.Subject,
                                ActivityDateTime = theEvent.ActivityDateTime,
                                Type = theEvent.Type,
                                ActivitySubtype__c = theEvent.ActivitySubtype__c
                            );
                            eventsToCreate.add(newTask);
                        }
                    }
                }
            }
            try{
                insert eventsToCreate;
            }catch(Exception ex) {
                
            }
            
            
        }
    }
}