trigger autoRenewPayments on pymt__Payment_Profile__c (after insert, after update) {
    
    Set<Id> setActiveContact = new Set<Id>();
    Set<Id> setSuspendedContact = new Set<Id>();
    List<String> lstPaypalRecIds = new List<String>();
     List<pymt__Payment_Profile__c> lstUpdatePaypalInfo = new List<pymt__Payment_Profile__c>();
    for(pymt__Payment_Profile__c obj : trigger.new)
    {
        if(obj.pymt__Subscription_Status__c  == 'Active')
            setActiveContact.add(obj.pymt__Contact__c);
        else if(obj.pymt__Subscription_Status__c  == 'Cancelled' && (!trigger.isInsert && trigger.oldMap.get(obj.Id).pymt__Subscription_Status__c != obj.pymt__Subscription_Status__c))
        {
            setSuspendedContact.add(obj.pymt__Contact__c);
            lstPaypalRecIds.add(obj.pymt__PayPal_Recurring_Payment_Id__c);
        
        }
       
        if(trigger.isUpdate && (trigger.oldMap.get(obj.Id).pymt__Next_Payment_Date__c != obj.pymt__Next_Payment_Date__c || trigger.oldMap.get(obj.Id).pymt__Amount__c != obj.pymt__Amount__c))
        {
            lstUpdatePaypalInfo.add(obj);
        }
            
    
    }
    system.debug('lstUpdatePaypalInfo1= '+lstUpdatePaypalInfo);
    
   
    if(setActiveContact.size() > 0)
    {
        List<Contact> lstContacts = new List<Contact>();
        Set<ID> setAccountIds = new Set<Id>();
        for(Contact objContact : [select id,accountId,KPI_Membership_Auto_Renew_Status__c from contact where id in: setActiveContact])
        {
            if(!objContact.KPI_Membership_Auto_Renew_Status__c)
            { 
                objContact.KPI_Membership_Auto_Renew_Status__c = true;
                lstContacts.add(objContact);
            }
            setAccountIds.add(objContact.accountId);
            
        }
        Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
         List<Contract> lstContracts = new List<Contract>();
        for(Contract objContr : [select id, Status ,RecordTypeId,accountId,Opportunity__c,ContractTerm,EndDate,startdate,Membership_Type__c from contract where  accountId in : setAccountIds and RecordTypeId =: memberRecordTypeID])
        {
            if(objContr.Status == 'Activated' || objContr.Status == 'Draft')
            {
                objContr.status = 'Activated ( Auto-Renew )';
                lstContracts.add(objContr);
            }
        }
        
        if(lstContracts.size() > 0)
            update  lstContracts;
        if(lstContacts.size() > 0)
            update lstContacts;
    
    
    }
    if(setSuspendedContact.size() > 0)
    {
        List<Contact> lstContacts = new List<Contact>();
        Set<ID> setAccountIds = new Set<Id>();
        for(Contact objContact : [select id,accountId,KPI_Membership_Auto_Renew_Status__c from contact where id in: setSuspendedContact])
        {
            if(!objContact.KPI_Membership_Auto_Renew_Status__c)
            { 
                objContact.KPI_Membership_Auto_Renew_Status__c = false;
                lstContacts.add(objContact);
            }
            setAccountIds.add(objContact.accountId);
            
        }
         Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
         List<Contract> lstContracts = new List<Contract>();
        for(Contract objContr : [select id, Status ,RecordTypeId,accountId,Opportunity__c,ContractTerm,EndDate,startdate,Membership_Type__c from contract where  accountId in : setAccountIds and RecordTypeId =: memberRecordTypeID])
        {
            if(objContr.Status == 'Activated ( Auto-Renew )')
            {
                objContr.status = 'Activated';
                lstContracts.add(objContr);
            }
        }
        
        if(lstContracts.size() > 0)
            update  lstContracts;
        if(lstContacts.size() > 0)
            update lstContacts;
    
    
    }
    
    if(!lstPaypalRecIds.isEmpty() && lstPaypalRecIds.size() < 10)
    {
        for(String str : lstPaypalRecIds)
        {
            cancelRecurringPayments.cancelRecurringPays(str);
        }
    }
    system.debug('lstUpdatePaypalInfo == '+lstUpdatePaypalInfo);
    if(!lstUpdatePaypalInfo.isEmpty() && lstUpdatePaypalInfo.size() < 10)
    {
        if(trigger.isExecuting)
        {
            for(pymt__Payment_Profile__c obj : lstUpdatePaypalInfo)
            {
                cancelRecurringPayments.updatePaymentAmount(obj.pymt__PayPal_Recurring_Payment_Id__c,obj.pymt__Amount__c,obj.pymt__Next_Payment_Date__c);
            }
        }
    }
    
    

}