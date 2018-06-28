global class Cls_BatchCreateOpportHistryMonthlySchd implements Schedulable{

    global void execute(SchedulableContext sc) {
        Cls_BatchCreateOpportHistryMonthly BtchCreateOpp = new Cls_BatchCreateOpportHistryMonthly();
        ID batchprocessid = Database.executeBatch(BtchCreateOpp,200);           
    }
    

}