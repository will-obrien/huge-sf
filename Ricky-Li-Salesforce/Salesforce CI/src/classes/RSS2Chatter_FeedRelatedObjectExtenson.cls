public with sharing class RSS2Chatter_FeedRelatedObjectExtenson {
	public String rssId = '';
	public string ret{get;set;}
	public Boolean isTest = false;
	public RSS2Chatter_FeedRelatedObjectExtenson(apexpages.standardController con){
		
		RSS_Feed_Related_Object__c r = (RSS_Feed_Related_Object__c) con.getRecord();
		rssId = r.RSS_Feed__c;
		ret=apexpages.currentPage().getParameters().get('returl');
		
	}
	
	public pagereference rsspage(){
		if (rssId !='' && rssId != null && !isTest ){
			return new apexPages.Pagereference('/apex/RSS2Chatter_Associate_Objects?id=' + rssId);
		}else{
			String objId = ret.substring(1);
			string objType = '';
			if (objId.substring(0,3) == '001'){
				objType='account';
			} else if (objId.substring(0,3) == '701'){
				objType='campaign';
			} else if (objId.substring(0,3) == '006'){
				objType='opportunity';
			}
			return new apexPages.Pagereference('/apex/RSS2Chatter_AssociateFeedToObject?objtype=' + objtype + '&objid=' + objId);
		}
	}
}