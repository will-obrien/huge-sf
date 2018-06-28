global with sharing class DncBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts {
    private Date recheckItemsBefore;
    private String filter;
    private String[] fieldApiName;
    private String objectApiName;
    
    public DncBatchable(String objectApiName, String fieldApiName, Date recheckItemsBefore, String filter){
        this.recheckItemsBefore = recheckItemsBefore;
        this.filter = filter;
        this.objectApiName = objectApiName;
        this.fieldApiName = new String[]{fieldApiName};
    }
    
    public DncBatchable(String objectApiName, String[] fieldApiName, Date recheckItemsBefore, String filter){
        this.recheckItemsBefore = recheckItemsBefore;
        this.filter = filter;
        this.objectApiName = objectApiName;
        this.fieldApiName = fieldApiName;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date recheckItemsBefore = this.recheckItemsBefore;
        DNC.MetadataLookup mdl = DNC.getMetadataLookup(objectApiName, fieldApiName);
        
        string soql = 'Select Id';
        string whr = '';
        for ( DNC.MetadataLookupField field : mdl.fieldList ){
            soql += ', ' + field.field.name + ', ' + field.status.name + ', ' + field.checked.name;
            
            if ( whr == '' ){
                whr += ' WHERE (';
            }else{
                whr += ' OR ';
            }
            whr += ' ((' + field.checked.name + ' = null OR ' + field.status.name + ' = null OR ' + field.status.name + ' = \'Retryable Error\'';
            if ( recheckItemsBefore != null )
                whr += ' OR ' + field.checked.name + ' < :recheckItemsBefore';
            whr += ') AND ' + field.field.name + ' != null)';
        }
        
            
        if ( filter == null || filter.trim() == '' ){
            whr += ')';
        }else{
            whr += ') AND (' + filter + ')';
        }
        
        soql = soql + ' From ' + mdl.objectType + whr;
        return Database.getQueryLocator(soql);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        DNC.MetadataLookup mdl = DNC.getMetadataLookup(objectApiName, fieldApiName);
        
        //get all ids
        Map<Id, sObject> idMap = new Map<Id, sObject>();
        for ( sObject sobj : scope ){
            idMap.put(sobj.id, sobj);
        }
        List<Id> ids = new List<Id>();
        ids.addAll(idMap.keySet());

        //check that user has write access to these objects...
        List<sObject> validScope = new List<sObject>();
        for ( UserRecordAccess ura : [SELECT RecordId FROM UserRecordAccess WHERE HasEditAccess = true and UserId=:UserInfo.getUserId() AND RecordId IN :ids] ){
            validScope.add(idMap.get(ura.RecordId));
        }
        
        if ( validScope.size() > 0 ){
            //run only against fields we have access to.
            DNC.recalculate(validScope, mdl, mdl.fieldList, true, this.recheckItemsBefore);
            update validScope;
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
}