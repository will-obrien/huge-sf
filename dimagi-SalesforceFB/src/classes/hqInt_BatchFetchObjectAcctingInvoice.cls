public class hqInt_BatchFetchObjectAcctingInvoice implements Database.Batchable<Integer>,Database.AllowsCallouts,Database.Stateful {

    public integer batchNo;

    public hqInt_BatchFetchObjectAcctingInvoice(integer pbatchNo) {
        batchNo = pbatchNo;
    }

    public Iterable<Integer> start(Database.BatchableContext BC)  {
        return null;
    }

    public void execute(Database.BatchableContext info, List<Integer> offsetList)  {

     }

    public void finish(Database.BatchableContext info) {

    }

    public void updateMissingRelations() {
        // this method updates relation to the domain object from accounting invoice

    } 
}