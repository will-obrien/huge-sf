public with sharing class RSS2Chatter_AssociateObjectController {
	
	public string objectType {get; set;}
	public string searchTerm {get; set;}
	public List<accountWrapper> accounts {get; set;}
	public List<opptyWrapper> opportunities {get; set;}
	public List<campaignWrapper> campaigns {get; set;}
	public Integer recordCount {get; set;}
	private string rssId = '';
	public Boolean showAccResults {get{return recordCount>0 && objectType=='account';}set;}
	public Boolean showOppResults {get{return recordCount>0 && objectType=='opportunity';}set;}
	public Boolean showCamResults {get{return recordCount>0 && objectType=='campaign';}set;}
	
	public RSS2Chatter_AssociateObjectController(apexpages.standardController con){
		apexpages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'This screen allows you to search for the objects you wish to associate the rss feed to. Use the search area of the screen to find the objects you want to associate the feed with.');
		apexpages.addMessage(msg);
		recordCount = -1;
		RSS_Feed__c r = (RSS_Feed__c) con.getRecord();
		rssId = r.Id;
	}
	
	public pageReference searchfor(){
		if(searchTerm == ''){
			apexpages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Please enter some search criteria');
			apexpages.addMessage(msg);
			return null;
		}
		accounts = new List<accountWrapper>();
		campaigns = new List<campaignWrapper>();
		opportunities = new List<opptyWrapper>();
		searchTerm = '%' + searchTerm + '%';
		if (objectType =='account'){
			List<Account> acc = [select id, name from Account where name like : searchTerm];
			for(Account a : acc){
				accountWrapper aw = new accountWrapper(a);
				accounts.add(aw);
			}
		}else if (objectType =='campaign'){
			List<Campaign> cam = [select id, name from Campaign where name like : searchTerm];
			for(Campaign c : cam){
				campaignWrapper cw = new campaignWrapper(c);
				campaigns.add(cw);
			}
		}else if (objectType =='opportunity'){
			List<Opportunity> oppty= [select id, name from Opportunity where name like : searchTerm];
			for(Opportunity o : oppty){
				opptyWrapper ow = new opptyWrapper(o);
				opportunities.add(ow);
			}
		}
		
		recordCount = opportunities.size() + campaigns.size() + accounts.size();
		apexpages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Found ' + recordCount + ' matching records. Check the ' + objectType + ' records you would like to associate with the rss feed and then click "Add To Related Objects".');
		apexpages.addMessage(msg);
		searchTerm = '';
		return null;
	}
	
	public pagereference assignAccounts(){
		List<RSS_Feed_Related_Object__c> newObjects = new List<RSS_Feed_Related_Object__c>();
		for(accountWrapper aw : accounts ){
			if (aw.Checked){
				RSS_Feed_Related_Object__c ro = new RSS_Feed_Related_Object__c();
				ro.Account__c = aw.theObject.Id;
				ro.RSS_Feed__c = rssId;
				newObjects.add(ro);
			}
		}
		if (newObjects.size() > 0 ){
			insert(newObjects);
		}
		recordCount = -1;
		accounts = new List<accountWrapper>();
		campaigns = new List<campaignWrapper>();
		opportunities = new List<opptyWrapper>();
		return null; 
	}
	public pagereference assignOpportunities(){
		List<RSS_Feed_Related_Object__c> newObjects = new List<RSS_Feed_Related_Object__c>();
		for(opptyWrapper ow : Opportunities ){
			if (ow.Checked){
				RSS_Feed_Related_Object__c ro = new RSS_Feed_Related_Object__c();
				ro.Opportunity__c = ow.theObject.Id;
				ro.RSS_Feed__c = rssId;
				newObjects.add(ro);
			}
		}
		if (newObjects.size() > 0 ){
			insert(newObjects);
		}
		recordCount = -1;
		accounts = new List<accountWrapper>();
		campaigns = new List<campaignWrapper>();
		opportunities = new List<opptyWrapper>();
		return null;
	}
	public pagereference assignCampaigns(){
		List<RSS_Feed_Related_Object__c> newObjects = new List<RSS_Feed_Related_Object__c>();
		for(campaignWrapper cw : campaigns ){
			if (cw.Checked){
				RSS_Feed_Related_Object__c ro = new RSS_Feed_Related_Object__c();
				ro.Campaign__c = cw.theObject.Id;
				ro.RSS_Feed__c = rssId;
				newObjects.add(ro);
			}
		}
		if (newObjects.size() > 0 ){
			insert(newObjects);
		}
		recordCount = -1;
		accounts = new List<accountWrapper>();
		campaigns = new List<campaignWrapper>();
		opportunities = new List<opptyWrapper>();
		return null;
	}
	public class accountWrapper{
		public Account theObject {get; set;}
		public Boolean Checked {get; set;}
		
		public accountWrapper(Account o){
			theObject = o;
			Checked = false;
		}
	}
	
	public class opptyWrapper{
		public Opportunity theObject {get; set;}
		public Boolean Checked {get; set;}
		
		public opptyWrapper(Opportunity o){
			theObject = o;
			Checked = false;
		}
	}
	public class campaignWrapper{
		public Campaign theObject {get; set;}
		public Boolean Checked {get; set;}
		
		public campaignWrapper(Campaign o){
			theObject = o;
			Checked = false;
		}
	}
}