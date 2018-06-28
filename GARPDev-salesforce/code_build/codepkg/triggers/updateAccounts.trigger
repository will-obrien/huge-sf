trigger updateAccounts on Contact (after update) {
    
    Set<Id> setAccountIds = new Set<Id>();
    Map<Id,Contact> mapContacts = new Map<Id,Contact>();
    Map<Id,Contact> mapexpirationdate = new Map<Id,Contact>();
    for(Contact cn : trigger.New)
    {
        if((cn.accountId != null && trigger.isInsert )|| (trigger.isUpdate && cn.AccountId != null )) {
            
            system.debug('* * * Contact Trigger ...'+ cn + ':' + UpdateAccountTriggerUtils.bPKIDRecusrive);
            
            mapContacts.put(cn.accountId,cn);
        }

        if((cn.KPI_Membership_Expiration_Date__c != null && trigger.isInsert) || (trigger.isUpdate && cn.KPI_Membership_Expiration_Date__c != null))
            mapexpirationdate.put(cn.accountId,cn);
         
    }
    
    if(!mapContacts.isEmpty() && !UpdateAccountTriggerUtils.bPKIDRecusrive)
    {
        UpdateAccountTriggerUtils.UpdatePKID(mapContacts);
        
    }
    
    if(!mapexpirationdate.isEmpty() && !UpdateAccountTriggerUtils.bExpirationRecusrive)
    {
        UpdateAccountTriggerUtils.UpdateExpirationDate(mapexpirationdate);
        
    }
    
    

}