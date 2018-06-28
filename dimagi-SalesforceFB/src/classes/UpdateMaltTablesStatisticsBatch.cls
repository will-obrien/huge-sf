public class UpdateMaltTablesStatisticsBatch implements Database.Batchable<Domain__c>, Database.Stateful{

    private Map<String, Decimal> domainsWam;
    private Map<String, Decimal> domainsFormsForPeriod;
    private String serverCode;

    public UpdateMaltTablesStatisticsBatch(String serverCode, Map<String, Decimal> domainsWam, Map<String, Decimal> domainsFormsForPeriod) {
        this.domainsWam = domainsWam;
        this.domainsFormsForPeriod = domainsFormsForPeriod;
        this.serverCode = serverCode;
    }

    public List<Domain__c> start(Database.BatchableContext BC) {
        Set<String> domainIds = new Set<String>();
        domainIds.addAll(this.domainsWam.keySet());
        domainIds.addAll(this.domainsFormsForPeriod.keySet());
        return [SELECT Id, Name, Wam__c,Forms_for_Period__c FROM Domain__c WHERE Server_Name__c =: this.serverCode];
    }

    public void execute(Database.BatchableContext info, List<Domain__c> scope) {
        List<Domain__c> toUpdate = new List<Domain__c>();
        for (Domain__c dm : scope) {
            Boolean changed = false;
            if (this.domainsWam.containsKey(dm.Name)) {
                dm.Wam__c = this.domainsWam.get(dm.Name);
                changed = true;
            } else if (dm.Wam__c != null && dm.Wam__c > 0) {
                dm.Wam__c = 0;
                changed = true;
            }
            if (this.domainsFormsForPeriod.containsKey(dm.Name)) {
                dm.Forms_for_Period__c = this.domainsFormsForPeriod.get(dm.Name);
                changed = true;
            } else if (dm.Forms_for_Period__c != null && dm.Forms_for_Period__c > 0) {
                dm.Forms_for_Period__c = 0;
                changed = true;
            }

            if (changed == true) {
                toUpdate.add(dm);
            }
        }
        if (toUpdate.size() > 0) {
            update toUpdate;
        }
    }

    public void finish(Database.BatchableContext info) {

    }
}