/* teste de comentários */
public without sharing class LeadTriggerHandler {
    
    private boolean isExecuting = false;
    public List<Lead> oldRecordsList = null; 
    public List<Lead> newRecordsList = null;
    public Map<Id,Lead> oldRecordsMap = null;
    public Map<Id,Lead> newRecordsMap = null;
    public boolean isAfter = false;
    public boolean isBefore = false;
    public boolean isInsert = false;
    public boolean isUpdate = false;
    public boolean isDelete = false; 
    public boolean isUnDelete = false; 
    
    public Map<Id,Lead> oldRecordsMap_WUP = new Map<Id,Lead>();
    public Map<Id,Lead> newRecordsMap_WUP = new Map<Id,Lead>();
    
    public Map<Id,Lead> oldRecordsMap_MS = new Map<Id,Lead>();
    public Map<Id,Lead> newRecordsMap_MS = new Map<Id,Lead>();
    
    public User userSistema = UserDAO.getUsuarioSistema();
    //public map<Id, RecordType> mapRecs = RecordTypeDAO.mapRecordTypesBySobjectType('Lead');
    
    public LeadTriggerHandler(boolean isExecuting)
    {
        this.isExecuting = isExecuting;

    }
    
    public void OnBeforeInsert()
    {
        system.debug('LeadTriggerHandler.OnBeforeInsert');
        
        
    }
    
    public void OnAfterInsert()
    {
        system.debug('LeadTriggerHandler.OnAfterInsert ');

        
    }
    
    public void OnBeforeUpdate()
    {
        system.debug('LeadTriggerHandler.OnBeforeUpdate');

        separarLeadsTipoRegistro();
        //Lead_BO BO = new Lead_BO(userSistema, oldRecordsMap, newRecordsMap);
        
        if(newRecordsMap_WUP.size() > 0){
        	LeadWUP_BO WUP_BO = new LeadWUP_BO(userSistema, oldRecordsMap_WUP, newRecordsMap_WUP);
        	WUP_BO.BU_ExecuteWFLead();       
        }
        
        system.debug('newRecordsMap_MS ' + newRecordsMap_MS.size());
        if(newRecordsMap_MS.size() > 0){
        	LeadMS_BO MS_BO = new LeadMS_BO(userSistema, oldRecordsMap_MS, newRecordsMap_MS);
        	MS_BO.roletaAtribuirLeadMS();
        }
        
        // for(Lead L : newRecordsList ){
            // BO.process(l, oldRecordsMap.get(l.Id));
        // }
        
        // BO.finish();
    }
    
    public void OnAfterUpdate()
    {
        system.debug('LeadTriggerHandler.OnAfterUpdate');

    }
    
    public void OnBeforeDelete()
    {
        system.debug('LeadTriggerHandler.OnBeforeDelete');
        
    }
    
    public void OnAfterDelete()
    {
        system.debug('LeadTriggerHandler.OnAfterDelete');
        
    }
    
    public void OnUndelete()
    {
        system.debug('LeadTriggerHandler.OnUndelete');
        
    }
    
    public boolean IsTriggerContext
    {
        get{ return this.isExecuting;}
    }
    
    private void separarLeadsTipoRegistro(){
        system.debug('[LeadTriggerHandler] [separarLeadsTipoRegistro]');
        for(Lead newLead : newRecordsList){
            Lead oldLead = oldRecordsMap != null ? oldRecordsMap.get(newLead.Id) : null;
            if(newLead.RecordTypeId == Lead.SObjectType.getDescribe().getRecordTypeInfosByName().get('meuSucesso.com').getRecordTypeId()){
                if(oldLead != null){
                    oldRecordsMap_MS.put(oldLead.Id, oldLead);
                }
                newRecordsMap_MS.put(newLead.Id, newLead);			
            }else if(newLead.RecordTypeId == Lead.SObjectType.getDescribe().getRecordTypeInfosByName().get('Wise Up').getRecordTypeId()){
                if(oldLead != null){
                    oldRecordsMap_WUP.put(oldLead.Id, oldLead);
                }
                newRecordsMap_WUP.put(newLead.Id, newLead);
            }
            
        }
        
    }
    
}