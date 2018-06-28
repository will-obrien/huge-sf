public class TaskTriggerHelper{
    public static void createTaskOnOpportunity(List<Task> taskList) {
        
        if(CheckRecursive.firstRun){
            CheckRecursive.firstrun=false;
            
            Set<Id> contactIds = new Set<Id>();
            Map<Id,Set<Id>> contactIdOppIdMap = new Map<Id,Set<Id>>();
            for(Task theTask : taskList) {
                if(theTask.WhoId != null) {
                    contactIds.add(theTask.WhoId);
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
            
            List<Task> tasksToCreate = new List<Task>();
            for(Task theTask : taskList) {
                if(theTask.WhoId != null && contactIdOppIdMap.containsKey(theTask.WhoId)) {
                    for(Id theOppId :  contactIdOppIdMap.get(theTask.WhoId)) {
                        if(theTask.WhatId != theOppId){
                            Task newTask = new Task(
                                OwnerId = theTask.OwnerId,
                                CallObject = theTask.CallObject,
                                CallDisposition = theTask.CallDisposition,
                                CallType = theTask.CallType,
                                Description = theTask.Description,
                                ActivityDate = theTask.ActivityDate,
                                RecurrenceInterval = theTask.RecurrenceInterval,
                                WhoId = theTask.WhoId,
                                RecurrenceRegeneratedType = theTask.RecurrenceRegeneratedType,
                                Priority = theTask.Priority,
                                WhatId = theOppId,
                                Status = 'Completed',
                                Subject = theTask.Subject,
                                Type = theTask.Type,
                                ActivitySubtype__c = theTask.ActivitySubtype__c
                            );
                            tasksToCreate.add(newTask);
                        }
                    }
                }
            }
            try{
                insert tasksToCreate;
            }catch(Exception ex){
                
            }
            
            
        }
    }
}