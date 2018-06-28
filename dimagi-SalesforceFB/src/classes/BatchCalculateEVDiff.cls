public class BatchCalculateEVDiff implements Database.Batchable<Pipeline_Snapshot__c>, Database.Stateful {

    private Date currentDate;
    private Boolean forClosed;

    public BatchCalculateEVDiff (Date currentDate) {
        this.currentDate = currentDate;
    }

    public List<Pipeline_Snapshot__c> start(Database.BatchableContext BC) {
        Date firstDate = this.currentDate.toStartOfMonth();
        Date lastDate = firstDate.addDays(Date.daysInMonth(this.currentDate.year() , this.currentDate.month())).addDays(-1);

        List<Pipeline_Snapshot__c> records = [SELECT Id, Name, Opportunity__c, Opportunity__r.StageName,
                            Month_Date__c, Amount_Minus_Expense_Income__c, Opportunity_Name__c,
                            X12_Month_Cash_Minus_Expense_Income_EV__c ,
                            X18_Month_Cash_Minus_Expenses_Income_EV__c,
                            X24_Month_Cash_Minus_Expense_Income_EV__c,
                            Opportunity_Amount_Minus_Expense_Income__c,
                            Expected_Value_Minus_Expense__c,
                            Stage__c, Monthly_Recurring_Revenue_MRR__c,
                            Expected_Monthly_Recurring_Revenue_MRR__c
                            FROM Pipeline_Snapshot__c
                            WHERE Month_Date__c >=: firstDate
                            AND Month_Date__c <=: lastDate
                            AND Source_Type__c = 'Opportunity'
                            AND Stage__c != 'Total'];
        return records;
    }

    public void execute(Database.BatchableContext BC, List<Pipeline_Snapshot__c> scope) {
        NetEVDifferenceTriggerGateway helper = new NetEVDifferenceTriggerGateway();
        helper.processLastMonthSnapshots(scope);
    }

    public void finish(Database.BatchableContext BC) {
    }
}