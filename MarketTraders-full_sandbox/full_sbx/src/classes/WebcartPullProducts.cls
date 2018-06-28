global class WebcartPullProducts implements Database.Batchable<integer>, Database.AllowsCallouts, Database.Stateful {
	/*
	Here is how to kick off this batch job and do everything!
	WebcartPullProducts b = new WebcartPullProducts(0, WebcartHelper.TBL_SAVED_PAYMENTS); 
	b.doProcessRecords = true;
	b.markAsProcessed = false;
	b.startDeclineJob = true;
	b.startWebcartBatch = true;
    database.executebatch(b, 1);
	*/

	/*
	Here is how to kick off this batch job and just pull the products
	WebcartPullProducts b = new WebcartPullProducts(0, WebcartHelper.TBL_SAVED_PAYMENTS); 
	b.startWebcartBatch = false;
    database.executebatch(b, 1);
	*/
	global string webCartReportName = '';
	global integer sequenceNumber = 0;
	global boolean moreRecords = false;
	global boolean doProcessRecords = true; //Set this to false if we do not want to process records.   This would be done the first time they are entered.
	global boolean markAsProcessed = false;
	global boolean startDeclineJob = false;
	global boolean startWebcartBatch = true;
		
	global WebcartPullProducts(integer sequenceNumberParam, string reportName){
		webCartReportName = reportName;
		sequenceNumber = sequenceNumberParam;
	}

	global Iterable<integer> start(Database.BatchableContext info){  
       return new WebcartBatchIterable(sequenceNumber); 
    }     

   	global void execute(Database.BatchableContext BC, List<integer> scope) {
		boolean moreProducts = webCartHelper.doProductPull(sequenceNumber);
		moreRecords = moreProducts;
	}
	
	global void finish(Database.BatchableContext BC) {
		if(test.isRunningTest()){
			moreRecords = false; //We only want to run this once or we get the error Too many async jobs enqueued for this apex test context
			startWebcartBatch = false;
		}
		if(moreRecords){
			WebcartPullProducts b = new WebcartPullProducts(sequenceNumber + 1, webCartReportName); 
			b.startWebcartBatch = startWebcartBatch;
			b.doProcessRecords = doProcessRecords;
			b.markAsProcessed = markAsProcessed;
			b.startDeclineJob = startDeclineJob;
			database.executebatch(b, 1);
		}else{
			if(startWebcartBatch){
				WebcartBatch b = new WebcartBatch(0, webCartReportName); 
				b.doProcessRecords = doProcessRecords;
				b.markAsProcessed = markAsProcessed;
				b.startDeclineJob = startDeclineJob;
				database.executebatch(b, 1);	
			}			
		}
	}
	
}