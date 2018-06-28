global class WebcartPullProductsScheduled implements Schedulable {
	
	global Boolean productsOnly = false;
	
	global void execute(SchedulableContext sc) {
		WebcartPullProducts b = new WebcartPullProducts(0, WebcartHelper.TBL_SAVED_PAYMENTS); 
		b.doProcessRecords = true;
		b.markAsProcessed = false;
		b.startDeclineJob = productsOnly ? false : true;
		b.startWebcartBatch = productsOnly ? false : true;
	    database.executebatch(b, 1);
	}
}