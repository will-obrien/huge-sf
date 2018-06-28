global class Datacompletionbatch6 implements Database.Batchable<SObject>
{
    global Id frmRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
    global Id erpRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
    global Database.QueryLocator start(Database.BatchableContext BC){
        String prodCode = Default_Settings__c.getValues('Default').Prod_Code_952__c;
        return Database.getQueryLocator('select id,Opportunity.accountId,opportunityId,ProductCode from opportunityLineItem where ProductCode =: prodCode');
     }
    
    
    global void execute(Database.BatchableContext BC, List<opportunityLineItem> scope){
        Set<Id> setAccountIds = new Set<Id>();
        List<Contract> lstCons = new List<Contract>();
        for(opportunityLineItem opp : scope)
        {
            setAccountIds.add(opp.Opportunity.accountId);
        }
        
        for(Contract objCon : [select id,Enrollment_paid_for_2009__c from Contract where (recordTypeId =: frmRecordTypeID or recordTypeId =: erpRecordTypeID) and accountId in: setAccountIds])
        {

            objCon.Enrollment_paid_for_2009__c = true;
            lstCons.add(objCon);
        }
        if(lstCons.size() > 0)
            update lstCons;
        
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}