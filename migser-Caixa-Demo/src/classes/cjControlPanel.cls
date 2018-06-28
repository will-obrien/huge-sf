public with sharing class cjControlPanel {

	public string emailAddy{get;set;}
	public List<CJSetting> settingList{get;set;}
	public ChatterJanitorSetting__c cjsNew{get;set;}
	public boolean addMode{get;set;}
	
	public class CJSetting{
		
		public ChatterJanitorSetting__c CJS{get;set;}
		public boolean selected{get;set;}
		public boolean editMode{get;set;}
		
		/*public CJSetting(){
			CJS = null;
			selected = false;
			editMode = false;
		}*/
		
		public CJSetting(ChatterJanitorSetting__c CJSInc)
		{
			CJS = CJSInc;
			selected=false;
			editMode = false;
		}
		
		public void saveSetting(){
			update cjs; 
			editSetting();
		}
		
		public void editSetting(){
			editMode = !editMode;
		}
		
		public void runSetting(){
			chatterJanitor.cleanObjects([select emailAddress__c from Chatter_JanitorCS__c where name = 'Admin Email'].emailAddress__c, new List<ChatterJanitorSetting__c> {cjs});
		}
		
		public void remSetting(){
			delete cjs;
			editMode = editMode;
		}
	}
	
	public boolean MADUser{get;set;}
	
	public cjControlPanel(){
		MADUser = [select permissionsModifyAllData from Profile where id = :UserInfo.getProfileId()].permissionsModifyAllData;
		addMode = false;
		cjsNew = new ChatterJanitorSetting__c();
				
		refreshList();
	} 

	public void makeSetting(){
		List<Chatter_JanitorCS__c> test = [select id, emailAddress__c from Chatter_JanitorCS__c where name = 'Admin Email' limit 1];
		if(test.size() == 0)
		{
			//no record, create a record
			Chatter_JanitorCS__c newEmail = new Chatter_JanitorCS__c();
			newEmail.name = 'Admin Email';
			newEmail.emailAddress__c = [select email from User where id = :UserInfo.getUserId()].email;
			insert newEmail;
			test.add(newEmail);
		}
		emailaddy = test[0].emailAddress__c;
	}

	public pageReference updateEmail(){
		Chatter_JanitorCS__c csUpdate = [select id from Chatter_JanitorCS__c where name = 'Admin Email'];
		csUpdate.emailAddress__c = emailAddy;
		update csUpdate;
		return new PageReference('/apex/cjControlPanel');
	}
	

	public void refreshList(){
		settingList = new List<CJSetting>();
		List<ChatterJanitorSetting__c> cjsTemp = [select active__c, id, Date_limit_no_of_type__c, date_limit_type__c, email_archival__c, name, object_name__c, skip_tracked_changes__c, skip_written_posts__c 
													from ChatterJanitorSetting__c order by object_name__c];
		if(cjsTemp.size() > 0)
			for(ChatterJanitorSetting__c cjs : cjsTemp){
				settingList.add(new CJSetting(cjs));
			}
	}
	
	public List<SelectOption> getSObjectList(){
		List<SelectOption> sobjList = new list<SelectOption>();
		
		Map<String, Schema.Sobjecttype> globalDesc = schema.getGlobalDescribe();
		Set<string> KeySet = globalDesc.keySet();
		
		Schema.DescribeSObjectResult dsor;
		for(string key : keySet)
		{
			dsor = globalDesc.get(key).getDescribe();
			if(dsor.isFeedEnabled())
				sobjList.add(new SelectOption(key,key));
		}
		return sobjList;
	}

	public void addSetting(){
		cjsNew = new ChatterJanitorSetting__c();
		addMode = true;
	}
	public void finishAdd(){
		insert cjsNew;
		refreshList();
		addMode = false;
	}
	
	public void cleanAll(){
		chatterjanitor.cleanHouse(emailAddy);
	}
	
	public void scrubOrg(){
		List<ChatterJanitorSetting__c> allofEm = new List<ChatterJanitorSetting__c>();
		List<SelectOption> soList = getSObjectList();
		ChatterJanitorSetting__c cjs; 
		for(SelectOption so : soList)
		{
			cjs = new ChatterJanitorSetting__c();
			cjs.Skip_Tracked_Changes__c = false;
			cjs.Skip_Written_Posts__c = false;
			cjs.Object_Name__c = so.getValue();
			cjs.email_archival__c = false;
			cjs.date_limit_type__c = 'Day(s)';
			cjs.Date_Limit_No_of_Type__c = 0.0;
			cjs.active__c = true;
			allofEm.add(cjs);
		}
		
		Chatterjanitor.cleanObjects(emailAddy, allofEm);
		
	}
	
}