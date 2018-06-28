/*********************************************************************************************************
Name			: EventRegistrationActions
Created By		: Tami Lau
Created Date	: March 31, 2017
Description		: Called by EventRegistrationTrigger after insert or update
				: Creates Advocacy Action records for Event Attendance, as well as any additional actions specified on Events Campaign
				: Test is in EventRegistrationTriggerHandlerTest
Updated			: 
***********************************************************************************************************/

public class EventRegistrationActions {
    public static void createAttendeeActions(List<Event_Registration__c> newRegs) {
        
        Id offlineActionTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Offline').getRecordTypeId();
        
        List<Event_Registration__c> regs = [SELECT Id, Contact__c, Source_Campaign__c, Campaign__c, Status__c, Advocacy_Action_Created__c, Campaign__r.Start_Date__c, Campaign__r.Add_Action_to_Attendees__c
                                            FROM Event_Registration__c WHERE Id IN :newRegs];
        List<kweos__EOCS_Data__c> actionsToCreate = new List<kweos__EOCS_Data__c>();
        List<Event_Registration__c> regsToUpdate = new List<Event_Registration__c>();
        
        for (Event_Registration__c reg:regs) {
            if (reg.Status__c == 'Attended' && reg.Contact__c != null && reg.Advocacy_Action_Created__c == false) {
                if (reg.Campaign__r.Add_Action_to_Attendees__c != null) {
                    kweos__EOCS_Data__c newAction = new kweos__EOCS_Data__c(
                        RecordTypeId = offlineActionTypeId,
                		kwac__Contact__c = reg.Contact__c,
                		kwac__Related_Action__c = reg.Campaign__c,
                		kwac__Source_Campaign__c = reg.Source_Campaign__c,
                		Action_Date__c = reg.Campaign__r.Start_Date__c,
                		Action__c = reg.Campaign__r.Add_Action_to_Attendees__c);
                	actionsToCreate.add(newAction);
                }
                kweos__EOCS_Data__c newAction2 = new kweos__EOCS_Data__c(
                    RecordTypeId = offlineActionTypeId,
                	kwac__Contact__c = reg.Contact__c,
                	kwac__Related_Action__c = reg.Campaign__c,
                	kwac__Source_Campaign__c = reg.Source_Campaign__c,
                	Action_Date__c = reg.Campaign__r.Start_Date__c,
                	Action__c = 'Event Attendance');
                actionsToCreate.add(newAction2);
                
                Event_Registration__c regToUpdate = new Event_Registration__c(
                	Id = reg.Id,
                	Advocacy_Action_Created__c=true);

                regsToUpdate.add(regToUpdate);
            }
        }
        
        insert actionsToCreate;
        update regsToUpdate;
    }

}