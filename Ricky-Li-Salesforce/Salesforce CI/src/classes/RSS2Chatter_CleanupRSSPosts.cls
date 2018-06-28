global class RSS2Chatter_CleanupRSSPosts implements Database.Batchable<sObject>{
	
	public String  soql = '';
	
	global  database.querylocator start(Database.BatchableContext bc){
		Integer cutoffDays = 0 - integer.valueof(chatterRSS__c.getInstance('RemoveAfter').Value__c);
		DateTime cutOff = DateTime.newInstance(Date.Today().addDays(cutoffDays), Time.newInstance(0,0,0,0));   
		
        if (soql == ''){
        	soql = 'select Id from RSS_Feed_Posts__c where LastModifiedDate < ' + cutOff.format('yyyy-MM-dd') + 'T00:00:00Z';
        } 
        return Database.getQueryLocator(soql);
    }
    
    global void execute(Database.BatchableContext bc, sObject[] objects){
    	
    	delete(Objects);
    	
    }
    
    global void finish(Database.BatchableContext bc){
    	
    }
}