global class WebcartScheduledDeclines implements Schedulable {
    global void execute(SchedulableContext sc) {
        /*
        First Run
        WebcartBatch b = new WebcartBatch(0, WebcartHelper.TBL_SAVED_DECLINES); 
        b.doProcessRecords = false;
        b.markAsProcessed = true;
        database.executebatch(b, 1);
        */
        //WebcartBatch b = new WebcartBatch(WebcartHelper.TBL_SAVED_DECLINES); 
        //database.executebatch(b, WebcartHelper.getWebCartBatchSize(WebcartHelper.INFUSIONSOFT));
        WebcartBatch b = new WebcartBatch(0, WebcartHelper.TBL_SAVED_DECLINES); 
        database.executebatch(b, 1); //WebcartHelper.getWebCartBatchSize(WebcartHelper.INFUSIONSOFT)
    }
}