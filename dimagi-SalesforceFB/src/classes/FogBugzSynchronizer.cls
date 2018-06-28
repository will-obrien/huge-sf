/**
 * Retrieves FogBugz cases and upserts SF opportunities
 *
 * @author  Antonio Grassi
 * @date    11/14/2012
 */
global without sharing class FogBugzSynchronizer implements Schedulable {

    global void execute(SchedulableContext SC) {
        FogBugz_Settings__c fbSettings = FogBugz_Settings__c.getOrgDefaults();

        if (!fbSettings.Sync_Script_Running__c) {
            Database.executeBatch(new FogBugzSynchronizerBatch(fbSettings.Sync_Filter__c.intValue(), false), 1);
        }
    }
}