global class WebcartScheduled implements Schedulable {
	global void execute(SchedulableContext sc) {
		/*
		First Run
		WebcartBatch b = new WebcartBatch(0, WebcartHelper.TBL_SAVED_PAYMENTS); 
		b.doProcessRecords = false;
		b.markAsProcessed = true;
		database.executebatch(b, 1);
		*/
		/* 
    //This will setup a job that runs 15 minutes after the top of the hour every hour of every day
ID jobId = System.schedule('WebcartScheduledX15',
'0 15 1/1 * * ?',
new WebcartScheduled());
*/
		WebcartBatch b = new WebcartBatch(0, WebcartHelper.TBL_SAVED_PAYMENTS); 
		database.executebatch(b, 1); //WebcartHelper.getWebCartBatchSize(WebcartHelper.INFUSIONSOFT)
	}
}