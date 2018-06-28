public class hqInt_BatchFetchObjectBillingContactInfo implements Database.Batchable<Integer>,Database.AllowsCallouts,Database.Stateful {

    public hqInt_BatchFetchObjectBillingContactInfo(Integer pbatchNo) {
    }

    public Iterable<Integer> start(Database.BatchableContext BC) {
        return null;
    }

    public void execute(Database.BatchableContext info, List<Integer> offsetList) {

     }

    public void finish(Database.BatchableContext info) {

    }
}