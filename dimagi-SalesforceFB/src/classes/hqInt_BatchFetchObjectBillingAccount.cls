public class hqInt_BatchFetchObjectBillingAccount implements Database.Batchable<Integer>,Database.AllowsCallouts,Database.Stateful {

    public hqInt_BatchFetchObjectBillingAccount(integer pbatchNo) {
    }

    public Iterable<Integer> start(Database.BatchableContext BC) {
        return null;
    }

    public void execute(Database.BatchableContext info, List<Integer> offsetList) {

     }

    public void finish(Database.BatchableContext info) {

    }
}