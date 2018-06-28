trigger autoRenwOnContract on Contract (after insert, after update) {
    
    
    Set<ID> setAccIds = new Set<ID>();
    Map<Id,Date> mapEndDate = new Map<ID,Date>();
    id memrecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    for(Contract objContract : trigger.new)
    {
        if(objContract.recordTypeId != memrecordTypeId || objContract.Membership_Type__c == 'Affiliate') continue;
        if(objContract.Enddate != null)
        {
            if(trigger.isUpdate)
            {
                if(trigger.oldMap.get(objContract.Id).Enddate != objContract.Enddate)
                    setAccIds.add(objContract.accountID);
            }
            else
                setAccIds.add(objContract.accountID);
            
            mapEndDate.put(objContract.accountID,objContract.Enddate);
        }
    
    }
    system.debug('setAccIds == '+setAccIds);
    if(setAccIds.size() > 0)
    {
        List<pymt__Payment_Profile__c> lstPayments = new List<pymt__Payment_Profile__c>();
        for(pymt__Payment_Profile__c objPay : [select id,pymt__Contact__c,pymt__Contact__r.accountId,pymt__Next_Payment_Date__c,pymt__Subscription_Start_Date__c 
                                                from pymt__Payment_Profile__c 
                                                where pymt__Contact__c in (select id from contact where accountId in: setAccIds) and pymt__Subscription_Status__c =: 'Active'])
                                                {
                                                    Date dtEndDate = mapEndDate.get(objPay.pymt__Contact__r.accountId);
                                                    if(objPay.pymt__Subscription_Start_Date__c != dtEndDate)
                                                    {
                                                        objPay.pymt__Next_Payment_Date__c = dtEndDate;
                                                        lstPayments.add(objPay);
                                                    }
                                                
                                                
                                                }
        system.debug('lstPayments== '+lstPayments);  
        if(lstPayments.size() > 0)
            update lstPayments;
    
    }

}