/**
 * Batch for synchronization Domain custom object form Commcare HQ.
 */
public with sharing class hqInt_MainClassBatch implements Database.Batchable<Integer>,Database.AllowsCallouts,Database.Stateful {

    public Iterable<Integer> start(Database.BatchableContext BC) {

        return null;
    }

    public void execute(Database.BatchableContext info, List<Integer> offsetList) {

    }

    public void finish(Database.BatchableContext info) {

    }
}