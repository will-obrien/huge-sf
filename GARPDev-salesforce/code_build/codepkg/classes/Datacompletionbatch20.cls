global class Datacompletionbatch20 implements Database.Batchable<SObject>
{
    global set <Id> setContractIds = new Set <Id> ();
    global Id memRecType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    global Database.QueryLocator start(Database.BatchableContext BC){
        string strAcc = '001f000000iOg1E';
        return Database.getQueryLocator('select id,accountId from Contact where GARP_Member_ID__c!=null and accountId != null and KPI_Membership_Auto_Renew_Status__c = true order by accountId ASC');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){

        Map<Id,Id> mapAcct = new Map<Id,Id>();
        for(Contact ct : scope)
            mapAcct.put(ct.accountId,ct.accountId);

        system.debug('mapAcct == '+mapAcct);
        List<Contract> lstContract = new List<Contract>();
       
        for(Contract cont : [select id,accountId,recordTypeId from Contract where accountId in:  mapAcct.keyset() and recordTypeId =: memRecType and status =: 'Activated'])
        {
           
            cont.Status = 'Activated ( Auto-Renew )';
            lstContract.add(cont);

        }
        system.debug('lstContract == '+lstContract);

        
        if(lstContract.size() > 0)
            update lstContract;
    
    }
        
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}