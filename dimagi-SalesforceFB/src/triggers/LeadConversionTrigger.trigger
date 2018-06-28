trigger LeadConversionTrigger on Lead (after update) {
    if (Trigger.new.size() > 0) {
        if (!RecursiveTriggerHelper.hasRecursiveFlag()) {
            Decimal threshold = 7;
            Set<Id> leadIds = new Set<Id>();

            Lead_Qualifying_Process__c settings = Lead_Qualifying_Process__c.getOrgDefaults();
            if (settings != null && settings.Threshold__c != null) {
                threshold = settings.Threshold__c;
            }

            System.debug('SIZE: ' + Trigger.new.size());
            for (Lead l : Trigger.new) {
                // After conversion
                if (Trigger.oldMap.get(l.Id).isConverted == false && l.isConverted == true) {
                    if (l.ConvertedOpportunityId != null) {
                        Opportunity opp = [SELECT Id, Lead_Status__c, Lead_Status_Reason__c, Lead_Ever_Responded__c, Lead_first_call_held__c, Lead_follow_up_calls_held__c
                                    FROM Opportunity WHERE Id = :l.ConvertedOpportunityId];
                        opp.Lead_Status__c = l.Status;
                        opp.Lead_Status_Reason__c = l.Lead_Status_Reason__c;
                        opp.Lead_Ever_Responded__c = l.Ever_Responded__c == 0 ? false : true;
                        opp.Lead_first_call_held__c = l.First_call_held__c == 0 ? false : true;
                        opp.Lead_follow_up_calls_held__c = l.Follow_up_calls_held__c;
                        update opp;
                    }
                } else {
                    if (!Test.isRunningTest()) {
                        if (l.Failed_Qualifying_process_at_least_once__c == false && l.Days_w_o_Activity__c > threshold && l.Status == 'Working - Talking' && (l.Follow_up_Date__c == null || l.Follow_up_Date__c < Date.today())
                                && (l.Hubspot_Next_Activity_Date__c == null || l.Hubspot_Next_Activity_Date__c < Date.today())
                                && (l.Lead_Status_Reason__c == 'Working - Exploratory Call - Trying for' || l.Lead_Status_Reason__c == 'Working - Exploratory Call Held')) { // Failing qualifying process
                            leadIds.add(l.Id);
                        }
                    } else { // We cannot mock LastActivityDate so in test we use Follow_up_calls_held field !!! IMPORTANT for changes
                        System.debug('Name test : ' + l.Name);
                        if (l.Failed_Qualifying_process_at_least_once__c == false && l.Follow_up_calls_held__c > threshold && l.Status == 'Working - Talking' && (l.Follow_up_Date__c == null || l.Follow_up_Date__c < Date.today())
                                && (l.Hubspot_Next_Activity_Date__c == null || l.Hubspot_Next_Activity_Date__c < Date.today())
                                && (l.Lead_Status_Reason__c == 'Working - Exploratory Call - Trying for' || l.Lead_Status_Reason__c == 'Working - Exploratory Call Held')) {
                            leadIds.add(l.Id);
                        }
                    }
                }
            }

            if (leadIds.size() > 0) {
                System.debug('leadIds ' + leadIds.size());
                List<Lead> leads = [SELECT Id, Failed_Qualifying_process_at_least_once__c FROM Lead WHERE Id In: leadIds];
                for (Lead l : leads) {
                    l.Failed_Qualifying_process_at_least_once__c = true;
                }
                if (leads.size() > 0) {
                    RecursiveTriggerHelper.setRecursiveFlag();
                    update leads;
                }
            }
        }
    }
}