global class Datacompletionbatch18 implements Database.Batchable<SObject>
{
    global set <Id> setContractIds = new Set <Id> ();
    global Id memRecType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    global Database.QueryLocator start(Database.BatchableContext BC){
        string strAcc = '001f000000iOg1E';
        return Database.getQueryLocator('select id,accountId,Date_Joined__c from Contact where GARP_Member_ID__c!=null and accountId != null order by accountId ASC');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){

        Map<Id,Date> mapAcct = new Map<Id,Date>();
        for(Contact ct : scope)
            mapAcct.put(ct.accountId,ct.Date_Joined__c);

        system.debug('mapAcct == '+mapAcct);
        List<Contract> lstContract = new List<Contract>();
        decimal dCount = 0;
        Id recType = null;
        Map<Id,Id> mapAcctsWithOutMemership = new Map<Id,Id>();
        Set<Id> setAccountIds = new Set<Id>();
        for(Contract cont : [select id,accountId,recordTypeId from Contract where accountId in:  mapAcct.keyset()])
        {
           
            if(cont.recordTypeId == memRecType)
               setAccountIds.add(cont.accountId);

        }
        system.debug('setAccountIds == '+setAccountIds);

        for(Id acc : mapAcct.keySet())
        {
            //Check if this account has already member ship contract then dont create a new contract
            if(!setAccountIds.contains(acc))
            {
            Contract cont = new Contract();
                
                cont.accountId = acc;
                Date startDate = date.newInstance(1999, 01, 01);
                cont.StartDate = mapAcct.get(acc) == null ?  startDate : mapAcct.get(acc);
                Date dtToday = System.today();

                 Date dtStartDate = cont.StartDate; 
                 Integer iDiffMnths =dtStartDate.monthsBetween(dtToday); 
                 system.debug('iDiffMnths== '+iDiffMnths);
                 cont.ContractTerm = iDiffMnths + 12; 
                 system.debug('cont.ContractTerm == '+cont.ContractTerm);
                cont.Membership_Type__c ='Affiliate';
                cont.recordTypeId = memRecType;
                lstContract.add(cont);
            }
        }
        system.debug('lstContract == '+lstContract);
        if(lstContract.size() > 0)
            insert lstContract;

    List<Contract> lstActivateContracts = new List<Contract>();
        List<Contract> lstActivateContracts1 = [select id,Status,Clone_from__c from Contract where Id in: lstContract and Status =: 'Draft'];
        
        for(Contract objCon : lstActivateContracts1)
        {
            objCon.Status = 'Activated ( Auto-Renew )';
            lstActivateContracts.add(objCon);
        
        }
       
       update lstActivateContracts;
    
    
    
    }
        

        
    
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}