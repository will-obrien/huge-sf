public with sharing class RecheckController{
    public String inObjectApiName {get; set;}
    public String inFieldApiNames {get; set;}
    public Id inId {get; set;}
    
    public boolean isValid { get; set; }
    public string message { get; set; }
    
    public void init(){
        inObjectApiName = ApexPages.currentPage().getParameters().get('objectApiName');
        inFieldApiNames = ApexPages.currentPage().getParameters().get('fieldApiName');
        inId = ApexPages.currentPage().getParameters().get('recordId');
        
        //check user access...
        DNC.MetadataLookupResult[] status = DNC.checkCurrentUserWriteAccess(inObjectApiName, this.inFieldApiNames.split(','), new Id[]{inId});
        message = status[0].error;
        isValid = message == null;
    }
    
    public PageReference cancel(){
        if ( ApexPages.currentPage().getParameters().containsKey('retURL') ){
            return new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        }else{
            return new PageReference('/');
        }
    }
    
    public PageReference check(){
        DNC.MetadataLookup mdl = DNC.getMetadataLookup(inObjectApiName, this.inFieldApiNames.split(','));
        sObject[] objs = DNC.getRecords(mdl, new Id[]{inId});
        Map<Id, sObject> updated = new Map<Id, sObject>();
        if ( objs.size() > 0 ){
            for ( sObject obj : DNC.recalculate(objs, mdl, mdl.fieldList, false, null) ){
                updated.put(obj.Id, obj);
            }
        }
        update updated.values();
        return cancel();
    }
    
}