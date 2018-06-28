trigger DomainOpportunityUpdatedTrigger on Domain__c (after update) {
    if (Trigger.new.size() > 0) {
        if (!RecursiveTriggerHelper.hasRecursiveFlag()) {
            Set<Id> opps = new Set<Id>();
            Map<Id, Id> domainToOpp = new Map<Id, Id>();
            System.debug('Updated domains : ' + Trigger.new);
            for (Domain__c domain : Trigger.new) {
                Domain__c oldDomain = Trigger.oldMap.get(domain.Id);
                System.debug('domain : ' + domain.Opportunity__c + ' ' + domain.Name + ' ' + oldDomain.Opportunity__c);
                if ((domain.Opportunity__c != null && oldDomain.Opportunity__c == null)
                    || (domain.Opportunity__c != null && domain.Opportunity__c != oldDomain.Opportunity__c)) {
                    opps.add(domain.Opportunity__c);
                    domainToOpp.put(domain.Id, domain.Opportunity__c);
                    System.debug('domain added');
                }
            }

            if (opps.size() > 0) {
                List<OpportunityContactRole> contactRoles = [SELECT ContactId, OpportunityId FROM OpportunityContactRole WHERE IsPrimary = true AND OpportunityId IN: opps];
                Map<Id, Id> oppToContactMap = new Map<Id, Id>();
                for (OpportunityContactRole role : contactRoles) {
                    oppToContactMap.put(role.OpportunityId, role.ContactId);
                }

                List<Domain__c> domainsToUpdate = new List<Domain__c>();
                for (Id domainId : domainToOpp.keySet()) {
                    Id oppId = domainToOpp.get(domainId);
                    if (oppId != null && oppToContactMap.containsKey(oppId)) {
                        domainsToUpdate.add(new Domain__c(Id = domainId, Primary_Contact__c = oppToContactMap.get(oppId)));
                    }
                }

                if (domainsToUpdate.size() > 0) {
                    RecursiveTriggerHelper.setRecursiveFlag();
                    System.debug('domain updated ' + domainsToUpdate.size());
                    update domainsToUpdate;
                }
            }
        }
    }
}