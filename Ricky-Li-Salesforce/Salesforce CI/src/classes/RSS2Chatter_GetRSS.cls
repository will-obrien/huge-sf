global class RSS2Chatter_GetRSS implements Database.Batchable<sObject>, Database.AllowsCallouts{
	
	public String  soql = '';
	public Boolean isTest = false;
	public String testReturnXML = '';
	
	global  database.querylocator start(Database.BatchableContext bc){
            if (soql == ''){
            	soql = 'select Id, LastModifiedById, CreatedById, Name, Maximum_Posts_to_Read__c, url__c, Roll_Up_Posts__c from RSS_Feed__c where active__c = true order by name';
            }
            return Database.getQueryLocator(soql);
        }
        
        global void execute(Database.BatchableContext bc, sObject[] objects){
        	for(SObject so : objects){
        		RSS_Feed__c rss;
        		rss = (RSS_Feed__c) so;
        		RSS2Chatter_Main main = new RSS2Chatter_Main();
        		main.isTest = isTest;
        		main.testReturnXML = testReturnXML;
        		main.main(rss, true); 
        	}
        }
                
        global void finish(Database.BatchableContext bc){
        	
        }
}