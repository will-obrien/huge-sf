public with sharing class Extension_AccountMergeReader {
    
   public map<Id,Attachment> accountMergeMap {get;set;}
   private map<Id,Attachment> accountMergeHistoryMap = new map<Id,Attachment>(); 
   map<id,id> acctToAttachmentMap = new map<Id,ID>();
   Map<id,Account> acctIdToAccount = new Map<id,Account>();
   public String mergeId {get;set;}
   public list<Account> accts {get;set;}
    
   public String selectedMergedAccountId {get;set;}
   public Account selectedMergedAccount {get;set;}
   public List<Account_Merger__c> accountMergerSettings {get;set;}

    
   public ApexPages.StandardSetController recordSetController {get;set;}
 
    
    public Extension_AccountMergeReader(ApexPages.StandardController controller){
        Id accountId = controller.getId();
        this.accountMergeMap = new map<Id,Attachment>([SELECT Id,Name,Body FROM Attachment WHERE Name LIKE 'Merged Account:%' AND ParentId = :accountId limit 50000]);
        list<Attachment> accountMergeHistoryList = [SELECT Id,Name,Body FROM Attachment WHERE Name LIKE 'Merged Account History:%' AND ParentId = :accountId limit 50000];
        for(Attachment accountHistory : accountMergeHistoryList){
            String accountHistoryId = accountHistory.Name.split(':')[1];
            this.accountMergeHistoryMap.put(accountHistoryId,accountHistory);
        }
        accountMergerSettings = Account_Merger__c.getall().values();
        accts = new list<Account>();
        list<Id> acctMergeMapIds = new list<Id>(this.accountMergeMap.keySet());
        acctMergeMapIds.sort();
        for(Id acctMergeId : acctMergeMapIds){
          Attachment acctMerge = this.accountMergeMap.get(acctMergeId);
          Account mergedAccount = (Account)JSON.deserialize(acctMerge.Body.toString(), Account.class);
          	acctToAttachmentMap.put(mergedAccount.Id,acctMergeId);
            acctIdToAccount.put(mergedAccount.Id,mergedAccount);
        	accts.add(mergedAccount);
        }
        this.recordSetController = new ApexPages.StandardSetController(accts);
    }
    
    public List<SelectOption> getMergedAccounts() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','--Select--'));
        for(Account acct: accts){
            options.add(new SelectOption(acct.id,'Merged Account: '+acct.id));           
        }
        return options;
    }
    
    public PageReference setAccount(){
        if(selectedMergedAccountId == null){
           selectedMergedAccountId = ApexPages.currentPage().getParameters().get(mergeId);
        }
        if(this.selectedMergedAccountId != null && this.selectedMergedAccountId != '0' && accountMergeMap != null ){
            this.selectedMergedAccount = acctIdToAccount.get(selectedMergedAccountId);            
        }else{
            this.selectedMergedAccount = null;
        }        
        return null;
    }
    
    public Component.Apex.PageBlockSection getMergedAccountSection() {
        if(this.selectedMergedAccountId != null && this.selectedMergedAccountId != '0'){
            Component.Apex.PageBlockSection section = new Component.Apex.PageBlockSection();
            section.expressions.rendered = '{!selectedMergedAccount != null}';
            section.id = 'selectedMergedAccount';
            section.columns = 2;
            section.title = 'Merged Account';
            
            for (Account_Merger__c mergerSetting : accountMergerSettings){
                section.ChildComponents.add(getMergedAccountSectionItem(mergerSetting.Name,mergerSetting.Field_Name__c));
            } 

            return section;
        }else{
            return null;
        }
    }
    
    @testVisible private Component.Apex.PageBlockSectionItem getMergedAccountSectionItem(String name,String apiName){
        Component.Apex.PageBlockSectionItem item = new Component.Apex.PageBlockSectionItem();
        Component.Apex.OutputLabel label = new Component.Apex.OutputLabel();
        label.value = name;
        label.for = apiName;
        item.ChildComponents.add(label);
        Component.Apex.OutputField field = new Component.Apex.OutputField();
        field.id = apiName;
        field.expressions.value = '{!selectedMergedAccount.' + apiName +'}';
        item.ChildComponents.add(field);
        return item;
    }

}