global class Schedule_WELCleanup implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		this.deleteWELRecords();
	}
	
	private void deleteWELRecords(){
		Logger logger = new Logger('Webinar Email Lookup Cleanup');
		try{
	   		list<Webinar_Email_Lookup__c> wel = [SELECT id FROM Webinar_Email_Lookup__c WHERE CreatedDate != LAST_N_DAYS:35];
	   		logger.logCollectionResults('Number of WEL records returned', wel.size());
	   		list<Database.DeleteResult> deleteResults = Database.delete(wel);
			integer successfulDelete = 0;
			for(Database.DeleteResult result : deleteResults){
				if(result.isSuccess())
					successfulDelete++;
			}
			logger.log(String.valueOf(successfulDelete) + ' WEL records deleted');
			logger.emailDebugResults(new list<String>{'webdev@markettraders.com','amalena@markettraders.com'});
		}catch(Exception ex){
			logger.log(ex);
			logger.emailDebugResults(new list<String>{'webdev@markettraders.com','amalena@markettraders.com'});
		}
	}
   
   	private static testMethod void unitTest(){
   		Schedule_WELCleanup m = new Schedule_WELCleanup();
   		m.deleteWELRecords();
		String sch = '20 30 8 10 2 ?';
		String jobID = system.schedule('Merge Job', sch, m);
   	}

}