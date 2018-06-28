global class RSS2Chatter_ScheduleGetRSS implements Schedulable{
	public string getRSSQuery = '';
	
    global void execute(SchedulableContext SC) {
		RSS2Chatter_GetRSS newPosts = new RSS2Chatter_GetRSS() ;
		if (getRSSQuery != ''){
			newPosts.soql = getRSSQuery;
		}
		Database.executeBatch(newPosts,1);
	}
    
}