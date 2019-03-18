public with sharing class RSS2Chatter_PreviewController {
	public list <RSS_Feed_Posts__c> feedData {get;set;}
	public string feedId{get; set;}
	
	public RSS2Chatter_PreviewController(){
		feedId = apexpages.currentPage().getParameters().get('Id');
		RSS_Feed__c feed = [select Id, LastModifiedById, CreatedById, Name, Maximum_Posts_to_Read__c, url__c, Roll_Up_Posts__c from RSS_Feed__c where id = : feedId];
		RSS2Chatter_Main preview = new RSS2Chatter_Main();
		preview.main(feed,false);
		feedData = preview.rssPosts;
		if (preview.errorMessage !=''){
			apexPages.Message m = new ApexPages.Message(ApexPages.Severity.INFO, preview.errorMessage);
			apexpages.addMessage(m);
		}else{
			string msg = 'If there are post records on display then your feed is configured correctly. If there are no posts shown, then it may be an incompatible format, we currently only support ATOM and RSS 2 feeds.';
			apexPages.Message m = new ApexPages.Message(ApexPages.Severity.INFO, msg);
			apexpages.addMessage(m);
		}
	}
}