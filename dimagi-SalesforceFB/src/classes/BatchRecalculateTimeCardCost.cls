/**
 * Calculates cost of time cards.
 */
public without sharing class BatchRecalculateTimeCardCost implements Database.Batchable<sObject>, Database.Stateful {

    private Set<Id> timeCardsIds;
    private SalaryHistoryHelper salaryHistoryHelper;
    private List<SalaryHistoryRecord> employeeSalaryHistory;
    private String lastEmployee;

    public BatchRecalculateTimeCardCost(Set<Id> timeCards) {
        this.salaryHistoryHelper = new SalaryHistoryHelper();
        this.timeCardsIds = timeCards;
        this.employeeSalaryHistory = new List<SalaryHistoryRecord>();
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        this.salaryHistoryHelper = new SalaryHistoryHelper();
        this.employeeSalaryHistory = new List<SalaryHistoryRecord>();

        String query;
        System.debug('timeCardsIds ' + timeCardsIds);
        if (this.timeCardsIds != null && this.timeCardsIds.size() > 0) {
            query = 'SELECT Time_card_cost__c, Total__c, Employee__c, Date__c FROM Time_Card__c WHERE Id In: timeCardsIds AND Employee__c != \'\' ORDER BY Employee__c';
        } else {
            query = 'SELECT Time_card_cost__c, Total__c, Employee__c, Date__c FROM Time_Card__c WHERE Employee__c != \'\' ORDER BY Employee__c';
        }
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Time_Card__c> toUpdate = new List<Time_Card__c>();
        Date lastFromSalaryDate = Date.newInstance(1900, 1, 1);
        Date lastToSalaryDate = Date.today().addYears(1);
        Decimal lastSalary = 0;

        if (this.employeeSalaryHistory.size() > 0) {
            lastToSalaryDate = this.employeeSalaryHistory.size() > 1 ? this.employeeSalaryHistory.get(1).getValueDate() : Date.today().addYears(1);
            lastSalary = this.employeeSalaryHistory.get(0).getValue();
        }

        for (sObject obj : scope) {
            Time_Card__c tc = (Time_Card__c) obj;

            if (tc.Employee__c != this.lastEmployee) {
                this.lastEmployee = tc.Employee__c;
                this.employeeSalaryHistory = this.salaryHistoryHelper.mergeSalaryHistory([SELECT Name, Salary__c, Effective_Salary_Date__c, Exchange_Rate__c, Effective_Exchange_Rate_Date__c FROM SFDC_Employee__c WHERE Id =: tc.Employee__c]);
                System.debug('New employee : ' + tc.Employee__c);
                lastToSalaryDate = this.employeeSalaryHistory.size() > 1 ? this.employeeSalaryHistory.get(1).getValueDate() : Date.today().addYears(1);
                lastSalary = this.employeeSalaryHistory.get(0).getValue();
                lastFromSalaryDate = Date.newInstance(1900, 1, 1);
            }

            if (tc.Date__c < lastFromSalaryDate || tc.Date__c >= lastToSalaryDate) {
                Integer index = 0;
                for (Integer i = 0; i < this.employeeSalaryHistory.size(); i++) {
                    if (tc.Date__c >= this.employeeSalaryHistory.get(i).getValueDate()) {
                        lastSalary = this.employeeSalaryHistory.get(i).getValue();
                        lastFromSalaryDate = this.employeeSalaryHistory.get(i).getValueDate();
                    } else {
                        index = i - 1;
                        break;
                    }
                }

                lastToSalaryDate = this.employeeSalaryHistory.size() > index + 1 ? this.employeeSalaryHistory.get(index + 1).getValueDate() : Date.today().addYears(1);
            }

            Decimal laborCost = tc.Total__c * lastSalary;
            System.debug('Labor cost ' + laborCost);
            if (tc.Time_card_cost__c != laborCost) {
                tc.Time_card_cost__c = laborCost;
                toUpdate.add(tc);
                System.debug('tc cost ' + tc.Time_card_cost__c);
            }
        }

        if (toUpdate.size() > 0) {
            update toUpdate;
        }
    }

    public void finish(Database.BatchableContext context) {

    }
}