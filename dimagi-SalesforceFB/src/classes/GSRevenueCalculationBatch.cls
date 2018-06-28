/**
 * Calculates GS revenue for Dimagi Contracts. It calcualtes it for one Business Unit.
 */
public without sharing class GSRevenueCalculationBatch implements Database.Batchable<DContract__c>, Database.Stateful{


    public GSRevenueCalculationBatch(List<Business_Unit__c> businessUnits) {

    }

    public List<DContract__c> start(Database.BatchableContext BC) {
        return new List<DContract__c>();
    }

    public void execute(Database.BatchableContext BC, List<DContract__c> scope) {

    }

    public void finish(Database.BatchableContext BC) {

    }

    private Map<Id, Decimal> getHistoryMap(List<DContract__c> scope) {
        Map<Id, Decimal> historyMap = new Map<Id, Decimal> ();
        return historyMap;
    }

    private Map<Id, Decimal> getTestDate(List<DContract__c> scope) {
        Map<Id, Decimal> historyMap = new Map<Id, Decimal> ();
        for (DContract__c con : scope) {
            if (con.Name == 'Sample Test 1') {
                historyMap.put(con.Id, 5);
            } else if (con.Name == 'Sample Test 2') {
                historyMap.put(con.Id, 30);
            } else if (con.Name == 'Sample Test 3') {
                historyMap.put(con.Id, 22);
            }
        }

        return historyMap;
    }

}