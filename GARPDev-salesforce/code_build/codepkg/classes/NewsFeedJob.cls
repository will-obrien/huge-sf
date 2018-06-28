global class NewsFeedJob implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        //NewsFeed.GetFeedWrapper('bob'); 
        NewsFeed.getFeedMethod();  
    }
    
    
      global void finish(Database.BatchableContext SC){
         
       
    }
}