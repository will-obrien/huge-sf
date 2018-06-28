trigger OnContactAddUpdate on Contact (after insert, before update) {
    List<Account> updateActs = new List<Account>();
    Map<Id,Contact> mapaccountIds = new Map<Id,Contact>();
    Set<Id> setCertifiedContacts = new Set<Id>();
    
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        
        for(Contact obj : trigger.New) {
            mapaccountIds.put(obj.accountId,obj);
            
            if(obj.KPI_ERP_Certified__c || obj.KPI_FRM_Certified__c)
                setCertifiedContacts.add(obj.Id);    
            
            if(trigger.oldMap.get(obj.Id).GARP_Directory_Opt_In__c == false && obj.GARP_Directory_Opt_In__c == true) {
                obj.GARP_Directory_Opt_In_Date__c = system.today();
            }
            
            else if(trigger.oldMap.get(obj.Id).GARP_Directory_Invite_Opt_Out__c == false && obj.GARP_Directory_Invite_Opt_Out__c == true) {
                obj.GARP_Directory_Opt_Out_Date__c = system.today();
                
            }  
        }
    } else {
        for(Contact obj : trigger.New) {
            mapaccountIds.put(obj.accountId,obj);
            
            if(obj.KPI_ERP_Certified__c || obj.KPI_FRM_Certified__c)
                setCertifiedContacts.add(obj.Id);    
        }
        
    }
    
    //List<Account> acts = [select Id, Name, Member_Email__c from Account where Id in :mapaccountIds.keySet()];
    
    //for(Account act :acts) {
    //    Contact objContact = mapaccountIds.get(act.Id);
    //    if(objContact.KPI_Member__c == true) {
    //        act.Member_Email__c = objContact.Email;
    //        updateActs.add(act);
    //    }  
    //}
    
    //update updateActs;
    
    
    if(setCertifiedContacts.size() > 0)
    {
        List<pymt__Payment_Profile__c> lstPayments = new List<pymt__Payment_Profile__c>();
        for(pymt__Payment_Profile__c objRecPayments : [select id,pymt__Subscription_Status__c,pymt__Amount__c from pymt__Payment_Profile__c
                                                        where pymt__Contact__c in: setCertifiedContacts and pymt__Subscription_Status__c =: 'Active' and pymt__Amount__c != 150])
        {
            objRecPayments.pymt__Amount__c = 150;
            lstPayments.add(objRecPayments);
            
        }
        
        if(!lstPayments.isEmpty())
            update lstPayments;
    }
    
    
}