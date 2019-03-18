global class WebcartPayDecScheduled implements Schedulable {
	//This will setup a job that runs at the top of the hour every hour of every day
	/*
ID jobId = System.schedule('WebcartPayDecScheduled',
'0 0 1/1 * * ?',
new WebcartPayDecScheduled());
*/
	global void execute(SchedulableContext sc) {
		WebcartBatch b = new WebcartBatch(0, WebcartHelper.TBL_SAVED_PAYMENTS); 
		b.startDeclineJob = true;
		database.executebatch(b, 1);
	}
}