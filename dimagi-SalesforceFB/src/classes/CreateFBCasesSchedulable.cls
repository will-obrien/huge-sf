/**
 * Runs batch job which creates FogBugz case from Opportunity without case Id.
 */
global class CreateFBCasesSchedulable implements Schedulable {

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CreateFBCasesBatch(), 10);
    }
}