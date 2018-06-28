/**
 * Batch job used to calculate "Failed Qualifying process at least once" field. Notice in test we are using Follow_up_calls_held__c instead Days_w_o_Activity__c (we cannot mock it).
 */
public without sharing class LeadQualifyProcessBatch implements Database.Batchable<Lead>, Database.Stateful {

    private Date currentDate;

    public LeadQualifyProcessBatch () {
        this.currentDate = Date.today();
    }

    public LeadQualifyProcessBatch (Date currentDate) {
        this.currentDate = currentDate;
    }

    public List<Lead> start(Database.BatchableContext context) {
        Decimal threshold = 7;
        Lead_Qualifying_Process__c settings = Lead_Qualifying_Process__c.getOrgDefaults();
        if (settings != null && settings.Threshold__c != null) {
            threshold = settings.Threshold__c;
        }

        if (!Test.isRunningTest()) {
            return [SELECT Id, Days_w_o_Activity__c, Failed_Qualifying_process_at_least_once__c FROM Lead WHERE Failed_Qualifying_process_at_least_once__c = false AND isConverted = false
                                                      AND Status = 'Working - Talking' AND (Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for' OR Lead_Status_Reason__c = 'Working - Exploratory Call Held')
                                                      AND (Follow_up_Date__c = null OR Follow_up_Date__c <: this.currentDate)
                                                      AND (Hubspot_Next_Activity_Date__c = null OR Hubspot_Next_Activity_Date__c <: this.currentDate)
                                                      AND Days_w_o_Activity__c >: threshold];
        } else { // We cannot mock LastActivityDate so in test we use First_Call_Date__c field !!! IMPORTANT for any changes
            return [SELECT Id, Days_w_o_Activity__c, Failed_Qualifying_process_at_least_once__c FROM Lead WHERE Failed_Qualifying_process_at_least_once__c = false AND isConverted = false
                                                      AND Status = 'Working - Talking' AND (Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for' OR Lead_Status_Reason__c = 'Working - Exploratory Call Held')
                                                      AND (Follow_up_Date__c = null OR Follow_up_Date__c <: this.currentDate)
                                                      AND (Hubspot_Next_Activity_Date__c = null OR Hubspot_Next_Activity_Date__c <: this.currentDate)
                                                      AND Follow_up_calls_held__c >: threshold];
        }

    }

    public void execute(Database.BatchableContext context, List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();
        for (Lead l : leads) {
            l.Failed_Qualifying_process_at_least_once__c = true;
            leadsToUpdate.add(l);
        }
        if (leadsToUpdate.size() > 0) {
            update leadsToUpdate;
        }
    }

    public void finish(Database.BatchableContext context) {

    }
}