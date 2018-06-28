/**
 * Calculates Services Spend field value for each contracts, runs BatchUpdateContractServicesSpend job.
 */
global without sharing class BatchCalculateTotalHoursOfTimeCard implements Database.Batchable<sObject>, Database.Stateful {

    private String contractId;
    private Map<Id, Decimal> servicesSpendMap;
    private String lastEmployee;
    private List<SalaryHistoryRecord> employeeSalaryHistory;
    private SalaryHistoryHelper salaryHistoryHelper;
    private Boolean testMode;

    global BatchCalculateTotalHoursOfTimeCard(){
        this.testMode = false;
        this.servicesSpendMap = new Map<Id, Decimal>();
    }

    global BatchCalculateTotalHoursOfTimeCard(String contractId){
        this.testMode = false;
        this.contractId = contractId;
        this.servicesSpendMap = new Map<Id, Decimal>();
    }

    global Database.QueryLocator start(Database.BatchableContext context) {
        this.salaryHistoryHelper = new SalaryHistoryHelper();
        this.employeeSalaryHistory = new List<SalaryHistoryRecord>();

        String query;
        if (String.isEmpty(contractId)) {
            query = 'SELECT Client__c, Time_card_cost__c, Employee__c, Date__c FROM Time_Card__c WHERE Employee__c != \'\' ORDER BY Employee__c';
        } else {
            query = 'SELECT Client__c, Time_card_cost__c, Employee__c, Date__c FROM Time_Card__c WHERE Client__c =: contractId ORDER BY Employee__c';
        }
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for (sObject obj : scope) {
            Time_Card__c tc = (Time_Card__c) obj;

            if (tc.Time_card_cost__c != null) {
                if (servicesSpendMap.containsKey(tc.Client__c)) {
                    servicesSpendMap.put(tc.Client__c, servicesSpendMap.get(tc.Client__c) + tc.Time_card_cost__c);
                } else {
                    servicesSpendMap.put(tc.Client__c, tc.Time_card_cost__c);
                }
            }
        }
    }

    global void finish(Database.BatchableContext context){
        // We must update values in contracts
        if (!Test.isRunningTest()) {
            BatchUpdateContractServicesSpend obj = new BatchUpdateContractServicesSpend(servicesSpendMap);
            Database.executeBatch(obj, 50);
        }
    }

    public Map<Id, Decimal> getServicesSpendMap() {
        return this.servicesSpendMap;
    }
}