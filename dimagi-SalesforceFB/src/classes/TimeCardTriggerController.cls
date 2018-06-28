public class TimeCardTriggerController {

    public void rollUpTimeCardsTotalSpent(List<Time_Card__c> timeCardList) {
        Set<Id> contractIds = new Set<Id>();

        for (Time_Card__c obj : timeCardList) {
            if(obj.Client__c != null) {
                contractIds.add(obj.Client__c);
            }
        }

        if (contractIds.isEmpty() == false) {
            TimeCardTriggerController.loadTimeCardsTotalAmountByContractIds(contractIds);
        }
    }

    @future
    public static void loadTimeCardsTotalAmountByContractIds(Set<Id> contractIds) {
        List<DContract__c> contractsFromDB =  [SELECT Id, Services_Spend__c, Parent_Contract__c, (SELECT Id, Services_Spend__c FROM Contracts__r) FROM DContract__c WHERE Id IN :contractIds];
        Map<Id, DContract__c> contracts = new Map<Id, DContract__c>();
        Set<Id> childs = new Set<Id>();
        Set<Id> parents = new Set<Id>();

        for (DContract__c dc : contractsFromDB) {
            if (!String.isBlank(dc.Parent_Contract__c)) {
                parents.add(dc.Parent_Contract__c);
            } else if (dc.Contracts__r != null && dc.Contracts__r.size() > 0) {
                for (DContract__c child : dc.Contracts__r) {
                    childs.add(child.Id);
                }
            }
            contracts.put(dc.Id, dc);
        }

        List<DContract__c> parentsFromDB =  [SELECT Id, Services_Spend__c, Parent_Contract__c, (SELECT Id, Services_Spend__c FROM Contracts__r) FROM DContract__c WHERE Id IN :parents];
        for (DContract__c dc : parentsFromDB) {
            if (dc.Contracts__r != null && dc.Contracts__r.size() > 0) {
                for (DContract__c child : dc.Contracts__r) {
                    childs.add(child.Id);
                }
            }
            contracts.put(dc.Id, dc);
        }

        Set<Id> ids = new Set<Id>();
        ids.addAll(contracts.keySet());
        ids.addAll(childs);
        Map<Id, Integer> resultsBycontractId = new Map<Id, Integer>();

        AggregateResult[] results = [Select Client__c, SUM(labor_cost__c) Total from Time_Card__c where Client__c IN : ids Group By Client__c];
        for (AggregateResult result : results) {
            Id contractId = (Id) result.get('Client__c');
            Integer total = Integer.valueOf((decimal) result.get('Total'));
            if (total != null) {
                resultsBycontractId.put(contractId, total);
            }
        }

        List<DContract__c> contractsToUpdate = new List<DContract__c>();
        for (Id contractId : contracts.keySet()) {
            DContract__c dc = contracts.get(contractId);
            Integer total = 0;

            if (resultsBycontractId.containsKey(contractId)) {
                total = resultsBycontractId.get(contractId);
            }

            if (dc.Contracts__r != null && dc.Contracts__r.size() > 0) {
                for (DContract__c child : dc.Contracts__r) {
                    if (resultsBycontractId.containsKey(child.Id)) {
                        total += resultsBycontractId.get(child.Id);
                    }
                }
            }

            if (dc.Services_Spend__c != total) {
                dc.Services_Spend__c = total;
                contractsToUpdate.add(dc);
            }
        }

        if(contractsToUpdate.isEmpty() == false) {
            Database.SaveResult[] saveResults = Database.update(contractsToUpdate, false);
            System.debug('--- Updated Contracts ---' + saveResults);
        }
    }
}