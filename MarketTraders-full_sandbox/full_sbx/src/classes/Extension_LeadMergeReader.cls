public with sharing class Extension_LeadMergeReader {
	
	private map<Id,Attachment> leadMergeMap {get;set;}
	private map<Id,Attachment> leadMergeHistoryMap = new map<Id,Attachment>();
	private map<Id,Id> leadToAttachmentMap = new map<Id,Id>();
	
	public String selectedMergedLeadId {get;set;}
	public String selectedMergedLeadAttachmentId {get;set;}
	
	public Lead selectedMergedLead {get;set;}
	public String JSONHistory {get;set;}
	public list<MergeHistory> selectedMergedLeadHistory {get;set;}
	
	public ApexPages.StandardSetController recordSetController {get;set;}
	public List<SObject> records {
        get {
        	if(this.recordSetController == null)
        		return new list<SObject>();
            return this.recordSetController.getRecords();
        }
    }
    
    public Boolean hasNext {
        get {
        	if(this.recordSetController == null)
        		return false;
            return this.recordSetController.getHasNext();            
        }
        set;
    }
    
    public Boolean hasPrevious {
        get {
        	if(this.recordSetController == null)
        		return false;
            return this.recordSetController.getHasPrevious();
        }
        set;
    }
    
    public void first() {
    	if(this.recordSetController != null){
        	this.recordSetController.first();
    	}
    }
  
    public void last() {
    	if(this.recordSetController != null){
        	this.recordSetController.last();
    	}
    }
  
    public void previous() {
    	if(this.recordSetController != null){
        	this.recordSetController.previous();
    	}
    }
  
    public void next() {
    	if(this.recordSetController != null){
        	this.recordSetController.next();
    	}
    }
    
    public integer getResultSize(){
    	return this.recordSetController.getResultSize();
    }
    
    public integer getPageNumber(){
    	return this.recordSetController.getPageNumber();
    }
    
    public integer getNumberOfPages(){
    	decimal remainder = math.mod(this.getResultSize(),this.recordSetController.getPageSize());
    	if(remainder == 0)
    		return (integer)this.getResultSize()/this.recordSetController.getPageSize();
    	else
    		return (integer)this.getResultSize()/this.recordSetController.getPageSize() + 1;
    }
	
	public Extension_LeadMergeReader(ApexPages.StandardController controller){
		Id leadId = controller.getId();
		this.leadMergeMap = new map<Id,Attachment>([SELECT Id,Name,Body FROM Attachment WHERE Name LIKE 'Merged Lead:%' AND ParentId = :leadId limit 50000]);
		list<Attachment> leadMergeHistoryList = [SELECT Id,Name,Body FROM Attachment WHERE Name LIKE 'Merged Lead History:%' AND ParentId = :leadId limit 50000];
		for(Attachment leadHistory : leadMergeHistoryList){
			String leadHistoryId = leadHistory.Name.split(':')[1];
			this.leadMergeHistoryMap.put(leadHistoryId,leadHistory);
		}
		list<Lead> leads = new list<Lead>();
    	list<Id> leadMergeMapIds = new list<Id>(this.leadMergeMap.keySet());
        leadMergeMapIds.sort();
        for(Id leadMergeId : leadMergeMapIds){
        	Attachment leadMerge = this.leadMergeMap.get(leadMergeId);
        	Lead mergedLead = (Lead)JSON.deserialize(leadMerge.Body.toString(), Lead.class);
        	if(this.selectedMergedLeadId == null)
        		this.selectedMergedLeadId = mergedLead.Id;
        	leadToAttachmentMap.put(mergedLead.Id,leadMergeId);
    		leads.add(mergedLead);
        }
		this.recordSetController = new ApexPages.StandardSetController(leads);
		recordSetController.setPageSize(5);
		list<Lead_Merger__c> leadMergerSettings = [SELECT id,Name,Field_Name__c,Order__c FROM Lead_Merger__c ORDER BY Order__c asc nulls LAST];
    	set<String> fieldNames = new set<String>();
    	fieldNames.add('Id');
    	for (Lead_Merger__c mergerSetting : leadMergerSettings){
    		fieldNames.add(mergerSetting.Field_Name__c);
        }
        if(!test.isRunningTest())
        	controller.addFields(new List<String>(fieldNames));
        setLead();
	}
	
	public list<Lead_Merger__c> getLeadMergerSettings(){
		list<Lead_Merger__c> leadMergerSettings = [SELECT id,Name,Field_Name__c,Order__c,Show_on_Table__c FROM Lead_Merger__c ORDER BY Order__c asc nulls LAST];
		return leadMergerSettings;
	}

    public void setLead() {
    	try{
    	if(this.selectedMergedLeadId != null && this.selectedMergedLeadId != '0' && this.leadMergeMap != null && this.leadToAttachmentMap != null){
    		this.selectedMergedLeadAttachmentId = leadToAttachmentMap.get(this.selectedMergedLeadId);
    		Attachment leadMerge = this.leadMergeMap.get(this.selectedMergedLeadAttachmentId);
    		this.selectedMergedLead = (Lead)JSON.deserialize(leadMerge.Body.toString(), Lead.class);
    		Attachment historyAttachment = this.leadMergeHistoryMap.get(this.selectedMergedLeadAttachmentId);
    		if(historyAttachment != null)
	        	this.selectedMergedLeadHistory = (list<MergeHistory>)JSON.deserialize(historyAttachment.Body.toString(), list<MergeHistory>.class);
    		else
    			this.selectedMergedLeadHistory = null;
    	}else{
    		this.selectedMergedLead = null;
    		this.selectedMergedLeadHistory = null;
    	}
    	}catch(Exception ex){
    		Logger logger = new Logger('set lead');
    		logger.log(ex.getMessage());
    		logger.log(ex.getStackTraceString());
    		logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
    	}
    }

    public Component.Apex.PageBlockSection getMergedLeadSection() {
    	if(this.selectedMergedLeadId != null && this.selectedMergedLeadId != '0'){
	        Component.Apex.PageBlockSection section = new Component.Apex.PageBlockSection();
	        section.expressions.rendered = '{!selectedMergedLead != null}';
	        section.id = 'selectedMergedLead';
	        section.columns = 2;
	        section.expressions.title = 'Lead Details ({!selectedMergedLeadId})';
	        
	        list<Lead_Merger__c> leadMergerSettings = [SELECT id,Name,Field_Name__c,Order__c FROM Lead_Merger__c ORDER BY Order__c asc nulls LAST];
	    	for (Lead_Merger__c mergerSetting : leadMergerSettings){
            	section.ChildComponents.add(getMergedLeadSectionItem(mergerSetting.Name,mergerSetting.Field_Name__c));
	        } 
	        return section;
    	}else{
    		return null;
    	}
	}
	
	@testVisible private Component.Apex.PageBlockSectionItem getMergedLeadSectionItem(String name,String apiName){
		Component.Apex.PageBlockSectionItem item = new Component.Apex.PageBlockSectionItem();
		Component.Apex.OutputLabel label = new Component.Apex.OutputLabel();
		label.value = name;
		label.for = apiName;
		item.ChildComponents.add(label);
		Component.Apex.OutputField field = new Component.Apex.OutputField();
		field.id = apiName;
		field.expressions.value = '{!selectedMergedLead.' + apiName +'}';
		item.ChildComponents.add(field);
		return item;
	}
	
	public Component.Apex.PageBlockTable getMergedLeadHistorySection() {
    	if(this.selectedMergedLeadHistory != null){
	        
	        Component.Apex.PageBlockTable mergedHistoryTable = new Component.Apex.PageBlockTable();
	        mergedHistoryTable.expressions.value = '{!selectedMergedLeadHistory}';
	        mergedHistoryTable.var = 'history';
	        mergedHistoryTable.expressions.title = 'Lead History ({!selectedMergedLeadId})';
	        
	        Component.Apex.Column createdDateColumn = new Component.Apex.Column();
	        createdDateColumn.expressions.value = '{!history.CreatedDate}';
	        createdDateColumn.headerValue = 'Created Date';
	        mergedHistoryTable.ChildComponents.add(createdDateColumn);
	        
	        Component.Apex.Column fieldName = new Component.Apex.Column();
	        fieldName.expressions.value = '{!history.field}';
	        fieldName.headerValue = 'Field';
	        mergedHistoryTable.ChildComponents.add(fieldName);
	        
	        Component.Apex.Column oldValue = new Component.Apex.Column();
	        oldValue.expressions.value = '{!history.oldValue}';
	        oldValue.headerValue = 'Old Value';
	        mergedHistoryTable.ChildComponents.add(oldValue);
	        
	        Component.Apex.Column newValue = new Component.Apex.Column();
	        newValue.expressions.value = '{!history.newValue}';
	        newValue.headerValue = 'New Value';
	        mergedHistoryTable.ChildComponents.add(newValue);
	        
	        return mergedHistoryTable;
	        
    	}else{
    		return null;
    	}
	}

}