/**
 * Creates a FogBugz case upon Opportunity creation, and closes a FogBugz case upon Opportunity deletion.
 *
 * @todo    Handle bulk insertions
 *
 * @author  Antonio Grassi
 * @date    11/13/2012
 */

trigger OpportunityToCase on Opportunity (after insert, after delete, after update) {
    if (Trigger.isDelete) {
        OpportunityTriggers.closeFogbugzCase(Trigger.old[0].Fogbugz_Ticket_Number__c);
    } else if (Trigger.isUpdate) {
        OpportunityTriggers.updateCaseInFogbugz(Trigger.new[0], Trigger.old[0]);
    } else if (Trigger.new[0].Fogbugz_Ticket_Number__c == null && !System.isBatch()) {
        OpportunityTriggers.createInFogbugz(Trigger.new[0].Id);
    }
}