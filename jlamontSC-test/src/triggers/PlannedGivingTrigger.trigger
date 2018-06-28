//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//  Trigger on PlannedGiving Object
//  24 Feb 2014     Pitamber Sharma (Appirio)     Original
//**********************************************************************/

trigger PlannedGivingTrigger on rC_Giving__Planned_Giving__c (after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            PlannedGivingTriggerHandler.onAfterInsert(Trigger.new);
        } else if(Trigger.isUpdate) {
            PlannedGivingTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}