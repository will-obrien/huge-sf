public with sharing class TriggerDispatcher {
    
    public static Handler activeHandler = null;
    
    public static void callHandler(String triggerObject,
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
        map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap)
    {
        if (TriggerDispatcher.activeHandler != null) {
            System.debug(LoggingLevel.ERROR, '@@@ Dispatching to in progress entry for ' + triggerObject + '...');
            System.debug(LoggingLevel.ERROR, '@@@ the active handler is for ' + activeHandler.handlerType);
            TriggerDispatcher.activeHandler.inProgressEntry(
                triggerObject,isBefore, isAfter, isInsert, isUpdate, isDelete, 
                isUndelete, isExecuting, newList, newMap, oldList, oldMap
            );
        }
        else {
            if (triggerObject == 'Account') {
                TriggerDispatcher.activeHandler = new Handler_Account(triggerObject);
            }
            else if (triggerObject == 'Individual Email Result') {
                TriggerDispatcher.activeHandler = new Handler_IndividualEmailResult(triggerObject);
            }
            else if (triggerObject == 'Lead Source') {
                TriggerDispatcher.activeHandler = new Handler_LeadSource(triggerObject);
            }
            else if (triggerObject == 'Lead') {
                TriggerDispatcher.activeHandler = new Handler_Lead(triggerObject);
            }
            else if (triggerObject == 'Referral') {
                TriggerDispatcher.activeHandler = new Handler_Referral(triggerObject);
            }
            else if (triggerObject == 'Task') {
                TriggerDispatcher.activeHandler = new Handler_Task(triggerObject);
            }
            else if (triggerObject == 'Webinar_Attendance__c') {
                TriggerDispatcher.activeHandler = new Handler_WebinarAttendance(triggerObject);
            } 
            else if (triggerObject == 'Opportunity') {
                TriggerDispatcher.activeHandler = new Handler_Opportunity(triggerObject);
            }
            if (TriggerDispatcher.activeHandler != null) {
                System.debug(LoggingLevel.ERROR, '@@@ Dispatching to main entry for ' + triggerObject + '...');
                TriggerDispatcher.activeHandler.mainEntry(
                    triggerObject,isBefore,isAfter,isInsert,isUpdate, isDelete, 
                    isUndelete,isExecuting, newList, newMap, oldList, oldMap
                );
            }
        }
    }
}