global class Cls_BatchCreateOpportHistryWeeklySchd implements Schedulable{

    
    global void execute(SchedulableContext sc) {
        Cls_BatchCreateOpportHistryWeekly BtchCreateOpp = new Cls_BatchCreateOpportHistryWeekly();
        ID batchprocessid = Database.executeBatch(BtchCreateOpp,200);           
    }


}